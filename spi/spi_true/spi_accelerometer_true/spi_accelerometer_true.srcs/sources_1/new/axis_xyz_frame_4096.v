`timescale 1ns / 1ps

module axis_xyz_frame_4096 (
    input  wire        clk,
    input  wire        rstn,

    // Strumień z IIS3DWBG1:
    // X0, Y0, Z0, X1, Y1, Z1, ...
    input  wire [15:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,

    // Strumień do AXI DMA S2MM
    output wire [15:0] m_axis_tdata,
    output wire [1:0]  m_axis_tkeep,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready,
    output wire        m_axis_tlast,

    // Sygnał diagnostyczny do ILA
    output wire [13:0] dbg_word_count
);

    // 4096 kompletnych próbek XYZ:
    //
    // 4096 × 3 = 12288 słów 16-bitowych
    //
    // Numeracja słów:
    // 0      = X0
    // 1      = Y0
    // 2      = Z0
    // ...
    // 12285  = X4095
    // 12286  = Y4095
    // 12287  = Z4095

    localparam [13:0] LAST_WORD_INDEX = 14'd12287;

    reg [13:0] word_count;

    // Framer nie buforuje ani nie modyfikuje danych.
    assign m_axis_tdata  = s_axis_tdata;
    assign m_axis_tvalid = s_axis_tvalid;

    // Każde słowo ma pełne dwa poprawne bajty.
    assign m_axis_tkeep = 2'b11;

    // Backpressure z DMA jest przekazywany bezpośrednio do czujnika.
    assign s_axis_tready = m_axis_tready;

    // TLAST jest aktywny tylko dla ostatniego słowa ramki,
    // czyli dla próbki Z4095.
    assign m_axis_tlast =
        s_axis_tvalid &&
        (word_count == LAST_WORD_INDEX);

    assign dbg_word_count = word_count;

    // Liczymy wyłącznie rzeczywiście przesłane słowa AXI4-Stream.
    //
    // Transfer zachodzi tylko wtedy, gdy:
    // TVALID = 1 oraz TREADY = 1.
    always @(posedge clk) begin
        if (!rstn) begin
            word_count <= 14'd0;
        end
        else if (s_axis_tvalid && s_axis_tready) begin
            if (word_count == LAST_WORD_INDEX)
                word_count <= 14'd0;
            else
                word_count <= word_count + 14'd1;
        end
    end

endmodule