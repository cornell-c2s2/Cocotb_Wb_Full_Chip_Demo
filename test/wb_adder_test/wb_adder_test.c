// copyright Matt Venn 2023

#include <firmware_apis.h>
#include <assert.h>

#define NUM_TESTS 5
#define reg_loopback      (*(volatile uint32_t*)0x30000000)
#define reg_error         (*(volatile uint32_t*)0x30000004)
#define fadd         (*(volatile uint32_t*)0x30000008)
#define reg_adder_2         (*(volatile uint32_t*)0x3000000c)
#define LOOPBACK_OFFSET 0
#define ERROR_OFFSET 1
#define FADD_OFFSET 2
#define INT_ADD_OFFSET 3
#define ERROR_GPIO 31
#define XBAR_CTL 0

uint32_t integer_values[NUM_TESTS] = {1, 0x00F0, 0x0F00, 0xF000, 0xFFFE};
int delay_values[NUM_TESTS] = {0, 1, 5, 4, 3};

void test(uint32_t int_input, uint32_t int_expected_out, int delay) {

    reg_adder_2 = int_input;

    dummyDelay(delay); // Insert delay 

    uint32_t read_reg_adder = reg_adder_2;

    uint32_t read_error = reg_error;

    // signal error to python testbench
    if (read_error != 0) GPIOs_writeLow(1 << ERROR_GPIO);
    if (read_reg_adder != (int_expected_out)) GPIOs_writeLow(1 << ERROR_GPIO);
}

void main()
{
    // Enable managment gpio as output to use as indicator for finishing configuration  
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);

    GPIOs_configure(XBAR_CTL,GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(ERROR_GPIO,GPIO_MODE_MGMT_STD_OUTPUT);

    // load the configuration 
    GPIOs_loadConfigs(); 
    // disable housekeeping spi
    enableHkSpi(0);
    
    // turn on wishbone interface
    User_enableIF();
    // signal to cocotb that configuration is done
    ManagmentGpio_write(1);

    // sync with configuring the xbar
    ManagmentGpio_write(0);
    ManagmentGpio_write(1);

    for (int i = 0; i < NUM_TESTS; i++)
    {

        test(integer_values[i], integer_values[i]+1, delay_values[i]);

        // signal loop to the python testbench
        ManagmentGpio_write(0);
        ManagmentGpio_write(1);
    }

    return;
}
