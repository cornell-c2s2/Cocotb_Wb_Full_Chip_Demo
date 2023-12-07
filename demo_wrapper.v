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
	output wire wbs_ack_o,
	output wire [31:0] wbs_dat_o
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
    wire c_i_stream_rdy;
    wire [31:0] c_o_stream_data;
    wire c_o_stream_val;

    // wb -> adder
    wire c_i_stream_val;
    wire [31:0] c_i_stream_data;
    wire c_o_stream_rdy;

    Wishbone wb (
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
        .o_stream_rdy (module_input_xbar_recv_rdy[0]),

        //xbar -> wb
        .i_stream_rdy (module_output_xbar_send_rdy[0]),
        .o_stream_val (module_output_xbar_send_val[0]),
        .o_stream_data(module_output_xbar_send_msg[31:0])

    );

    wire [(2 * 32) - 1:0] module_input_xbar_recv_msg;
	wire [1:0] module_input_xbar_recv_val;
	wire [1:0] module_input_xbar_recv_rdy;
    wire [(2 * 32) - 1:0] module_output_xbar_send_msg;
	wire [1:0] module_output_xbar_send_val;
	wire [1:0] module_output_xbar_send_rdy;

    wire crossbar_control;
    wire crossbar_control_val;
    wire crossbar_control_rdy;
    assign crossbar_control = 0; // hardcode for now
    assign crossbar_control_val = 1;


    crossbaroneoutVRTL#(
        .BIT_WIDTH(32),
		.N_INPUTS(2),
		.N_OUTPUTS(1),
		.CONTROL_BIT_WIDTH(1)
    ) module_input(
        .clk(wb_clk_i),
		.reset(wb_rst_i),
		.recv_msg(module_input_xbar_recv_msg),
		.recv_val(module_input_xbar_recv_val),
		.recv_rdy(module_input_xbar_recv_rdy),
		.send_msg(c_i_stream_data),
		.send_val(c_i_stream_val),
		.send_rdy(c_i_stream_rdy),
		.control(crossbar_control),
		.control_val(crossbar_control_val),
		.control_rdy(crossbar_control_rdy)
    );

    Adder adder (
        //‘ifdef USE_POWER_PINS
        // .vccd1(vccd1),	// User area 1 1.8V power
        // .vssd1(vssd1),	// User area 1 digital ground
        //‘endif
        
        .clk  (wb_clk_i),
        .reset(wb_rst_i),

        // inputs
        .i_stream_val (c_i_stream_val),
        .i_stream_data(c_i_stream_data),
        .o_stream_rdy (c_o_stream_rdy),

        // outputs
        .i_stream_rdy (c_i_stream_rdy),
        .o_stream_val (c_o_stream_val),
        .o_stream_data(c_o_stream_data)
    );

    crossbaroneinVRTL#(
        .BIT_WIDTH(32),
		.N_INPUTS(1),
		.N_OUTPUTS(2),
		.CONTROL_BIT_WIDTH(1)
    ) module_output (
        .clk(wb_clk_i),
		.reset(wb_rst_i),

		.recv_msg(c_o_stream_data),
		.recv_val(c_o_stream_val),
		.recv_rdy(c_o_stream_rdy),

		.send_msg(module_output_xbar_send_msg),
		.send_val(module_output_xbar_send_val),
		.send_rdy(module_output_xbar_send_rdy),
		.control(crossbar_control),
		.control_val(crossbar_control_val),
		.control_rdy(crossbar_control_rdy)
    );

endmodule