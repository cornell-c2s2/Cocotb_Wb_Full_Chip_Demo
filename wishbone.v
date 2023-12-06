`default_nettype none
module Wishbone (
// ‘ifdef USE_POWER_PINS
	inout vccd1, // User area 1 1.8V supply 
	inout vssd1, // User area 1 digital ground 
// ‘endif
	input wire clk,
	input wire reset,
	input wire wbs_stb_i,
	input wire wbs_cyc_i,
	input wire wbs_we_i,
	input wire [3:0] wbs_sel_i,
	input wire [31:0] wbs_dat_i,
	input wire [31:0] wbs_adr_i,
	output wire wbs_ack_o,
	output wire [31:0] wbs_dat_o,
	input wire i_stream_rdy,
	output wire i_stream_val,
	output wire o_stream_rdy,
	input wire o_stream_val,
	input wire [31:0] o_stream_data,
	output wire [31:0] i_stream_data
);
	reg c_wbs_ack_o;
	reg c_i_stream_val;
	reg c_o_stream_rdy;
	reg [31:0] c_i_stream_data;
	
	assign wbs_ack_o = c_wbs_ack_o;
	assign i_stream_val = c_i_stream_val;
	assign o_stream_rdy = c_o_stream_rdy;

	localparam [31:0] BASE_ADDRESS = 32'h30000000;
	localparam [31:0] FFT_ADDRESS = 805306372;
	localparam [31:0] UPPER_BOUND_ADDRESS = 805306372;
	reg [31:0] loopback_reg;
	reg loopback_reg_en;
	always @(posedge clk)
		if (reset)
			loopback_reg <= 32'b00000000000000000000000000000000;
		else if (loopback_reg_en)
			loopback_reg <= wbs_dat_i;
	assign i_stream_data = wbs_dat_i;
	reg wbs_dat_o_sel;
	assign wbs_dat_o = (wbs_dat_o_sel ? o_stream_data : loopback_reg);
	reg is_write_module;
	reg is_read_module;
	reg is_write_loop;
	reg is_read_loop;
	always @(*) begin
		is_write_loop = ((wbs_stb_i && wbs_cyc_i) && wbs_we_i) && (wbs_adr_i == BASE_ADDRESS);
		is_read_loop = ((wbs_stb_i && wbs_cyc_i) && !wbs_we_i) && (wbs_adr_i == BASE_ADDRESS);
		is_write_module = ((wbs_stb_i && wbs_cyc_i) && wbs_we_i) && (wbs_adr_i == FFT_ADDRESS);
		is_read_module = ((wbs_stb_i && wbs_cyc_i) && !wbs_we_i) && (wbs_adr_i == FFT_ADDRESS);
	end
	localparam IDLE = 2'd0;
	localparam BUSY = 2'd1;
	localparam DONE = 2'd2;
	localparam LOOP = 2'd3;
	reg [1:0] state;
	reg [1:0] next_state;
	always @(posedge clk)
		if (reset)
			state <= IDLE;
		else if (next_state == IDLE)
			state <= IDLE;
		else if (next_state == BUSY)
			state <= BUSY;
		else if (next_state == DONE)
			state <= DONE;
		else if (next_state == LOOP)
			state <= LOOP;
	always @(*) begin
		next_state = state;
		case (state)
			IDLE:
				if (is_write_module)
					next_state = BUSY;
				else if (is_write_loop)
					next_state = LOOP;
			BUSY:
				if (o_stream_val)
					next_state = DONE;
			DONE:
				if (is_read_module)
					next_state = IDLE;
			LOOP:
				if (is_read_loop)
					next_state = IDLE;
		endcase
	end
	task cs;
		input cs_i_stream_val;
		input cs_o_stream_rdy;
		input cs_wbs_ack_o;
		input cs_loopback_reg_en;
		input cs_wbs_dat_o_sel;
		begin
			c_i_stream_val = cs_i_stream_val;
			c_o_stream_rdy = cs_o_stream_rdy;
			c_wbs_ack_o = cs_wbs_ack_o;
			loopback_reg_en = cs_loopback_reg_en;
			wbs_dat_o_sel = cs_wbs_dat_o_sel;
		end
	endtask
	always @(*) begin
		
		// c_i_stream_val = 0;
		// c_o_stream_rdy = 0;
		// c_wbs_ack_o = 0;
		// loopback_reg_en = 0;
		// wbs_dat_o_sel = 0;
		cs(0, 0, 0, 0, 0);

		case (state)
			IDLE: begin
				if (is_write_module) begin

					// c_i_stream_val = 1;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 0;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 0;
					
					cs(1, 0, 0, 0, 0);
					end
				else if (is_write_loop) begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 1;
					// loopback_reg_en = 1;
					// wbs_dat_o_sel = 0;

					cs(0, 0, 1, 1, 0);
					end
				else begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 0;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 0;

					cs(0, 0, 0, 0, 0);

					end
			end
			BUSY: begin
				if (next_state == DONE) begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 1;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 0;

					cs(0, 0, 1, 0, 0);
					end
				else begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 0;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 0;

					cs(0, 0, 0, 0, 0);
					end
			end
			DONE: begin
				if (is_read_module) begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 1;
					// c_wbs_ack_o = 1;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 1;

					cs(0, 1, 1, 0, 1);
					end
				else begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 0;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 0;

					cs(0, 0, 0, 0, 0);
					end
			end
			LOOP: begin
				if (is_read_loop) begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 1;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 0;

					cs(0, 0, 1, 0, 0);
					end
				else begin

					// c_i_stream_val = 0;
					// c_o_stream_rdy = 0;
					// c_wbs_ack_o = 0;
					// loopback_reg_en = 0;
					// wbs_dat_o_sel = 0;

					cs(0, 0, 0, 0, 0);
					end
			end
		endcase
	end
endmodule
