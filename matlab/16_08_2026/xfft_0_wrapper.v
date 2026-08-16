`timescale 1ns / 1ps

module xfft_0_wrapper (
    input wire          clk,
    input wire          ce,
    input wire [47:0]   s_axis_config_tdata,
    input wire          s_axis_config_tvalid,
    output wire          s_axis_config_tready,
    input wire [15:0]   s_axis_data_tdata_channel_3_imag,
    input wire [15:0]   s_axis_data_tdata_channel_3_real,
    input wire [15:0]   s_axis_data_tdata_channel_2_imag,
    input wire [15:0]   s_axis_data_tdata_channel_2_real,
    input wire [15:0]   s_axis_data_tdata_channel_1_imag,
    input wire [15:0]   s_axis_data_tdata_channel_1_real,
    input wire          s_axis_data_tvalid,
    output wire         s_axis_data_tready,
    input wire          s_axis_data_tlast,
    output wire [15:0]   m_axis_data_tdata_channel_3_imag,
    output wire [15:0]   m_axis_data_tdata_channel_3_real,
    output wire [15:0]   m_axis_data_tdata_channel_2_imag,
    output wire [15:0]   m_axis_data_tdata_channel_2_real,
    output wire [15:0]   m_axis_data_tdata_channel_1_imag,
    output wire [15:0]   m_axis_data_tdata_channel_1_real,
    output wire         m_axis_data_tvalid,
    input wire          m_axis_data_tready,
    output wire         m_axis_data_tlast,
    output wire         event_tlast_missing,
    output wire         event_tlast_unexpected,
    output wire         event_status_channel_halt,
    output wire         event_data_in_channel_halt,
    output wire         event_data_out_channel_halt
);

    // Instancjacja Twojego wygenerowanego rdzenia IP (ta nazwa pozostaje bez zmian)
    xfft_0 my_xfft_core (
        .aclk(clk),
        .s_axis_config_tdata(s_axis_config_tdata),
        .s_axis_config_tvalid(s_axis_config_tvalid),
        .s_axis_config_tready(s_axis_config_tready),
        
        .s_axis_data_tdata({s_axis_data_tdata_channel_3_imag,s_axis_data_tdata_channel_3_real,s_axis_data_tdata_channel_2_imag,s_axis_data_tdata_channel_2_real,s_axis_data_tdata_channel_1_imag,s_axis_data_tdata_channel_1_real}),
        
        .s_axis_data_tvalid(s_axis_data_tvalid),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tlast(s_axis_data_tlast),
        
        .m_axis_data_tdata({m_axis_data_tdata_channel_3_imag,m_axis_data_tdata_channel_3_real,m_axis_data_tdata_channel_2_imag,m_axis_data_tdata_channel_2_real,m_axis_data_tdata_channel_1_imag,m_axis_data_tdata_channel_1_real}),
        
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .m_axis_data_tready(m_axis_data_tready),
        .m_axis_data_tlast(m_axis_data_tlast),
        .event_tlast_missing(event_tlast_missing),
        .event_tlast_unexpected(event_tlast_unexpected),
        .event_status_channel_halt(event_status_channel_halt),
        .event_data_in_channel_halt(event_data_in_channel_halt),
        .event_data_out_channel_halt(event_data_out_channel_halt)
    );

endmodule