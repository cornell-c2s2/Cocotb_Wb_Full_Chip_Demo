"""
Copyright Matt Venn 2023
"""

from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb

ERROR_GPIO = 31
NUM_TESTS = 1
# // .gpio_input(io_in[17:10]), input
# // .gpio_output(io_in[25:18]), output
# // .gpio_istream_val(io_in[26]), input
# // .gpio_istream_rdy(io_in[27]), output
# // .gpio_ostream_val(io_in[28]), output
# // .gpio_ostream_rdy(io_in[29]), input
# // .gpio_xbar_config(io_in[9]), input
# // .gpio_xbar_val(io_in[8]), input
GPIO_XBAR_CONFIG = 9
GPIO_XBAR_VAL = 8  

@cocotb.test()
@report_test
async def gpio_module_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=200000)

    cocotb.log.info(f"[TEST] wait for configuration")  
    await caravelEnv.release_csb() # Set the SPI CSB  signal high impedance
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info(f"[TEST] finished configuration") 
    
    caravelEnv.drive_gpio_in(0, 0)
    caravelEnv.drive_gpio_in(9, 1)
    caravelEnv.drive_gpio_in(8, 1)
    cocotb.triggers.ClockCycles(caravelEnv.clk, 3)
    
    cocotb.log.info(f"[TEST] finished configuring crossbars") 
    

    # configure wishbone
    caravelEnv.drive_gpio_in(GPIO_XBAR_CONFIG, 1)
    caravelEnv.drive_gpio_in(GPIO_XBAR_VAL, 1)
    caravelEnv.drive_gpio_in(29, 0)
    caravelEnv.drive_gpio_in(26, 0)
    
    await cocotb.triggers.ClockCycles(caravelEnv.clk, 1)

    cocotb.log.info(f"[TEST] 0.") 

    caravelEnv.drive_gpio_in((17,10), 0xEF)
    caravelEnv.drive_gpio_in(26, 1)
    await cocotb.triggers.ClockCycles(caravelEnv.clk, 5)
    
    #write out
    caravelEnv.drive_gpio_in(29, 1)
    result = caravelEnv.monitor_gpio(25, 18).binstr
    cocotb.log.info(f"[RESULT] '{result}'.") 

    # extra 1000 cycles to make it easier to see the end of the trace
    await cocotb.triggers.ClockCycles(caravelEnv.clk, 1000)
