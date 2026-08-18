`timescale 1ns / 1ps

// Standalone KR260 hardware bring-up top.
//
// Uses the carrier-board 25 MHz HPA_CLK0P clock and exposes the sensor SPI
// interface on PMOD1. The 16-bit TDM receiver is held permanently ready.
// Debug signals are captured by an automatically generated Vivado ILA.
//
// PMOD1:
//   pin 1 -> CS_n
//   pin 2 -> MOSI / sensor SDI
//   pin 3 -> MISO / sensor SDO
//   pin 4 -> SCLK / sensor SPC
module iis3dwbg1_kr260_hw_top (
    input  wire clk_25mhz,

    output wire spi_cs_n,
    output wire spi_mosi,
    input  wire spi_miso,
    output wire spi_sclk
);



    localparam [31:0] POR_CYCLES = 32'd500_000;

    reg [31:0] por_counter = 32'd0;
    wire rstn_internal;

    assign rstn_internal = (por_counter >= POR_CYCLES);

    always @(posedge clk_25mhz) begin
        if (!rstn_internal)
            por_counter <= por_counter + 1'b1;
    end

    // Divided clock used only as an ILA diagnostic signal.
    //
    // clk_debug_div[2] toggles at:
    // 25 MHz / 8 = 3.125 MHz.
    //
    // The original clk_25mhz cannot be meaningfully observed by an ILA
    // clocked from the same clk_25mhz signal.
    reg [2:0] clk_debug_div = 3'd0;
    wire clk_25mhz_div8;

    always @(posedge clk_25mhz) begin
        clk_debug_div <= clk_debug_div + 1'b1;
    end

    assign clk_25mhz_div8 = clk_debug_div[2];
    
    wire [15:0] sensor_axis_tdata;
    wire [1:0]  sensor_axis_tkeep;
    wire        sensor_axis_tvalid;
    wire        sensor_axis_tready;
    wire        sensor_axis_tlast;

    wire [15:0] framed_axis_tdata;
    wire [1:0]  framed_axis_tkeep;
    wire        framed_axis_tvalid;
    wire        framed_axis_tready;
    wire        framed_axis_tlast;

    wire [13:0] framed_word_count;

    wire [7:0] who_am_i;
    wire sensor_ok;
    wire configured;
    wire sensor_error;

    wire signed [15:0] last_sample_x;
    wire signed [15:0] last_sample_y;
    wire signed [15:0] last_sample_z;

    wire [31:0] sensor_sample_count;
    wire [31:0] tdm_sample_count;
    wire [31:0] tdm_word_count;
    wire        tdm_overflow;
    //assign framed_axis_tready = 1'b1; //chwilowo
    // Status probe bit order:
    // [3] tdm_overflow
    // [2] sensor_error
    // [1] configured
    // [0] sensor_ok
    wire [3:0] debug_status;

    assign debug_status = {
        tdm_overflow,
        sensor_error,
        configured,
        sensor_ok
    };

    iis3dwbg1_tdm16 #(
    .CLK_FREQ_HZ (25_000_000),
    .SPI_CLK_HZ  (6_250_000),
    .STARTUP_MS  (20),
    .TLAST_ON_Z  (0)
) sensor_tdm_inst (
    .clk                 (clk_25mhz),
    .rstn                (rstn_internal),

    .spi_sclk            (spi_sclk),
    .spi_mosi            (spi_mosi),
    .spi_miso            (spi_miso),
    .spi_cs_n            (spi_cs_n),

    .m_axis_tdata        (sensor_axis_tdata),
    .m_axis_tkeep        (sensor_axis_tkeep),
    .m_axis_tvalid       (sensor_axis_tvalid),
    .m_axis_tready       (sensor_axis_tready),
    .m_axis_tlast        (sensor_axis_tlast),

    .who_am_i            (who_am_i),
    .sensor_ok           (sensor_ok),
    .configured          (configured),
    .sensor_error        (sensor_error),

    .last_sample_x       (last_sample_x),
    .last_sample_y       (last_sample_y),
    .last_sample_z       (last_sample_z),

    .sensor_sample_count (sensor_sample_count),
    .tdm_sample_count    (tdm_sample_count),
    .tdm_word_count      (tdm_word_count),
    .tdm_overflow        (tdm_overflow)
);
axis_xyz_frame_4096 axis_xyz_frame_4096_inst (
    .clk            (clk_25mhz),
    .rstn           (rstn_internal),

    .s_axis_tdata   (sensor_axis_tdata),
    .s_axis_tvalid  (sensor_axis_tvalid),
    .s_axis_tready  (sensor_axis_tready),

    .m_axis_tdata   (framed_axis_tdata),
    .m_axis_tkeep   (framed_axis_tkeep),
    .m_axis_tvalid  (framed_axis_tvalid),
    .m_axis_tready  (framed_axis_tready),
    .m_axis_tlast   (framed_axis_tlast),

    .dbg_word_count (framed_word_count)
);
dma_system dma_system_inst (
    .sensor_axis_aclk    (clk_25mhz),
    .sensor_axis_aresetn (rstn_internal),

    .sensor_axis_tdata   (framed_axis_tdata),
    .sensor_axis_tkeep   (framed_axis_tkeep),
    .sensor_axis_tvalid  (framed_axis_tvalid),
    .sensor_axis_tready  (framed_axis_tready),
    .sensor_axis_tlast   (framed_axis_tlast)
);
    // ILA configuration:
    //   probe0  - 8 bits
    //   probe1  - 4 bits
    //   probe2  - 16 bits
    //   probe3  - 16 bits
    //   probe4  - 16 bits
    //   probe5  - 16 bits
    //   probe6  - 1 bit
    //   probe7  - 32 bits
    //   probe8  - 32 bits
    //   probe9  - 32 bits
    //   probe10 - 1 bit
    //   probe11 - 1 bit
    //   probe12 - 1 bit
    ila_spi_debug ila_spi_debug_inst (
        .clk     (clk_25mhz),

        .probe0  (who_am_i),
        .probe1  (debug_status),

        .probe2  (last_sample_x),
        .probe3  (last_sample_y),
        .probe4  (last_sample_z),

        .probe5  (framed_axis_data),
        .probe6  (framed_axis_tvalid),

        .probe7  (frame_debug_bus),
        .probe8  (tdm_sample_count),
        .probe9  (tdm_word_count),

        .probe10 (spi_cs_n),
        .probe11 (spi_sclk),

        // Visible ILA clock diagnostic: 3.125 MHz.
        .probe12 (clk_25mhz_div8),
        .probe13 (rstn_internal),
        .probe14 (por_counter),
        .probe15 (spi_mosi),
        .probe16 (spi_miso)
    );
wire [31:0] frame_debug_bus;

assign frame_debug_bus = {
    13'd0,                  // [31:19]
    framed_word_count,      // [18:5]
    framed_axis_tkeep,      // [4:3]
    framed_axis_tvalid,     // [2]
    framed_axis_tready,     // [1]
    framed_axis_tlast       // [0]
};
endmodule