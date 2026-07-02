//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
//Date        : Wed Apr  8 01:37:39 2026
//Host        : qtaz running 64-bit Ubuntu 24.04.4 LTS
//Command     : generate_target Hilbert_fft_wrapper.bd
//Design      : Hilbert_fft_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Hilbert_fft_wrapper
   (aresetn,
    clk_100MHz,
    fft_x_out,
    fft_y_out,
    fft_z_out,
    s_axis_data_tdata,
    s_axis_data_tlast,
    s_axis_data_tready,
    s_axis_data_tvalid);
  input aresetn;
  input clk_100MHz;
  output [31:0]fft_x_out;
  output [31:0]fft_y_out;
  output [31:0]fft_z_out;
  input [15:0]s_axis_data_tdata;
  input s_axis_data_tlast;
  output s_axis_data_tready;
  input s_axis_data_tvalid;

  wire aresetn;
  wire clk_100MHz;
  wire [31:0]fft_x_out;
  wire [31:0]fft_y_out;
  wire [31:0]fft_z_out;
  wire [15:0]s_axis_data_tdata;
  wire s_axis_data_tlast;
  wire s_axis_data_tready;
  wire s_axis_data_tvalid;

  Hilbert_fft Hilbert_fft_i
       (.aresetn(aresetn),
        .clk_100MHz(clk_100MHz),
        .fft_x_out(fft_x_out),
        .fft_y_out(fft_y_out),
        .fft_z_out(fft_z_out),
        .s_axis_data_tdata(s_axis_data_tdata),
        .s_axis_data_tlast(s_axis_data_tlast),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tvalid(s_axis_data_tvalid));
endmodule
