`default_nettype none
module Adder (
	input wire clk,
	input wire reset,
	output wire i_stream_rdy,
	input wire i_stream_val,
	input wire o_stream_rdy,
	output wire o_stream_val,
	output wire [31:0] o_stream_data,
	input wire [31:0] i_stream_data
);

	reg c_i_stream_rdy;
	reg c_o_stream_val;
	assign i_stream_rdy = c_i_stream_rdy;
	assign o_stream_val = c_o_stream_val;

	reg [31:0] reg_out;
	wire reg_en;
	assign reg_en = i_stream_val;
	always @(posedge clk) begin
		if (reset) reg_out <= 32'b00000000000000000000000000000000;
		else if (reg_en) reg_out <= i_stream_data;
	end
	assign o_stream_data = reg_out + 1;
	localparam INPUT_READY = 1'b0;
	localparam OUTPUT_READY = 1'b1;
	reg state;
	reg next_state;
	always @(posedge clk) begin
		if (reset) state <= INPUT_READY;
		else state <= next_state;
	end
	always @(*) begin
		next_state = state;
		case (state)
			INPUT_READY: if (i_stream_val) next_state = OUTPUT_READY;
			OUTPUT_READY: if (o_stream_rdy) next_state = INPUT_READY;
		endcase
	end

	always @(*) begin
		if (state == INPUT_READY) begin
				c_i_stream_rdy = 1'b1;
				c_o_stream_val = 1'b0;
		end
		else if (state == OUTPUT_READY) begin
				c_i_stream_rdy = 1'b0;
				c_o_stream_val = 1'b1;
		end
		else begin
				c_i_stream_rdy = 1'b0;
				c_o_stream_val = 1'b0;
		end
	end
endmodule
