# Cocotb_Wb_Full_Chip_Demo

## Overview 
This repo features two modules that perform addition by 1 in integer and fp32 formats. Inputs can be entered through either the wishbone or a set of GPIOs, which is toggled by a switch connected to one of the GPIOs. The fp32 module was generated using XLS and features 4 pipeline stages.<br /> 

![Alt text](./imgs/blockdiagram.png?raw=true "Title")

More info on the wishbone design can be seen on the [C2S2 wiki page](https://confluence.cornell.edu/display/c2s2/Wishbone+bus). 

The wishbone interface allows the RISC-V processor to communicate to the user space through memory-mapped IOs. The mapping used in this repo is listed below:

| Address     | Hardware          |
| ----------- | ----------------- |
| 0x30000000  | Loopback Register |
| 0x30000004  | Error Register    |
| 0x30000008  | FP32 Add 1        |
| 0x3000000c  | Integer Add 1     |

Full chip simulation is performed using the cocotb testing framework, located in the test folder. The c firmware allows us to configure the chip and read/write to/from the user space. The python allows us to interact with the chip (i.e. toggle gpios, tick the clock). A short description of the tests is listed below:

| Test     | Description          |
| ----------- | ----------------- |
| wb_module_test  | Configures the chip to take inputs through wishbone; performs interleaved reads/writes to the fadd and integer add modules, and checks the error register |
| gpio_module_test  | Configures the chip to take inputs through GPIO; writes and reads the integer add module through GPIO  |
| loopback_test  | Writes and reads to the loopback register using wishbone   |
| wb_adder_test  | Writes and reads to the integer add 1 module using wishbone      |
| wb_fadd_test  | Writes and reads to the fp32 add 1 module using wishbone    |

## Instructions to run

First, log into the c2s2 server. To run the demo, we will start by creating a directory where we clone the demo and the caravel reposotories.<br />
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
git clone git@github.com:ayc62/Cocotb_Wb_Full_Chip_Demo.git
```

Next, we have to setup the caravel environment with our demo code. Let's copy the design files into caravel:<br />
```
cp Cocotb_Wb_Full_Chip_Demo/*.v caravel_user_project/verilog/rtl/
```

And let's copy our tests into caravel:<br />
```
cp -a Cocotb_Wb_Full_Chip_Demo/test/. caravel_user_project/verilog/dv/cocotb/
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
