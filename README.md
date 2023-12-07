# c2s2demo_fall2023

write something to introduce...

include block diagram...

To run the demo, we will start by creating a directory where we clone the demo and the caravel reposotories.<br />
```
mkdir -p ${HOME}/c2s2/wb_demo
```
```
cd ${HOME}/c2s2/wb_demo
```
```
git clone git@github.com:efabless/caravel_user_project.git caravel_user_project
```
```
git clone git@github.com:ayc62/c2s2demo_fall2023.git
```

Next, we have to setup the caravel environment with our demo code. Let's copy the design files into caravel:<br />
```
cp wb_demo/*.v caravel_user_project/verilog/rtl/
```

And let's copy our tests into caravel:<br />
```
cp -a wb_demo/test/. caravel_user_project/verilog/dv/cocotb/
```

Now, we have to modify the include paths for both the verilog and cocotb tests. For the cocotb tests:<br />
```
echo -e "from loopback_test.loopback_test import loopback_test\nfrom wb_module_test.wb_module_test import wb_module_test" >> caravel_user_project/verilog/dv/cocotb/cocotb_tests.py
```

For the verilog design files:<br />
```
echo -e "-v $(USER_PROJECT_VERILOG)/rtl/adder.v\n-v $(USER_PROJECT_VERILOG)/rtl/wishbone.v\n-v $(USER_PROJECT_VERILOG)/rtl/serializer.v\n-v $(USER_PROJECT_VERILOG)/rtl/deserializer.v\n-v $(USER_PROJECT_VERILOG)/rtl/regs.v\n-v $(USER_PROJECT_VERILOG)/rtl/crossbars.v\n-v $(USER_PROJECT_VERILOG)/rtl/demo_wrapper.v" >> caravel_user_project/verilog/includes/includes.rtl.caravel_user_project
```

Finall, we have to instantiate our design in the caravel wrapper. Copy the following code into caravel_user_project/verilog/rtl/user_project_wrapper.v:<br />


```
 Demo_Wrapper demo (
  // ‘ifdef USE_POWER_PINS
      .vccd1(vccd1),  // User area 1 1.8V power
      .vssd1(vssd1),  // User area 1 digital ground
  // ‘endif
      //inputs
      .wb_clk_i  (wb_clk_i),
      .wb_rst_i(wb_rst_i),
      .crossbar_control(io_in[10]),
      .crossbar_control_en(io_oeb[10]),

      //proc ->  wb
      .wbs_stb_i(wbs_stb_i),
      .wbs_cyc_i(wbs_cyc_i),
      .wbs_we_i (wbs_we_i),
      .wbs_sel_i(wbs_sel_i),
      .wbs_dat_i(wbs_dat_i),
      .wbs_adr_i(wbs_adr_i),

      //wb -> proc
      .wbs_ack_o(wbs_ack_o),
      .wbs_dat_o(wbs_dat_o)
  );
```

To run the cocotb tests, first set up your environment.
```
source setup-c2s2.sh
```
```
cd caravel_user_project
```
```
make install check-env install_mcw setup-timing-scripts setup-cocotb
```

Enter the cocotb folder where our tests are located:
```
cd caravel_user_project/verilog/dv/cocotb
```

You can now run a given test, such as the loopback test, with the following command:
```
caravel_cocotb -test loopback_test -tag loopback_test
```
