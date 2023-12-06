//========================================================================
// RegInc Test
//========================================================================

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
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
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

        //wb -> adder
        .i_stream_val (c_i_stream_val),
        .i_stream_data(c_i_stream_data),
        .o_stream_rdy (c_o_stream_rdy),

        //adder -> wb
        .i_stream_rdy (c_i_stream_rdy),
        .o_stream_val (c_o_stream_val),
        .o_stream_data(c_o_stream_data)

    );

    Adder adder (
        //‘ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
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