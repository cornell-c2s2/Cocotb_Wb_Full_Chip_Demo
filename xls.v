module fadd_p4(
  input wire clk,
  input wire [31:0] inp,
  output wire [31:0] out
);
  // ===== Pipe stage 0:

  // Registers for pipe stage 0:
  reg [31:0] p0_inp;
  always_ff @ (posedge clk) begin
    p0_inp <= inp;
  end

  // ===== Pipe stage 1:
  wire [7:0] p1_inp_bexp__3_comb;
  wire [22:0] p1_inp_fraction__2_comb;
  wire [5:0] p1_add_1779_comb;
  wire [7:0] p1_y_bexp__2_comb;
  wire [27:0] p1_wide_x_comb;
  wire [7:0] p1_greater_exp_bexp_comb;
  wire [27:0] p1_wide_x__1_comb;
  wire [7:0] p1_sub_1789_comb;
  wire [27:0] p1_wide_y__1_comb;
  wire [7:0] p1_sub_1791_comb;
  wire [27:0] p1_dropped_x_comb;
  wire [27:0] p1_dropped_y_comb;
  wire [7:0] p1_shift_x_comb;
  wire p1_sticky_x_comb;
  wire [27:0] p1_wide_y__3_comb;
  wire [7:0] p1_shift_y_comb;
  wire p1_sticky_y_comb;
  wire p1_inp_sign__2_comb;
  wire [27:0] p1_shifted_x_comb;
  wire [27:0] p1_shifted_y_comb;
  wire p1_greater_exp_sign_comb;
  wire [27:0] p1_addend_x_comb;
  wire [27:0] p1_addend_y_comb;
  wire [7:0] p1_max_exp_comb;
  wire [27:0] p1_addend_x__1_comb;
  wire [27:0] p1_addend_y__1_comb;
  wire p1_nand_1821_comb;
  wire p1_eq_1823_comb;
  wire p1_eq_1824_comb;
  wire p1_ne_1825_comb;
  assign p1_inp_bexp__3_comb = p0_inp[30:23];
  assign p1_inp_fraction__2_comb = p0_inp[22:0];
  assign p1_add_1779_comb = p1_inp_bexp__3_comb[7:2] + 6'h07;
  assign p1_y_bexp__2_comb = 8'h7f;
  assign p1_wide_x_comb = {{2'h0, p1_inp_fraction__2_comb} | 25'h080_0000, 3'h0};
  assign p1_greater_exp_bexp_comb = ~(p1_inp_bexp__3_comb[7] | p1_inp_bexp__3_comb[0] & p1_inp_bexp__3_comb[1] & p1_inp_bexp__3_comb[2] & p1_inp_bexp__3_comb[3] & p1_inp_bexp__3_comb[4] & p1_inp_bexp__3_comb[5] & p1_inp_bexp__3_comb[6]) ? p1_y_bexp__2_comb : p1_inp_bexp__3_comb;
  assign p1_wide_x__1_comb = p1_wide_x_comb & {28{p1_inp_bexp__3_comb != 8'h00}};
  assign p1_sub_1789_comb = {p1_add_1779_comb, p1_inp_bexp__3_comb[1:0]} - p1_greater_exp_bexp_comb;
  assign p1_wide_y__1_comb = 28'h400_0000;
  assign p1_sub_1791_comb = 8'h9b - p1_greater_exp_bexp_comb;
  assign p1_dropped_x_comb = p1_sub_1789_comb >= 8'h1c ? 28'h000_0000 : p1_wide_x__1_comb << p1_sub_1789_comb;
  assign p1_dropped_y_comb = p1_sub_1791_comb >= 8'h1c ? 28'h000_0000 : p1_wide_y__1_comb << p1_sub_1791_comb;
  assign p1_shift_x_comb = p1_greater_exp_bexp_comb - p1_inp_bexp__3_comb;
  assign p1_sticky_x_comb = p1_dropped_x_comb[27:3] != 25'h000_0000;
  assign p1_wide_y__3_comb = 28'h400_0000;
  assign p1_shift_y_comb = p1_greater_exp_bexp_comb + 8'h81;
  assign p1_sticky_y_comb = p1_dropped_y_comb[27:26] != 2'h0;
  assign p1_inp_sign__2_comb = p0_inp[31:31];
  assign p1_shifted_x_comb = p1_shift_x_comb >= 8'h1c ? 28'h000_0000 : p1_wide_x__1_comb >> p1_shift_x_comb;
  assign p1_shifted_y_comb = p1_shift_y_comb >= 8'h1c ? 28'h000_0000 : p1_wide_y__3_comb >> p1_shift_y_comb;
  assign p1_greater_exp_sign_comb = p1_inp_bexp__3_comb[7] & p1_inp_sign__2_comb;
  assign p1_addend_x_comb = p1_shifted_x_comb | {27'h000_0000, p1_sticky_x_comb};
  assign p1_addend_y_comb = p1_shifted_y_comb | {27'h000_0000, p1_sticky_y_comb};
  assign p1_max_exp_comb = 8'hff;
  assign p1_addend_x__1_comb = p1_inp_sign__2_comb ^ p1_greater_exp_sign_comb ? -p1_addend_x_comb : p1_addend_x_comb;
  assign p1_addend_y__1_comb = p1_greater_exp_sign_comb ? -p1_addend_y_comb : p1_addend_y_comb;
  assign p1_nand_1821_comb = ~(p1_inp_bexp__3_comb[7] & p1_inp_sign__2_comb);
  assign p1_eq_1823_comb = p1_inp_bexp__3_comb == p1_max_exp_comb;
  assign p1_eq_1824_comb = p1_inp_fraction__2_comb == 23'h00_0000;
  assign p1_ne_1825_comb = p1_inp_fraction__2_comb != 23'h00_0000;

  // Registers for pipe stage 1:
  reg [7:0] p1_greater_exp_bexp;
  reg p1_inp_sign__2;
  reg p1_greater_exp_sign;
  reg [27:0] p1_addend_x__1;
  reg [27:0] p1_addend_y__1;
  reg p1_nand_1821;
  reg p1_eq_1823;
  reg p1_eq_1824;
  reg p1_ne_1825;
  always_ff @ (posedge clk) begin
    p1_greater_exp_bexp <= p1_greater_exp_bexp_comb;
    p1_inp_sign__2 <= p1_inp_sign__2_comb;
    p1_greater_exp_sign <= p1_greater_exp_sign_comb;
    p1_addend_x__1 <= p1_addend_x__1_comb;
    p1_addend_y__1 <= p1_addend_y__1_comb;
    p1_nand_1821 <= p1_nand_1821_comb;
    p1_eq_1823 <= p1_eq_1823_comb;
    p1_eq_1824 <= p1_eq_1824_comb;
    p1_ne_1825 <= p1_ne_1825_comb;
  end

  // ===== Pipe stage 2:
  wire [28:0] p2_fraction_comb;
  wire [27:0] p2_abs_fraction_comb;
  wire [27:0] p2_reverse_1854_comb;
  wire [28:0] p2_one_hot_1855_comb;
  wire [4:0] p2_encode_1856_comb;
  wire p2_fraction_is_zero_comb;
  wire p2_cancel_comb;
  wire p2_carry_bit_comb;
  wire [27:0] p2_leading_zeroes_comb;
  wire p2_is_operand_inf_comb;
  wire p2_result_sign_comb;
  wire p2_and_1872_comb;
  wire p2_and_1871_comb;
  wire p2_and_1870_comb;
  wire [26:0] p2_carry_fraction_comb;
  wire [26:0] p2_bit_slice_1875_comb;
  wire [27:0] p2_add_1876_comb;
  wire p2_result_sign__1_comb;
  wire [2:0] p2_concat_1877_comb;
  wire [26:0] p2_carry_fraction__1_comb;
  wire [26:0] p2_cancel_fraction_comb;
  wire p2_ne_1881_comb;
  wire p2_nand_1887_comb;
  wire p2_is_result_nan_comb;
  wire p2_result_sign__2_comb;
  assign p2_fraction_comb = {{1{p1_addend_x__1[27]}}, p1_addend_x__1} + {{1{p1_addend_y__1[27]}}, p1_addend_y__1};
  assign p2_abs_fraction_comb = p2_fraction_comb[28] ? -p2_fraction_comb[27:0] : p2_fraction_comb[27:0];
  assign p2_reverse_1854_comb = {p2_abs_fraction_comb[0], p2_abs_fraction_comb[1], p2_abs_fraction_comb[2], p2_abs_fraction_comb[3], p2_abs_fraction_comb[4], p2_abs_fraction_comb[5], p2_abs_fraction_comb[6], p2_abs_fraction_comb[7], p2_abs_fraction_comb[8], p2_abs_fraction_comb[9], p2_abs_fraction_comb[10], p2_abs_fraction_comb[11], p2_abs_fraction_comb[12], p2_abs_fraction_comb[13], p2_abs_fraction_comb[14], p2_abs_fraction_comb[15], p2_abs_fraction_comb[16], p2_abs_fraction_comb[17], p2_abs_fraction_comb[18], p2_abs_fraction_comb[19], p2_abs_fraction_comb[20], p2_abs_fraction_comb[21], p2_abs_fraction_comb[22], p2_abs_fraction_comb[23], p2_abs_fraction_comb[24], p2_abs_fraction_comb[25], p2_abs_fraction_comb[26], p2_abs_fraction_comb[27]};
  assign p2_one_hot_1855_comb = {p2_reverse_1854_comb[27:0] == 28'h000_0000, p2_reverse_1854_comb[27] && p2_reverse_1854_comb[26:0] == 27'h000_0000, p2_reverse_1854_comb[26] && p2_reverse_1854_comb[25:0] == 26'h000_0000, p2_reverse_1854_comb[25] && p2_reverse_1854_comb[24:0] == 25'h000_0000, p2_reverse_1854_comb[24] && p2_reverse_1854_comb[23:0] == 24'h00_0000, p2_reverse_1854_comb[23] && p2_reverse_1854_comb[22:0] == 23'h00_0000, p2_reverse_1854_comb[22] && p2_reverse_1854_comb[21:0] == 22'h00_0000, p2_reverse_1854_comb[21] && p2_reverse_1854_comb[20:0] == 21'h00_0000, p2_reverse_1854_comb[20] && p2_reverse_1854_comb[19:0] == 20'h0_0000, p2_reverse_1854_comb[19] && p2_reverse_1854_comb[18:0] == 19'h0_0000, p2_reverse_1854_comb[18] && p2_reverse_1854_comb[17:0] == 18'h0_0000, p2_reverse_1854_comb[17] && p2_reverse_1854_comb[16:0] == 17'h0_0000, p2_reverse_1854_comb[16] && p2_reverse_1854_comb[15:0] == 16'h0000, p2_reverse_1854_comb[15] && p2_reverse_1854_comb[14:0] == 15'h0000, p2_reverse_1854_comb[14] && p2_reverse_1854_comb[13:0] == 14'h0000, p2_reverse_1854_comb[13] && p2_reverse_1854_comb[12:0] == 13'h0000, p2_reverse_1854_comb[12] && p2_reverse_1854_comb[11:0] == 12'h000, p2_reverse_1854_comb[11] && p2_reverse_1854_comb[10:0] == 11'h000, p2_reverse_1854_comb[10] && p2_reverse_1854_comb[9:0] == 10'h000, p2_reverse_1854_comb[9] && p2_reverse_1854_comb[8:0] == 9'h000, p2_reverse_1854_comb[8] && p2_reverse_1854_comb[7:0] == 8'h00, p2_reverse_1854_comb[7] && p2_reverse_1854_comb[6:0] == 7'h00, p2_reverse_1854_comb[6] && p2_reverse_1854_comb[5:0] == 6'h00, p2_reverse_1854_comb[5] && p2_reverse_1854_comb[4:0] == 5'h00, p2_reverse_1854_comb[4] && p2_reverse_1854_comb[3:0] == 4'h0, p2_reverse_1854_comb[3] && p2_reverse_1854_comb[2:0] == 3'h0, p2_reverse_1854_comb[2] && p2_reverse_1854_comb[1:0] == 2'h0, p2_reverse_1854_comb[1] && !p2_reverse_1854_comb[0], p2_reverse_1854_comb[0]};
  assign p2_encode_1856_comb = {p2_one_hot_1855_comb[16] | p2_one_hot_1855_comb[17] | p2_one_hot_1855_comb[18] | p2_one_hot_1855_comb[19] | p2_one_hot_1855_comb[20] | p2_one_hot_1855_comb[21] | p2_one_hot_1855_comb[22] | p2_one_hot_1855_comb[23] | p2_one_hot_1855_comb[24] | p2_one_hot_1855_comb[25] | p2_one_hot_1855_comb[26] | p2_one_hot_1855_comb[27] | p2_one_hot_1855_comb[28], p2_one_hot_1855_comb[8] | p2_one_hot_1855_comb[9] | p2_one_hot_1855_comb[10] | p2_one_hot_1855_comb[11] | p2_one_hot_1855_comb[12] | p2_one_hot_1855_comb[13] | p2_one_hot_1855_comb[14] | p2_one_hot_1855_comb[15] | p2_one_hot_1855_comb[24] | p2_one_hot_1855_comb[25] | p2_one_hot_1855_comb[26] | p2_one_hot_1855_comb[27] | p2_one_hot_1855_comb[28], p2_one_hot_1855_comb[4] | p2_one_hot_1855_comb[5] | p2_one_hot_1855_comb[6] | p2_one_hot_1855_comb[7] | p2_one_hot_1855_comb[12] | p2_one_hot_1855_comb[13] | p2_one_hot_1855_comb[14] | p2_one_hot_1855_comb[15] | p2_one_hot_1855_comb[20] | p2_one_hot_1855_comb[21] | p2_one_hot_1855_comb[22] | p2_one_hot_1855_comb[23] | p2_one_hot_1855_comb[28], p2_one_hot_1855_comb[2] | p2_one_hot_1855_comb[3] | p2_one_hot_1855_comb[6] | p2_one_hot_1855_comb[7] | p2_one_hot_1855_comb[10] | p2_one_hot_1855_comb[11] | p2_one_hot_1855_comb[14] | p2_one_hot_1855_comb[15] | p2_one_hot_1855_comb[18] | p2_one_hot_1855_comb[19] | p2_one_hot_1855_comb[22] | p2_one_hot_1855_comb[23] | p2_one_hot_1855_comb[26] | p2_one_hot_1855_comb[27], p2_one_hot_1855_comb[1] | p2_one_hot_1855_comb[3] | p2_one_hot_1855_comb[5] | p2_one_hot_1855_comb[7] | p2_one_hot_1855_comb[9] | p2_one_hot_1855_comb[11] | p2_one_hot_1855_comb[13] | p2_one_hot_1855_comb[15] | p2_one_hot_1855_comb[17] | p2_one_hot_1855_comb[19] | p2_one_hot_1855_comb[21] | p2_one_hot_1855_comb[23] | p2_one_hot_1855_comb[25] | p2_one_hot_1855_comb[27]};
  assign p2_fraction_is_zero_comb = p2_fraction_comb == 29'h0000_0000;
  assign p2_cancel_comb = p2_encode_1856_comb[1] | p2_encode_1856_comb[2] | p2_encode_1856_comb[3] | p2_encode_1856_comb[4];
  assign p2_carry_bit_comb = p2_abs_fraction_comb[27];
  assign p2_leading_zeroes_comb = {23'h00_0000, p2_encode_1856_comb};
  assign p2_is_operand_inf_comb = p1_eq_1823 & p1_eq_1824;
  assign p2_result_sign_comb = p2_fraction_comb[28] & p1_nand_1821 | ~(p2_fraction_comb[28] | p2_fraction_is_zero_comb) & p1_greater_exp_sign;
  assign p2_and_1872_comb = p2_carry_bit_comb & ~p2_cancel_comb;
  assign p2_and_1871_comb = ~p2_carry_bit_comb & p2_cancel_comb;
  assign p2_and_1870_comb = ~p2_carry_bit_comb & ~p2_cancel_comb;
  assign p2_carry_fraction_comb = p2_abs_fraction_comb[27:1];
  assign p2_bit_slice_1875_comb = p2_abs_fraction_comb[26:0];
  assign p2_add_1876_comb = p2_leading_zeroes_comb + 28'hfff_ffff;
  assign p2_result_sign__1_comb = p2_is_operand_inf_comb ? p1_inp_sign__2 : p2_result_sign_comb;
  assign p2_concat_1877_comb = {p2_and_1870_comb, p2_and_1871_comb, p2_and_1872_comb};
  assign p2_carry_fraction__1_comb = p2_carry_fraction_comb | {26'h000_0000, p2_abs_fraction_comb[0]};
  assign p2_cancel_fraction_comb = p2_add_1876_comb >= 28'h000_001b ? 27'h000_0000 : p2_bit_slice_1875_comb << p2_add_1876_comb;
  assign p2_ne_1881_comb = p2_fraction_comb != 29'h0000_0000;
  assign p2_nand_1887_comb = ~(p1_eq_1823 & p1_eq_1824);
  assign p2_is_result_nan_comb = p1_eq_1823 & p1_ne_1825;
  assign p2_result_sign__2_comb = ~(p1_eq_1823 & p1_ne_1825) & p2_result_sign__1_comb;

  // Registers for pipe stage 2:
  reg [7:0] p2_greater_exp_bexp;
  reg [4:0] p2_encode_1856;
  reg [26:0] p2_bit_slice_1875;
  reg [2:0] p2_concat_1877;
  reg [26:0] p2_carry_fraction__1;
  reg [26:0] p2_cancel_fraction;
  reg p2_ne_1881;
  reg p2_nand_1887;
  reg p2_is_operand_inf;
  reg p2_is_result_nan;
  reg p2_result_sign__2;
  always_ff @ (posedge clk) begin
    p2_greater_exp_bexp <= p1_greater_exp_bexp;
    p2_encode_1856 <= p2_encode_1856_comb;
    p2_bit_slice_1875 <= p2_bit_slice_1875_comb;
    p2_concat_1877 <= p2_concat_1877_comb;
    p2_carry_fraction__1 <= p2_carry_fraction__1_comb;
    p2_cancel_fraction <= p2_cancel_fraction_comb;
    p2_ne_1881 <= p2_ne_1881_comb;
    p2_nand_1887 <= p2_nand_1887_comb;
    p2_is_operand_inf <= p2_is_operand_inf_comb;
    p2_is_result_nan <= p2_is_result_nan_comb;
    p2_result_sign__2 <= p2_result_sign__2_comb;
  end

  // ===== Pipe stage 3:
  wire [26:0] p3_shifted_fraction_comb;
  wire [2:0] p3_normal_chunk_comb;
  wire [1:0] p3_half_way_chunk_comb;
  wire [24:0] p3_add_1930_comb;
  wire p3_do_round_up_comb;
  wire [27:0] p3_rounded_fraction_comb;
  wire p3_rounding_carry_comb;
  wire [8:0] p3_add_1941_comb;
  wire [9:0] p3_add_1945_comb;
  wire [2:0] p3_add_1953_comb;
  wire [9:0] p3_wide_exponent_comb;
  wire [27:0] p3_shrl_1954_comb;
  wire [9:0] p3_wide_exponent__1_comb;
  wire [22:0] p3_result_fraction_comb;
  assign p3_shifted_fraction_comb = p2_carry_fraction__1 & {27{p2_concat_1877[0]}} | p2_cancel_fraction & {27{p2_concat_1877[1]}} | p2_bit_slice_1875 & {27{p2_concat_1877[2]}};
  assign p3_normal_chunk_comb = p3_shifted_fraction_comb[2:0];
  assign p3_half_way_chunk_comb = p3_shifted_fraction_comb[3:2];
  assign p3_add_1930_comb = {1'h0, p3_shifted_fraction_comb[26:3]} + 25'h000_0001;
  assign p3_do_round_up_comb = p3_normal_chunk_comb > 3'h4 | p3_half_way_chunk_comb == 2'h3;
  assign p3_rounded_fraction_comb = p3_do_round_up_comb ? {p3_add_1930_comb, p3_normal_chunk_comb} : {1'h0, p3_shifted_fraction_comb};
  assign p3_rounding_carry_comb = p3_rounded_fraction_comb[27];
  assign p3_add_1941_comb = {1'h0, p2_greater_exp_bexp} + {8'h00, p3_rounding_carry_comb};
  assign p3_add_1945_comb = {1'h0, p3_add_1941_comb} + 10'h001;
  assign p3_add_1953_comb = {2'h0, p3_rounding_carry_comb} + 3'h3;
  assign p3_wide_exponent_comb = p3_add_1945_comb - {5'h00, p2_encode_1856};
  assign p3_shrl_1954_comb = p3_rounded_fraction_comb >> p3_add_1953_comb;
  assign p3_wide_exponent__1_comb = p3_wide_exponent_comb & {10{p2_ne_1881}};
  assign p3_result_fraction_comb = p3_shrl_1954_comb[22:0];

  // Registers for pipe stage 3:
  reg [9:0] p3_wide_exponent__1;
  reg p3_nand_1887;
  reg p3_is_operand_inf;
  reg p3_is_result_nan;
  reg [22:0] p3_result_fraction;
  reg p3_result_sign__2;
  always_ff @ (posedge clk) begin
    p3_wide_exponent__1 <= p3_wide_exponent__1_comb;
    p3_nand_1887 <= p2_nand_1887;
    p3_is_operand_inf <= p2_is_operand_inf;
    p3_is_result_nan <= p2_is_result_nan;
    p3_result_fraction <= p3_result_fraction_comb;
    p3_result_sign__2 <= p2_result_sign__2;
  end

  // ===== Pipe stage 4:
  wire [8:0] p4_wide_exponent__2_comb;
  wire p4_nor_1985_comb;
  wire [7:0] p4_max_exp__2_comb;
  wire [22:0] p4_result_fraction__3_comb;
  wire [22:0] p4_fraction_high_bit_comb;
  wire [7:0] p4_result_exponent__2_comb;
  wire [22:0] p4_result_fraction__4_comb;
  wire [31:0] p4_tuple_1998_comb;
  assign p4_wide_exponent__2_comb = p3_wide_exponent__1[8:0] & {9{~p3_wide_exponent__1[9]}};
  assign p4_nor_1985_comb = ~(p4_wide_exponent__2_comb[8] | p4_wide_exponent__2_comb[0] & p4_wide_exponent__2_comb[1] & p4_wide_exponent__2_comb[2] & p4_wide_exponent__2_comb[3] & p4_wide_exponent__2_comb[4] & p4_wide_exponent__2_comb[5] & p4_wide_exponent__2_comb[6] & p4_wide_exponent__2_comb[7]);
  assign p4_max_exp__2_comb = 8'hff;
  assign p4_result_fraction__3_comb = p3_result_fraction & {23{~(~(p4_wide_exponent__2_comb[1] | p4_wide_exponent__2_comb[2] | p4_wide_exponent__2_comb[3] | p4_wide_exponent__2_comb[4] | p4_wide_exponent__2_comb[5] | p4_wide_exponent__2_comb[6] | p4_wide_exponent__2_comb[7] | p4_wide_exponent__2_comb[8] | p4_wide_exponent__2_comb[0]))}} & {23{p4_nor_1985_comb}} & {23{p3_nand_1887}};
  assign p4_fraction_high_bit_comb = 23'h40_0000;
  assign p4_result_exponent__2_comb = p3_is_result_nan | p3_is_operand_inf | ~p4_nor_1985_comb ? p4_max_exp__2_comb : p4_wide_exponent__2_comb[7:0];
  assign p4_result_fraction__4_comb = p3_is_result_nan ? p4_fraction_high_bit_comb : p4_result_fraction__3_comb;
  assign p4_tuple_1998_comb = {p3_result_sign__2, p4_result_exponent__2_comb, p4_result_fraction__4_comb};

  // Registers for pipe stage 4:
  reg [31:0] p4_tuple_1998;
  always_ff @ (posedge clk) begin
    p4_tuple_1998 <= p4_tuple_1998_comb;
  end
  carry_and_cancel: assert property (@(posedge clk) disable iff ($isunknown(p2_and_1872_comb | p2_and_1871_comb | p2_and_1870_comb)) p2_and_1872_comb | p2_and_1871_comb | p2_and_1870_comb) else $fatal(0, "Assertion failure via fail! @ xls/dslx/stdlib/apfloat.x:1683:15-1683:62");
  assign out = p4_tuple_1998;
endmodule

module XLS_Wrapper (
  input wire clk,
  input wire reset,

  input  wire [31:0] op0,
  output wire [31:0] out,

  input  wire istream_val,
  output wire istream_rdy,
  output wire ostream_val,
  input wire ostream_rdy,
);

  reg [2:0] counter;

  localparam IDLE = 2'd0;
  localparam CALC = 2'd1;
  localparam DONE = 2'd2;

  reg [1:0] state;
  reg [1:0] next_state;

  always @(posedge clk) begin
    if ( reset ) state <= IDLE;
    else state <= next_state;
  end

  always @(posedge clk) begin
    if (reset) counter <= 3'd0;
    else if ( counter == 3'd4 ) counter <= 3'd0;
    else if ( state == CALC ) counter <= counter + 3'd1;
    else counter <= counter;
  end

  always @(posedge clk) begin
    case (state)
      IDLE:
        if ( !istream_val ) next_state = IDLE;
        else next_state = CALC;
      CALC:
        if ( counter == 4'd4 ) next_state = DONE;
        else next_state = CALC;
      DONE:
        if ( !ostream_rdy ) next_state = DONE;
        else next_state = IDLE;
      default:
        next_state = state;
    endcase
  end

  always @(*) begin
    case (state)
      IDLE:
        istream_rdy = 1'b1;
        ostream_val = 1'b0;
      CALC:
        istream_rdy = 1'b0;
        ostream_val = 1'b0
      DONE:
        istream_rdy = 1'b0;
        ostream_val = 1'b1;
      default:
        istream_rdy = 1'b0;
        ostream_val = 1'b0;
    endcase
  end

  fadd_p4 xls (
    .clk (clk),
    .inp (op0),
    .out (out)
  );
  
endmodule