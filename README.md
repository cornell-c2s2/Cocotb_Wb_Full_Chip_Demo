# c2s2demo_fall2023

write something to introduce...

include block diagram...

To run the demo, we will start by creating a directory where we clone the demo and the caravel reposotories.<br />
```
mkdir -p ${HOME}/wb_demo
```
```
cd ${HOME}/wb_demo
```
```
git clone git@github.com:efabless/caravel_user_project.git caravel_user_project
```
```
git clone git@github.com:ayc62/c2s2demo_fall2023.git
```

Next, we have to setup the caravel environment with our demo code. Let's copy the design files into caravel:<br />
```
cp c2s2demo_fall2023/*.v caravel_user_project/verilog/rtl/
```

And let's copy our tests into caravel:<br />
```
cp -a c2s2demo_fall2023/test/. caravel_user_project/verilog/dv/cocotb/
```

Now, we have to modify the include paths for both the verilog and cocotb tests. For the cocotb tests:<br />
```
echo -e "from loopback_test.loopback_test import loopback_test\nfrom wb_module_test.wb_module_test import wb_module_test\nfrom gpio_module_test.gpio_module_test import gpio_module_test\nfrom wb_adder_test.wb_adder_test import wb_adder_test\nfrom wb_fadd_test.wb_fadd_test import wb_fadd_test" >> caravel_user_project/verilog/dv/cocotb/cocotb_tests.py
```

For the verilog design files:<br />
```
echo -e "-v \$(USER_PROJECT_VERILOG)/rtl/adder.v\n-v \$(USER_PROJECT_VERILOG)/rtl/wishbone.v\n-v \$(USER_PROJECT_VERILOG)/rtl/regs.v\n-v \$(USER_PROJECT_VERILOG)/rtl/crossbars.v\n-v \$(USER_PROJECT_VERILOG)/rtl/muxes.v\n-v \$(USER_PROJECT_VERILOG)/rtl/xls.v\n-v \$(USER_PROJECT_VERILOG)/rtl/demo_wrapper.v" >> caravel_user_project/verilog/includes/includes.rtl.caravel_user_project
```

Finall, we have to instantiate our design in the caravel wrapper. Comment out the user_proj_example module and copy the following code into caravel_user_project/verilog/rtl/user_project_wrapper.v:<br />


```
    Demo_Wrapper demo (
    // ‘ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
    	.vssd1(vssd1),	// User area 1 digital ground
    // ‘endif
        //inputs
        .wb_clk_i  (wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .switch_crossbar_control(io_in[0]),
        .switch_crossbar_control_en(io_oeb[0]),

        //proc ->  wb
        .wbs_stb_i(wbs_stb_i),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i (wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_adr_i(wbs_adr_i),

        //wb -> proc
        .wbs_ack_o(wbs_ack_o),
        .wbs_dat_o(wbs_dat_o),

        .gpio_input(io_in[17:10]),
        .gpio_input_en(io_oeb[17:10]),
        .gpio_output(io_out[25:18]),
        .gpio_output_en(io_oeb[25:18]),
        .gpio_istream_val(io_in[26]),
        .gpio_istream_val_en(io_oeb[26]),
        .gpio_istream_rdy(io_out[27]),
        .gpio_istream_rdy_en(io_oeb[27]),
        .gpio_ostream_val(io_out[28]),
        .gpio_ostream_val_en(io_oeb[28]),
        .gpio_ostream_rdy(io_in[29]),
        .gpio_ostream_rdy_en(io_oeb[29]),
        .gpio_xbar_config(io_in[9]),
        .gpio_xbar_config_en(io_oeb[9]),
        .gpio_xbar_val(io_in[8]),
        .gpio_xbar_val_en(io_oeb[8])
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
cd verilog/dv/cocotb
```

You can now run a given test, such as the loopback test, with the following command:
```
caravel_cocotb -test loopback_test -tag loopback_test
```
