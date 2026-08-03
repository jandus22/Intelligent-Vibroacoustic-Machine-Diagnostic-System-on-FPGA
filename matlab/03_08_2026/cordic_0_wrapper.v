`timescale 1ns / 1ps

module cordic_0_wrapper (
    input wire          clk,
    input wire          ce,
    input wire          s_axis_data_tvalid,
    input wire          s_axis_data_tlast,
    input wire [15:0]   s_axis_data_tdata_real,
    input wire [15:0]   s_axis_data_tdata_imag, 
    output wire         s_axis_data_tready,
    input wire          m_axis_data_tready,
    output wire         m_axis_data_tvalid,
    output wire         m_axis_data_tlast,
    output wire [31:0]  m_axis_data_tdata
);

    // Instancjacja Twojego wygenerowanego rdzenia IP (ta nazwa pozostaje bez zmian)
    cordic_0 my_cordic_core (
        .aclk(clk),
        
        .s_axis_cartesian_tvalid(s_axis_data_tvalid),
        .s_axis_cartesian_tready(s_axis_data_tready),
        .s_axis_cartesian_tlast(s_axis_data_tlast),
        .s_axis_cartesian_tdata({s_axis_data_tdata_imag,s_axis_data_tdata_real}),
        
        .m_axis_dout_tready(m_axis_data_tready),
        .m_axis_dout_tvalid(m_axis_data_tvalid),
        .m_axis_dout_tlast(m_axis_data_tlast),
        .m_axis_dout_tdata(m_axis_data_tdata)
    );

endmodule