//========================================================================
// RegInc Test
//========================================================================
`default_nettype none
module Demo_Wrapper (
// ifdef USE_POWER_PINS
	inout vccd1, // User area 1 1.8V supply 
	inout vssd1, // User area 1 digital ground 
// `endif
	input wire wb_clk_i,
	input wire wb_rst_i,
	input wire wbs_stb_i,
	input wire wbs_cyc_i,
	input wire wbs_we_i,
	input wire [3:0] wbs_sel_i,
	input wire [31:0] wbs_dat_i,
	input wire [31:0] wbs_adr_i,
    input wire switch_crossbar_control,
    input wire switch_crossbar_control_en,
    
	output wire wbs_ack_o,
	output wire [31:0] wbs_dat_o,

    input wire [8:0] gpio_input,
    input wire [8:0] gpio_input_en,
    input wire [8:0] gpio_output,
    input wire [8:0] gpio_output_en,
    input wire gpio_istream_val,
    input wire gpio_istream_val_en,
    output wire gpio_istream_rdy,
    output wire gpio_istream_rdy_en,
    output wire gpio_ostream_val,
    output wire gpio_ostream_val_en,
    input wire gpio_ostream_rdy,
    input wire gpio_ostream_rdy_en,
    input wire gpio_xbar_config,
    input wire gpio_xbar_config_en,
    input wire gpio_xbar_val,
    input wire gpio_xbar_val_en
);
    // proc -> wb
    // recv_msg
    //     69          68        67       66:64      63:32     31:0
    // +----------+---------+---------+---------+----------+-----------+
    // wbs_stb_i  wbs_cyc_i  wbs_we_i  wbs_sel_i  wbs_dat_i  wbs_adr_i

    // wb -> proc
    // resp_msg
    //    32         31:0
    // +----------+---------+
    //  wbs_ack_o  wbs_dat_o

    // adder -> wb
    wire [1:0] c_i_stream_rdy;
    wire [63:0] c_o_stream_data;
    wire [1:0] c_o_stream_val;

    // wb -> adder
    wire [1:0] c_i_stream_val;
    wire [63:0] c_i_stream_data;
    wire [1:0] c_o_stream_rdy;

    Wishbone 
    #(
        .n_modules(2)
    ) 
    wb (
        //‘ifdef USE_POWER_PINS
        // .vccd1(vccd1),	// User area 1 1.8V power
        // .vssd1(vssd1),	// User area 1 digital ground
        //‘endif
        //inputs
        .clk  (wb_clk_i),
        .reset(wb_rst_i),

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

        //wb -> xbar
        .i_stream_val (module_input_xbar_recv_val[0]),
        .i_stream_data(module_input_xbar_recv_msg[31:0]),
        .o_stream_rdy (module_output_xbar_send_rdy[0]),

        //xbar -> wb
        .i_stream_rdy (module_input_xbar_recv_rdy[0]),
        .o_stream_val (module_output_xbar_send_val[0]),
        .o_stream_data(module_output_xbar_send_msg[31:0])
        ,

        .xbar_config(wb_xbar_interface_ctrl),
        .xbar_val(wb_crossbar_control_val)

    );

    wire [(2 * 32) - 1:0] module_input_xbar_recv_msg;
	wire [1:0] module_input_xbar_recv_val;
	wire [1:0] module_input_xbar_recv_rdy;
    wire [(2 * 32) - 1:0] module_output_xbar_send_msg;
	wire [1:0] module_output_xbar_send_val;
	wire [1:0] module_output_xbar_send_rdy;

    assign module_input_xbar_recv_val[1] = gpio_istream_val;
    assign module_input_xbar_recv_msg[63:32] = {24'b0, gpio_input};
    assign module_output_xbar_send_rdy[1] = gpio_ostream_rdy;

    assign module_input_xbar_recv_rdy[1] = gpio_istream_rdy;
    assign module_output_xbar_send_val[1] = gpio_ostream_val;
    assign module_output_xbar_send_msg[63:32] = {24'b0, gpio_output};

    // wire crossbar_control;
    wire wb_crossbar_control_val;
    wire crossbar_control_rdy;
    wire wb_xbar_interface_ctrl;
    // assign crossbar_control = 0; // hardcode for now
    // assign wb_xbar_interface_ctrl = 1; // hardcode for now
    // assign wb_crossbar_control_val = 1;
    wire interface_crossbar_control;
    wire crossbar_control_val;

    cmn_Mux2 #(
        32
    ) xbar_interface_mux (
        .in0(gpio_xbar_config),
        .in1(wb_xbar_interface_ctrl),
        .out(interface_crossbar_control),
        .sel(switch_crossbar_control)
    );

    cmn_Mux2 #(
        32
    ) xbar_val_mux (
        .in0(gpio_xbar_val),
        .in1(wb_crossbar_control_val),
        .out(crossbar_control_val),
        .sel(switch_crossbar_control)
    );

    // crossbaroneoutVRTL#(
    //     .BIT_WIDTH(32),
	// 	.N_INPUTS(2),
	// 	.N_OUTPUTS(1),
	// 	.CONTROL_BIT_WIDTH(1)
    // ) module_input(
    //     .clk(wb_clk_i),
	// 	.reset(wb_rst_i),
	// 	.recv_msg(module_input_xbar_recv_msg),
	// 	.recv_val(module_input_xbar_recv_val),
	// 	.recv_rdy(module_input_xbar_recv_rdy),
	// 	.send_msg(c_i_stream_data),
	// 	.send_val(c_i_stream_val),
	// 	.send_rdy(c_i_stream_rdy),
	// 	.control(wb_xbar_interface_ctrl),
	// 	.control_val(wb_crossbar_control_val),
	// 	.control_rdy(crossbar_control_rdy)
    // );

    crossbarVRTL#(
        .BIT_WIDTH(32),
		.N_INPUTS(2),
		.N_OUTPUTS(2),
		.CONTROL_BIT_WIDTH(2)
    ) module_input(
        .clk(wb_clk_i),
		.reset(wb_rst_i),
		.recv_msg(module_input_xbar_recv_msg),
		.recv_val(module_input_xbar_recv_val),
		.recv_rdy(module_input_xbar_recv_rdy),
		.send_msg(c_i_stream_data),
		.send_val(c_i_stream_val),
		.send_rdy(c_i_stream_rdy),
		// .control(wb_xbar_interface_ctrl),
		.control({switch_crossbar_control, interface_crossbar_control}),
		.control_val(crossbar_control_val),
		.control_rdy(crossbar_control_rdy)
    );

    Adder adder1 (
        
        .clk  (wb_clk_i),
        .reset(wb_rst_i),

        // inputs
        .i_stream_val (c_i_stream_val[0]),
        .i_stream_data(c_i_stream_data[31:0]),
        .o_stream_rdy (c_o_stream_rdy[0]),

        // outputs
        .i_stream_rdy (c_i_stream_rdy[0]),
        .o_stream_val (c_o_stream_val[0]),
        .o_stream_data(c_o_stream_data[31:0])
    );

    Adder adder0 (
        
        .clk  (wb_clk_i),
        .reset(wb_rst_i),

        // inputs
        .i_stream_val (c_i_stream_val[1]),
        .i_stream_data(c_i_stream_data[63:32]),
        .o_stream_rdy (c_o_stream_rdy[1]),

        // outputs
        .i_stream_rdy (c_i_stream_rdy[1]),
        .o_stream_val (c_o_stream_val[1]),
        .o_stream_data(c_o_stream_data[63:32])
    );

    //     Adder adder (
        
    //     .clk  (wb_clk_i),
    //     .reset(wb_rst_i),

    //     // inputs
    //     .i_stream_val (c_i_stream_val),
    //     .i_stream_data(c_i_stream_data),
    //     .o_stream_rdy (module_output_xbar_send_rdy[0]),

    //     // outputs
    //     .i_stream_rdy (c_i_stream_rdy),
    //     .o_stream_val (module_output_xbar_send_val[0]),
    //     .o_stream_data(module_output_xbar_send_msg[31:0])
    // );

    // crossbaroneinVRTL#(
    //     .BIT_WIDTH(32),
	// 	.N_INPUTS(1),
	// 	.N_OUTPUTS(2),
	// 	.CONTROL_BIT_WIDTH(1)
    // ) module_output (
    //     .clk(wb_clk_i),
	// 	.reset(wb_rst_i),

	// 	.recv_msg(c_o_stream_data),
	// 	.recv_val(c_o_stream_val),
	// 	.recv_rdy(c_o_stream_rdy),

	// 	.send_msg(module_output_xbar_send_msg),
	// 	.send_val(module_output_xbar_send_val),
	// 	.send_rdy(module_output_xbar_send_rdy),
	// 	.control(wb_xbar_interface_ctrl),
	// 	.control_val(wb_crossbar_control_val),
	// 	.control_rdy(crossbar_control_rdy)
    // );

        crossbarVRTL #(
        .BIT_WIDTH(32),
		.N_INPUTS(2),
		.N_OUTPUTS(2),
		.CONTROL_BIT_WIDTH(2)
    ) module_output (
        .clk(wb_clk_i),
		.reset(wb_rst_i),

		.recv_msg(c_o_stream_data),
		.recv_val(c_o_stream_val),
		.recv_rdy(c_o_stream_rdy),

		.send_msg(module_output_xbar_send_msg),
		.send_val(module_output_xbar_send_val),
		.send_rdy(module_output_xbar_send_rdy),
		.control({interface_crossbar_control, switch_crossbar_control}),
		.control_val(crossbar_control_val),
		.control_rdy(crossbar_control_rdy)
    );

endmodule