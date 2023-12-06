// copyright Matt Venn 2023

#include <firmware_apis.h>
#include <assert.h>

#define NUM_TESTS 5
#define reg_loopback      (*(volatile uint32_t*)0x30000000)
#define reg_adder         (*(volatile uint32_t*)0x30000004)
#define LOOPBACK_OFFSET 0
#define ADDER_OFFSET 4
#define ERROR_GPIO 31
#define DELAY_GPIO 30

uint32_t input_values[NUM_TESTS] = {1, 0x00F0, 0x0F00, 0xF000, 0xFFFF};
int delay_values[NUM_TESTS] = {0, 1, 5, 4, 3};

void test(uint32_t input, int delay) {

    // USER_writeWord(input, LOOPBACK_OFFSET);
    reg_loopback = input;

    dummyDelay(delay); // Insert delay 

    // uint32_t read_reg_loopback = USER_readWord(LOOPBACK_OFFSET);
    uint32_t read_reg_loopback = reg_loopback;

    // signal error to python testbench
    if (read_reg_loopback != input) GPIOs_writeLow(1 << ERROR_GPIO);
}

void main()
{
    // Enable managment gpio as output to use as indicator for finishing configuration  
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);

    GPIOs_configure(ERROR_GPIO,GPIO_MODE_MGMT_STD_OUTPUT);

    // load the configuration 
    GPIOs_loadConfigs(); 
    // disable housekeeping spi
    enableHkSpi(0);
    
    // turn on wishbone interface
    User_enableIF();
    // signal to cocotb that configuration is done
    ManagmentGpio_write(1);

    for (int i = 0; i < NUM_TESTS; i++)
    {

        test(input_values[i], delay_values[i]);

        // signal loop to the python testbench
        ManagmentGpio_write(0);
        ManagmentGpio_write(1);
    }

    return;
}
