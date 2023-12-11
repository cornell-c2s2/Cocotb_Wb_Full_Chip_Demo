module crossbarVRTL (
	recv_msg,
	recv_val,
	recv_rdy,
	send_msg,
	send_val,
	send_rdy,
	reset,
	clk,
	control,
	control_val,
	control_rdy
);
	parameter BIT_WIDTH = 32;
	parameter N_INPUTS = 2;
	parameter N_OUTPUTS = 2;
	parameter CONTROL_BIT_WIDTH = 42;
	input wire [(N_INPUTS * BIT_WIDTH) - 1:0] recv_msg;
	input wire [0:N_INPUTS - 1] recv_val;
	output reg [0:N_INPUTS - 1] recv_rdy;
	output reg [(N_OUTPUTS * BIT_WIDTH) - 1:0] send_msg;
	output reg [0:N_OUTPUTS - 1] send_val;
	input wire [0:N_OUTPUTS - 1] send_rdy;
	input wire reset;
	input wire clk;
	input wire [CONTROL_BIT_WIDTH - 1:0] control;
	input wire control_val;
	output wire control_rdy;
	reg [CONTROL_BIT_WIDTH - 1:0] stored_control;
	wire [$clog2(N_INPUTS) - 1:0] input_sel;
	wire [$clog2(N_OUTPUTS) - 1:0] output_sel;
	always @(posedge clk)
		if (reset)
			stored_control <= 0;
		else if (control_val)
			stored_control <= control;
	assign control_rdy = 1;
	// assign input_sel = stored_control[CONTROL_BIT_WIDTH - 1:CONTROL_BIT_WIDTH - $clog2(N_INPUTS)];
	assign input_sel = stored_control[1];
	// assign output_sel = stored_control[(CONTROL_BIT_WIDTH - $clog2(N_INPUTS)) - 1:(CONTROL_BIT_WIDTH - $clog2(N_INPUTS)) - $clog2(N_OUTPUTS)];
	assign output_sel = stored_control[0];
	always @(*) begin
		send_msg[((N_OUTPUTS - 1) - output_sel) * BIT_WIDTH+:BIT_WIDTH] = recv_msg[((N_INPUTS - 1) - input_sel) * BIT_WIDTH+:BIT_WIDTH];
		send_val[output_sel] = recv_val[input_sel];
		recv_rdy[input_sel] = send_rdy[output_sel];
		begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < N_OUTPUTS; i = i + 1)
				if (i != output_sel) begin
					send_msg[((N_OUTPUTS - 1) - i) * BIT_WIDTH+:BIT_WIDTH] = 0;
					send_val[i] = 0;
				end
		end
		begin : sv2v_autoblock_2
			integer i;
			for (i = 0; i < N_INPUTS; i = i + 1)
				if (i != input_sel)
					recv_rdy[i] = 0;
		end
	end
endmodule

module crossbaroneinVRTL (
	recv_msg,
	recv_val,
	recv_rdy,
	send_msg,
	send_val,
	send_rdy,
	reset,
	clk,
	control,
	control_val,
	control_rdy
);
	parameter BIT_WIDTH = 32;
	parameter N_INPUTS = 1;
	parameter N_OUTPUTS = 2;
	parameter CONTROL_BIT_WIDTH = 42;
	input wire [(N_INPUTS * BIT_WIDTH) - 1:0] recv_msg;
	input wire [0:N_INPUTS - 1] recv_val;
	output reg [0:N_INPUTS - 1] recv_rdy;
	output reg [(N_OUTPUTS * BIT_WIDTH) - 1:0] send_msg;
	output reg [0:N_OUTPUTS - 1] send_val;
	input wire [0:N_OUTPUTS - 1] send_rdy;
	input wire reset;
	input wire clk;
	input wire [CONTROL_BIT_WIDTH - 1:0] control;
	input wire control_val;
	output wire control_rdy;
	reg [CONTROL_BIT_WIDTH - 1:0] stored_control;
	wire [CONTROL_BIT_WIDTH - 1:0] output_sel;
	always @(posedge clk)
		if (reset)
			stored_control <= 0;
		else if (control_val)
			stored_control <= control;
	assign control_rdy = 1;
	assign output_sel = stored_control;
	always @(*) begin
		send_msg[((N_OUTPUTS - 1) - output_sel) * BIT_WIDTH+:BIT_WIDTH] = recv_msg;
		send_val[output_sel] = recv_val;
		recv_rdy = send_rdy[output_sel];
		begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < N_OUTPUTS; i = i + 1)
				if (i != output_sel) begin
					send_msg[((N_OUTPUTS - 1) - i) * BIT_WIDTH+:BIT_WIDTH] = 0;
					send_val[i] = 0;
				end
		end
		// begin : sv2v_autoblock_2
		// 	integer i;
		// 	for (i = 0; i < N_INPUTS; i = i + 1)
		// 		recv_rdy = 0;
		// end
	end
endmodule

module crossbaroneinVRTL2 (
	recv_msg,
	recv_val,
	recv_rdy,
	send_msg,
	send_val,
	send_rdy,
	reset,
	clk,
	control,
	control_val,
	control_rdy
);
	parameter BIT_WIDTH = 32;
	parameter N_INPUTS = 1;
	parameter N_OUTPUTS = 2;
	parameter CONTROL_BIT_WIDTH = 1;
	input wire [(N_INPUTS * BIT_WIDTH) - 1:0] recv_msg;
	input wire [N_INPUTS - 1:0] recv_val;
	output reg [N_INPUTS - 1:0] recv_rdy;
	output reg [(N_OUTPUTS * BIT_WIDTH) - 1:0] send_msg;
	output reg [N_OUTPUTS - 1:0] send_val;
	input wire [N_OUTPUTS - 1:0] send_rdy;
	input wire reset;
	input wire clk;
	input wire [CONTROL_BIT_WIDTH - 1:0] control;
	input wire control_val;
	output wire control_rdy;
	reg [CONTROL_BIT_WIDTH - 1:0] stored_control;
	wire [$clog2(N_OUTPUTS) - 1:0] output_sel;
	always @(posedge clk)
		if (reset)
			stored_control <= 0;
		else if (control_val)
			stored_control <= control;
	assign control_rdy = 1;
	always @(*) begin
		if (!stored_control) begin
			send_msg = recv_msg[63:32];
			send_val = recv_val[1];
			recv_rdy = send_rdy[1];
		end else begin
			send_msg = recv_msg[31:0];
			send_val = recv_val[0];
			recv_rdy = send_rdy[0];
		end
	end

endmodule


// module crossbaroneoutVRTL (
// 	recv_msg,
// 	recv_val,
// 	recv_rdy,
// 	send_msg,
// 	send_val,
// 	send_rdy,
// 	reset,
// 	clk,
// 	control,
// 	control_val,
// 	control_rdy
// );
// 	parameter BIT_WIDTH = 32;
// 	parameter N_INPUTS = 2;
// 	parameter N_OUTPUTS = 1;
// 	parameter CONTROL_BIT_WIDTH = 32;
// 	input wire [(N_INPUTS * BIT_WIDTH) - 1:0] recv_msg;
// 	input wire [N_INPUTS - 1:0] recv_val;
// 	output reg [N_INPUTS - 1:0] recv_rdy;
// 	output reg [BIT_WIDTH - 1:0] send_msg;
// 	output reg send_val;
// 	input wire send_rdy;
// 	input wire reset;
// 	input wire clk;
// 	input wire [CONTROL_BIT_WIDTH - 1:0] control;
// 	input wire control_val;
// 	output wire control_rdy;
// 	reg [CONTROL_BIT_WIDTH - 1:0] stored_control;
// 	always @(posedge clk)
// 		if (reset)
// 			stored_control <= 0;
// 		else if (control_val)
// 			stored_control <= control;
// 	assign control_rdy = 1;
// 	reg [CONTROL_BIT_WIDTH - 1:0] input_sel;
// 	assign input_sel = control;
// 	always @(*) begin
// 		if (stored_control == 0) send_msg = recv_msg[31:0];
// 		else send_msg = recv_msg[63:32];
// 		// send_msg = recv_msg[((N_INPUTS - 1) - input_sel) * BIT_WIDTH+:BIT_WIDTH];
// 		// send_msg = recv_msg[31:0];
// 		send_val = recv_val[input_sel];
// 		recv_rdy[input_sel] = send_rdy;
// 		begin : sv2v_autoblock_1
// 			integer j;
// 			for (j = 0; j < N_INPUTS; j = j + 1)
// 				if (j != input_sel)
// 					recv_rdy[j] = 0;
// 		end
// 	end
// endmodule

	module crossbaroneoutVRTL (
	recv_msg,
	recv_val,
	recv_rdy,
	send_msg,
	send_val,
	send_rdy,
	reset,
	clk,
	control,
	control_val,
	control_rdy
);
	parameter BIT_WIDTH = 32;
	parameter N_INPUTS = 2;
	parameter N_OUTPUTS = 1;
	parameter CONTROL_BIT_WIDTH = 32;
	input wire [(N_INPUTS * BIT_WIDTH) - 1:0] recv_msg;
	input wire [0:N_INPUTS - 1] recv_val;
	output reg [0:N_INPUTS - 1] recv_rdy;
	output reg [BIT_WIDTH - 1:0] send_msg;
	output reg send_val;
	input wire send_rdy;
	input wire reset;
	input wire clk;
	input wire [CONTROL_BIT_WIDTH - 1:0] control;
	input wire control_val;
	output wire control_rdy;
	reg [CONTROL_BIT_WIDTH - 1:0] stored_control;
	always @(posedge clk)
		if (reset)
			stored_control <= 0;
		else if (control_val)
			stored_control <= control;
	assign control_rdy = 1;
	wire [$clog2(N_INPUTS) - 1:0] input_sel;
	assign input_sel = stored_control[CONTROL_BIT_WIDTH - 1:CONTROL_BIT_WIDTH - $clog2(N_INPUTS)];
	always @(*) begin
		send_msg = recv_msg[((N_INPUTS - 1) - input_sel) * BIT_WIDTH+:BIT_WIDTH];
		send_val = recv_val[input_sel];
		recv_rdy[input_sel] = send_rdy;
		begin : sv2v_autoblock_1
			integer j;
			for (j = 0; j < N_INPUTS; j = j + 1)
				if (j != input_sel)
					recv_rdy[j] = 0;
		end
	end

endmodule
