module mul_p4(
  input wire clk,
  input wire [31:0] input,
  output wire [31:0] out
);
  // lint_off MULTIPLY
  function automatic [15:0] umul16b_16b_x_16b (input reg [15:0] lhs, input reg [15:0] rhs);
    begin
      umul16b_16b_x_16b = lhs * rhs;
    end
  endfunction
  // lint_on MULTIPLY

  // ===== Pipe stage 0:
  wire [15:0] p0_literal_19_comb;
  assign p0_literal_19_comb = 16'h0000;

  // Registers for pipe stage 0:
  reg [31:0] p0_input;
  reg [15:0] p3_literal_19;
  always_ff @ (posedge clk) begin
    p0_input <= input;
    p3_literal_19 <= p0_literal_19_comb;
  end

  // ===== Pipe stage 1:
  wire [15:0] p1_a_comb;
  wire [15:0] p1_b_comb;
  assign p1_a_comb = p0_input[31:16];
  assign p1_b_comb = p0_input[15:0];

  // Registers for pipe stage 1:
  reg [15:0] p1_a;
  reg [15:0] p1_b;
  always_ff @ (posedge clk) begin
    p1_a <= p1_a_comb;
    p1_b <= p1_b_comb;
  end

  // ===== Pipe stage 2:
  wire [15:0] p2_umul_16_comb;
  assign p2_umul_16_comb = umul16b_16b_x_16b(p1_a, p1_b);

  // Registers for pipe stage 2:
  reg [15:0] p2_umul_16;
  always_ff @ (posedge clk) begin
    p2_umul_16 <= p2_umul_16_comb;
  end

  // ===== Pipe stage 3:

  // Registers for pipe stage 3:
  reg [15:0] p3_umul_16;
  always_ff @ (posedge clk) begin
    p3_umul_16 <= p2_umul_16;
  end

  // ===== Pipe stage 4:
  wire [31:0] p4_tuple_24_comb;
  assign p4_tuple_24_comb = {p3_literal_19, p3_umul_16};

  // Registers for pipe stage 4:
  reg [31:0] p4_tuple_24;
  always_ff @ (posedge clk) begin
    p4_tuple_24 <= p4_tuple_24_comb;
  end
  assign out = p4_tuple_24;
endmodule