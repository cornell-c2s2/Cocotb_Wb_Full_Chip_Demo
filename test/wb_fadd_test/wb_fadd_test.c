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

//                                      1          23.45      100        376.365656    239.5739105
uint32_t float_values[NUM_TESTS] = {0x3F800000, 0x41BB999A, 0x42C80000, 0x43BC2ECE, 0x436F92EC};
uint32_t float_plus_one[NUM_TESTS] = {0x40000000, 0x41C3999A, 0x42CA0000, 0x43BCAECE, 0x437092EC};
int delay_values[NUM_TESTS] = {0, 1, 5, 4, 3};

void test(uint32_t fp32_input, uint32_t fp32_expected_out, int delay) {

    fadd = fp32_input;

    dummyDelay(delay); // Insert delay 

    uint32_t fadd_read = fadd;


    uint32_t read_error = reg_error;

    // signal error to python testbench
    if (read_error != 0) GPIOs_writeLow(1 << ERROR_GPIO);
    if (fadd_read != (fp32_expected_out)) GPIOs_writeLow(1 << ERROR_GPIO);
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

        test(float_values[i], float_plus_one[i], delay_values[i]);

        // signal loop to the python testbench
        ManagmentGpio_write(0);
        ManagmentGpio_write(1);
    }

    return;
}
