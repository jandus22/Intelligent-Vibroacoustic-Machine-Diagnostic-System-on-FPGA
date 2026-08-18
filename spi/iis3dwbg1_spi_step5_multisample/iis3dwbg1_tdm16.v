`timescale 1ns / 1ps

// Test-stage top level:
// IIS3DWBG1 SPI controller -> parallel XYZ -> 16-bit AXI4-Stream TDM.
//
// Graybox input order:
//   X, Y, Z, X, Y, Z, ...
module iis3dwbg1_tdm16 #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer SPI_CLK_HZ  = 5_000_000,
    parameter integer STARTUP_MS  = 20,
    parameter integer TLAST_ON_Z  = 0
) (
    input  wire                    clk,
    input  wire                    rstn,

    output wire                    spi_sclk,
    output wire                    spi_mosi,
    input  wire                    spi_miso,
    output wire                    spi_cs_n,

    output wire [15:0]             m_axis_tdata,
    output wire [1:0]              m_axis_tkeep,
    output wire                    m_axis_tvalid,
    input  wire                    m_axis_tready,
    output wire                    m_axis_tlast,

    output wire [7:0]              who_am_i,
    output wire                    sensor_ok,
    output wire                    configured,
    output wire                    sensor_error,

    output wire signed [15:0]      last_sample_x,
    output wire signed [15:0]      last_sample_y,
    output wire signed [15:0]      last_sample_z,
    output wire [31:0]             sensor_sample_count,
    output wire [31:0]             tdm_sample_count,
    output wire [31:0]             tdm_word_count,
    output wire                    tdm_overflow
);

    wire sample_valid;

    iis3dwbg1_xyz #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .SPI_CLK_HZ (SPI_CLK_HZ),
        .STARTUP_MS (STARTUP_MS)
    ) sensor_controller_inst (
        .clk          (clk),
        .rstn         (rstn),
        .spi_sclk     (spi_sclk),
        .spi_mosi     (spi_mosi),
        .spi_miso     (spi_miso),
        .spi_cs_n     (spi_cs_n),
        .who_am_i     (who_am_i),
        .sensor_ok    (sensor_ok),
        .configured   (configured),
        .sensor_error (sensor_error),
        .sample_x     (last_sample_x),
        .sample_y     (last_sample_y),
        .sample_z     (last_sample_z),
        .sample_valid (sample_valid),
        .sample_count (sensor_sample_count)
    );

    axis_xyz_tdm16 #(
        .TLAST_ON_Z(TLAST_ON_Z)
    ) tdm_packer_inst (
        .clk                 (clk),
        .rstn                (rstn),
        .sample_x            (last_sample_x),
        .sample_y            (last_sample_y),
        .sample_z            (last_sample_z),
        .sample_valid        (sample_valid),
        .sample_overflow     (tdm_overflow),
        .stream_sample_count (tdm_sample_count),
        .stream_word_count   (tdm_word_count),
        .m_axis_tdata        (m_axis_tdata),
        .m_axis_tkeep        (m_axis_tkeep),
        .m_axis_tvalid       (m_axis_tvalid),
        .m_axis_tready       (m_axis_tready),
        .m_axis_tlast        (m_axis_tlast)
    );

endmodule
