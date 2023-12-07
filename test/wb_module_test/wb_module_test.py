"""
Copyright Matt Venn 2023
"""

from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb

ERROR_GPIO = 31
NUM_TESTS = 5

@cocotb.test()
@report_test
async def wb_module_test(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=50000)

    cocotb.log.info(f"[TEST] wait for configuration")  
    await caravelEnv.release_csb() # Set the SPI CSB  signal high impedance
    await caravelEnv.wait_mgmt_gpio(1)
    cocotb.log.info(f"[TEST] finished configuration") 
    
    caravelEnv.drive_gpio_in(10, 1)
    
    cocotb.log.info(f"[TEST] finished configuring crossbars") 
    
    await caravelEnv.wait_mgmt_gpio(0)  # wait for management GPIO value to be 0
    await caravelEnv.wait_mgmt_gpio(1) # wait for management GPIO value to be 1

    for i in range(NUM_TESTS):

        # sync with firmware
        await caravelEnv.wait_mgmt_gpio(0)  # wait for management GPIO value to be 0
        await caravelEnv.wait_mgmt_gpio(1) # wait for management GPIO value to be 1

        # read the error pin
        error_pin = int ((caravelEnv.monitor_gpio(ERROR_GPIO).binstr),2)

        cocotb.log.info(f"[TEST] {i}.") 
        
        if error_pin:
            cocotb.log.error(f"ruh roh!")

    # extra 1000 cycles to make it easier to see the end of the trace
    await cocotb.triggers.ClockCycles(caravelEnv.clk, 1000)
