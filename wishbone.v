// `default_nettype none
// module cmn_Mux2 (
// 	in0,
// 	in1,
// 	sel,
// 	out
// );
// 	parameter p_nbits = 1;
// 	input wire [p_nbits - 1:0] in0;
// 	input wire [p_nbits - 1:0] in1;
// 	input wire sel;
// 	output reg [p_nbits - 1:0] out;
// 	always @(*)
// 		case (sel)
// 			1'd0: out = in0;
// 			1'd1: out = in1;
// 			default: out = {p_nbits {1'bx}};
// 		endcase
// endmodule
// module cmn_Mux3 (
// 	in0,
// 	in1,
// 	in2,
// 	sel,
// 	out
// );
// 	parameter p_nbits = 1;
// 	input wire [p_nbits - 1:0] in0;
// 	input wire [p_nbits - 1:0] in1;
// 	input wire [p_nbits - 1:0] in2;
// 	input wire [1:0] sel;
// 	output reg [p_nbits - 1:0] out;
// 	always @(*)
// 		case (sel)
// 			2'd0: out = in0;
// 			2'd1: out = in1;
// 			2'd2: out = in2;
// 			default: out = {p_nbits {1'bx}};
// 		endcase
// endmodule
// module cmn_Mux4 (
// 	in0,
// 	in1,
// 	in2,
// 	in3,
// 	sel,
// 	out
// );
// 	parameter p_nbits = 1;
// 	input wire [p_nbits - 1:0] in0;
// 	input wire [p_nbits - 1:0] in1;
// 	input wire [p_nbits - 1:0] in2;
// 	input wire [p_nbits - 1:0] in3;
// 	input wire [1:0] sel;
// 	output reg [p_nbits - 1:0] out;
// 	always @(*)
// 		case (sel)
// 			2'd0: out = in0;
// 			2'd1: out = in1;
// 			2'd2: out = in2;
// 			2'd3: out = in3;
// 			default: out = {p_nbits {1'bx}};
// 		endcase
// endmodule
// module cmn_Mux5 (
// 	in0,
// 	in1,
// 	in2,
// 	in3,
// 	in4,
// 	sel,
// 	out
// );
// 	parameter p_nbits = 1;
// 	input wire [p_nbits - 1:0] in0;
// 	input wire [p_nbits - 1:0] in1;
// 	input wire [p_nbits - 1:0] in2;
// 	input wire [p_nbits - 1:0] in3;
// 	input wire [p_nbits - 1:0] in4;
// 	input wire [2:0] sel;
// 	output reg [p_nbits - 1:0] out;
// 	always @(*)
// 		case (sel)
// 			3'd0: out = in0;
// 			3'd1: out = in1;
// 			3'd2: out = in2;
// 			3'd3: out = in3;
// 			3'd4: out = in4;
// 			default: out = {p_nbits {1'bx}};
// 		endcase
// endmodule
// module cmn_Mux6 (
// 	in0,
// 	in1,
// 	in2,
// 	in3,
// 	in4,
// 	in5,
// 	sel,
// 	out
// );
// 	parameter p_nbits = 1;
// 	input wire [p_nbits - 1:0] in0;
// 	input wire [p_nbits - 1:0] in1;
// 	input wire [p_nbits - 1:0] in2;
// 	input wire [p_nbits - 1:0] in3;
// 	input wire [p_nbits - 1:0] in4;
// 	input wire [p_nbits - 1:0] in5;
// 	input wire [2:0] sel;
// 	output reg [p_nbits - 1:0] out;
// 	always @(*)
// 		case (sel)
// 			3'd0: out = in0;
// 			3'd1: out = in1;
// 			3'd2: out = in2;
// 			3'd3: out = in3;
// 			3'd4: out = in4;
// 			3'd5: out = in5;
// 			default: out = {p_nbits {1'bx}};
// 		endcase
// endmodule
// module cmn_Mux7 (
// 	in0,
// 	in1,
// 	in2,
// 	in3,
// 	in4,
// 	in5,
// 	in6,
// 	sel,
// 	out
// );
// 	parameter p_nbits = 1;
// 	input wire [p_nbits - 1:0] in0;
// 	input wire [p_nbits - 1:0] in1;
// 	input wire [p_nbits - 1:0] in2;
// 	input wire [p_nbits - 1:0] in3;
// 	input wire [p_nbits - 1:0] in4;
// 	input wire [p_nbits - 1:0] in5;
// 	input wire [p_nbits - 1:0] in6;
// 	input wire [2:0] sel;
// 	output reg [p_nbits - 1:0] out;
// 	always @(*)
// 		case (sel)
// 			3'd0: out = in0;
// 			3'd1: out = in1;
// 			3'd2: out = in2;
// 			3'd3: out = in3;
// 			3'd4: out = in4;
// 			3'd5: out = in5;
// 			3'd6: out = in6;
// 			default: out = {p_nbits {1'bx}};
// 		endcase
// endmodule
// module cmn_Mux8 (
// 	in0,
// 	in1,
// 	in2,
// 	in3,
// 	in4,
// 	in5,
// 	in6,
// 	in7,
// 	sel,
// 	out
// );
// 	parameter p_nbits = 1;
// 	input wire [p_nbits - 1:0] in0;
// 	input wire [p_nbits - 1:0] in1;
// 	input wire [p_nbits - 1:0] in2;
// 	input wire [p_nbits - 1:0] in3;
// 	input wire [p_nbits - 1:0] in4;
// 	input wire [p_nbits - 1:0] in5;
// 	input wire [p_nbits - 1:0] in6;
// 	input wire [p_nbits - 1:0] in7;
// 	input wire [2:0] sel;
// 	output reg [p_nbits - 1:0] out;
// 	always @(*)
// 		case (sel)
// 			3'd0: out = in0;
// 			3'd1: out = in1;
// 			3'd2: out = in2;
// 			3'd3: out = in3;
// 			3'd4: out = in4;
// 			3'd5: out = in5;
// 			3'd6: out = in6;
// 			3'd7: out = in7;
// 			default: out = {p_nbits {1'bx}};
// 		endcase
// endmodule
// module cmn_MuxN (
// 	in,
// 	sel,
// 	out
// );
// 	parameter nbits = 1;
// 	parameter ninputs = 2;
// 	input wire [(ninputs * nbits) - 1:0] in;
// 	input wire [$clog2(ninputs) - 1:0] sel;
// 	output wire [nbits - 1:0] out;
// 	assign out = in[((ninputs - 1) - sel) * nbits+:nbits];
// endmodule
module Wishbone (
	clk,
	reset,
	wbs_stb_i,
	wbs_cyc_i,
	wbs_we_i,
	wbs_sel_i,
	wbs_dat_i,
	wbs_adr_i,
	wbs_ack_o,
	wbs_dat_o,
	i_stream_rdy,
	i_stream_val,
	o_stream_rdy,
	o_stream_val,
	o_stream_data,
	i_stream_data,
	xbar_config,
	xbar_val
);
	parameter n_modules = 2;
	input wire clk;
	input wire reset;
	input wire wbs_stb_i;
	input wire wbs_cyc_i;
	input wire wbs_we_i;
	input wire [3:0] wbs_sel_i;
	input wire [31:0] wbs_dat_i;
	input wire [31:0] wbs_adr_i;
	output reg wbs_ack_o;
	output wire [31:0] wbs_dat_o;
	input wire i_stream_rdy;
	output reg i_stream_val;
	output reg o_stream_rdy;
	input wire o_stream_val;
	input wire [31:0] o_stream_data;
	output wire [31:0] i_stream_data;
	output wire [$clog2(n_modules) - 1:0] xbar_config;
	output reg xbar_val;
	localparam [31:0] BASE_ADDRESS = 32'h30000000;
	localparam [31:0] ERROR_ADDRESS = 32'h30000004;
	localparam [31:0] FFT_ADDRESS = 805306376;
	localparam [31:0] UPPER_BOUND_ADDRESS = BASE_ADDRESS + ((n_modules << 2) + 8);
	// localparam [31:0] UPPER_BOUND_ADDRESS = 32'h30000008;
	wire [31:0] loopback_reg;
	reg loopback_reg_en;
	cmn_EnResetReg #(
		32,
		0
	) loopback_enset_reg(
		.clk(clk),
		.reset(reset),
		.q(loopback_reg),
		.d(wbs_dat_i),
		.en(loopback_reg_en)
	);
	wire [31:0] error_reg;
	reg [31:0] next_error_reg;
	reg error_reg_en;
	cmn_EnResetReg #(
		32,
		0
	) error_enset_reg(
		.clk(clk),
		.reset(reset),
		.q(error_reg),
		.d(next_error_reg),
		.en(error_reg_en)
	);

	wire [31:0] wbs_dat_i_reg;
	reg wbs_dat_i_en;
	cmn_EnResetReg #(
		32,
		0
	) wbs_dat_i_reset_reg (
		.clk(clk),
		.reset(reset),
		.q(wbs_dat_i_reg),
		.d(wbs_dat_i),
		.en(wbs_dat_i_en)
	);

	assign i_stream_data = wbs_dat_i_reg;

	reg [1:0] wbs_dat_o_sel;
	cmn_Mux3 #(.p_nbits(32)) wbs_dat_o_mux(
		.in0(loopback_reg),
		.in1(o_stream_data),
		.in2(error_reg),
		.sel(wbs_dat_o_sel),
		.out(wbs_dat_o)
	);
	assign xbar_config = (wbs_adr_i >> 2) - 4'd12;
	reg is_write_module;
	reg is_write_module_error;
	reg is_read_module;
	reg is_read_module_error;
	reg is_read_busy_module;
	reg is_write_loop;
	reg is_read_loop;
	reg is_read_error;
	reg is_config_read_module;
	reg is_config_write_module;
	always @(*) begin
		is_write_loop = ((wbs_stb_i && wbs_cyc_i) && wbs_we_i) && (wbs_adr_i == BASE_ADDRESS);
		is_read_loop = ((wbs_stb_i && wbs_cyc_i) && !wbs_we_i) && (wbs_adr_i == BASE_ADDRESS);
		is_read_error = ((wbs_stb_i && wbs_cyc_i) && !wbs_we_i) && (wbs_adr_i == ERROR_ADDRESS);
		is_config_write_module = (((wbs_stb_i && wbs_cyc_i) && wbs_we_i)) && (((wbs_adr_i <= UPPER_BOUND_ADDRESS) && (wbs_adr_i > ERROR_ADDRESS)) && (wbs_adr_i[1:0] == 2'b00));
		is_config_read_module = (((wbs_stb_i && wbs_cyc_i) && !wbs_we_i)) && (((wbs_adr_i <= UPPER_BOUND_ADDRESS) && (wbs_adr_i > ERROR_ADDRESS)) && (wbs_adr_i[1:0] == 2'b00));
		// is_write_module = (((wbs_stb_i && wbs_cyc_i) && wbs_we_i) && i_stream_rdy) && (((wbs_adr_i <= UPPER_BOUND_ADDRESS) && (wbs_adr_i > ERROR_ADDRESS)) && (wbs_adr_i[1:0] == 2'b00));
		is_write_module = i_stream_rdy;
		// is_write_module_error = (((wbs_stb_i && wbs_cyc_i) && wbs_we_i) && !i_stream_rdy) && (((wbs_adr_i <= UPPER_BOUND_ADDRESS) && (wbs_adr_i > ERROR_ADDRESS)) && (wbs_adr_i[1:0] == 2'b00));
		is_write_module_error = !i_stream_rdy;
		// is_read_module = (((wbs_stb_i && wbs_cyc_i) && !wbs_we_i) && o_stream_val) && (((wbs_adr_i <= UPPER_BOUND_ADDRESS) && (wbs_adr_i > ERROR_ADDRESS)) && (wbs_adr_i[1:0] == 2'b00));
		is_read_module = o_stream_val;
		// is_read_module_error = ((((wbs_stb_i && wbs_cyc_i) && !wbs_we_i) && !o_stream_val) && i_stream_rdy) && (((wbs_adr_i <= UPPER_BOUND_ADDRESS) && (wbs_adr_i > ERROR_ADDRESS)) && (wbs_adr_i[1:0] == 2'b00));
		is_read_module_error = !o_stream_val && i_stream_rdy;
		// is_read_busy_module = ((((wbs_stb_i && wbs_cyc_i) && !wbs_we_i) && !o_stream_val) && !i_stream_rdy) && (((wbs_adr_i <= UPPER_BOUND_ADDRESS) && (wbs_adr_i > ERROR_ADDRESS)) && (wbs_adr_i[1:0] == 2'b00));
		is_read_busy_module = !o_stream_val && !i_stream_rdy;
	end
	localparam IDLE = 2'd0;
	localparam BUSY = 2'd1;
	localparam READ_CONFIG = 2'd2;
	localparam WRITE_CONFIG = 2'd3;


	reg [1:0] state;
	reg [1:0] next_state;
	always @(posedge clk)
		if (reset)
			state <= IDLE;
		else
			state <= next_state;
	always @(*) begin
		next_state = state;
		case (state)
			IDLE:
				// if (is_read_busy_module)
				// 	next_state = BUSY;
				// else 
				if (is_config_read_module)
					next_state = READ_CONFIG;
				else if (is_config_write_module)
					next_state = WRITE_CONFIG;
				else
					next_state = IDLE;
			READ_CONFIG:
				if (is_read_busy_module)
					next_state = BUSY;
				else next_state = IDLE;
			WRITE_CONFIG:
				next_state = IDLE;
			BUSY:
				if (o_stream_val)
					next_state = IDLE;
		endcase
	end
	localparam [1:0] loop_sel = 2'd0;
	localparam [1:0] data_sel = 2'd1;
	localparam [1:0] error_sel = 2'd2;
	localparam [1:0] x_sel = 2'bxx;
	task cs;
		input reg cs_i_stream_val;
		input reg cs_o_stream_rdy;
		input reg cs_loopback_reg_en;
		input reg cs_error_reg_en;
		input reg [31:0] cs_next_error_reg;
		input reg cs_wbs_ack_o;
		input reg [1:0] cs_wbs_dat_o_sel;
		input reg cs_xbar_val;
		input reg cs_wbs_dat_i_en;
		begin
			i_stream_val = cs_i_stream_val;
			o_stream_rdy = cs_o_stream_rdy;
			loopback_reg_en = cs_loopback_reg_en;
			error_reg_en = cs_error_reg_en;
			next_error_reg = cs_next_error_reg;
			wbs_ack_o = cs_wbs_ack_o;
			wbs_dat_o_sel = cs_wbs_dat_o_sel;
			xbar_val = cs_xbar_val;
			wbs_dat_i_en = cs_wbs_dat_i_en;
		end
	endtask
	always @(*) begin
		cs(0, 0, 0, 0, 0, 0, 0, 0, 0);
		case (state)
			IDLE:
				if (is_read_loop)
					cs(0, 0, 0, 1, 0, 1, loop_sel, 0, 0);
				else if (is_write_loop)
					cs(0, 0, 1, 1, 0, 1, x_sel, 0, 0);
				else if (is_read_error)
					cs(0, 0, 0, 0, 0, 1, error_sel, 0, 0);
				else if (is_config_read_module || is_config_write_module)
					cs(0, 0, 0, 0, 0, 0, 0, 1, 1);
			READ_CONFIG:
				if (is_read_module)
					cs(0, 1, 0, 1, 0, 1, data_sel, 0, 0);
				else if (is_read_busy_module)
					cs(0, 0, 0, 1, 0, 0, x_sel, 0, 0);
				else if (is_read_module_error)
					cs(0, 0, 0, 1, 1, 1, x_sel, 0, 0);
			WRITE_CONFIG:
				if (is_write_module)
					cs(1, 0, 0, 1, 0, 1, x_sel, 0, 0);
				else if (is_write_module_error)
					cs(0, 0, 0, 1, 1, 1, x_sel, 0, 0);
			BUSY:
				if (o_stream_val)
					cs(0, 1, 0, 1, 0, 1, data_sel, 0, 0);
				else
					cs(0, 1, 0, 0, 0, 0, x_sel, 0, 0);
			default:
				cs(0, 0, 0, 0, 0, 0, 0, 0, 0);
		endcase
	end
endmodule
