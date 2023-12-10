// copyright Matt Venn 2023

#include <firmware_apis.h>
#include <assert.h>

#define NUM_TESTS 5
#define reg_loopback      (*(volatile uint32_t*)0x30000000)
#define reg_error         (*(volatile uint32_t*)0x30000004)
#define reg_adder         (*(volatile uint32_t*)0x30000008)
#define reg_adder_2         (*(volatile uint32_t*)0x3000000c)
#define LOOPBACK_OFFSET 0
#define ADDER_OFFSET 4
#define ERROR_GPIO 31
#define XBAR_CTL 0

void main()
{
    // Enable managment gpio as output to use as indicator for finishing configuration  
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    // disable housekeeping spi
    enableHkSpi(0);
        // .gpio_input(io_in[17:10]), input
        // .gpio_output(io_in[25:18]), output
        // .gpio_istream_val(io_in[26]), input
        // .gpio_istream_rdy(io_in[27]), output
        // .gpio_ostream_val(io_in[28]), output
        // .gpio_ostream_rdy(io_in[29]), input
        // .gpio_xbar_config(io_in[17]), input
        // .gpio_xbar_val(io_in[16]), input
    GPIOs_configure(XBAR_CTL,GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    GPIOs_configure(ERROR_GPIO,GPIO_MODE_MGMT_STD_OUTPUT);

    int i;
    // configure input
    for (i = 10; i <= 17; i++) {
        GPIOs_configure(i,GPIO_MODE_MGMT_STD_INPUT_NOPULL);
    }
    // configure output
    for (i = 18; i <= 25; i++) {
        GPIOs_configure(i,GPIO_MODE_USER_STD_OUTPUT);
    }
    // configure istream val
    GPIOs_configure(26,GPIO_MODE_USER_STD_INPUT_NOPULL);
    // configure istream rdy 
    GPIOs_configure(27,GPIO_MODE_USER_STD_OUTPUT);
    // configure ostream val
    GPIOs_configure(28,GPIO_MODE_USER_STD_OUTPUT);
    // configure ostream rdy
    GPIOs_configure(29,GPIO_MODE_USER_STD_INPUT_NOPULL);
    // configure xbar config
    GPIOs_configure(9,GPIO_MODE_USER_STD_INPUT_NOPULL);
    // configure xbar val 
    GPIOs_configure(8,GPIO_MODE_USER_STD_INPUT_NOPULL);

    // load the configuration 
    GPIOs_loadConfigs(); 
    
    // turn on wishbone interface
    User_enableIF();
    // signal to cocotb that configuration is done
    ManagmentGpio_write(1);

    // // sync with configuring the xbar
    // ManagmentGpio_write(0);
    // ManagmentGpio_write(1);

    return;
}
