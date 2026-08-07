//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
//Date        : Fri Aug  7 08:40:51 2026
//Host        : Magisterka running 64-bit Ubuntu 26.04 LTS
//Command     : generate_target dma_system_wrapper.bd
//Design      : dma_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module dma_system_wrapper
   (sensor_axis_aclk,
    sensor_axis_aresetn,
    sensor_axis_tdata,
    sensor_axis_tkeep,
    sensor_axis_tlast,
    sensor_axis_tready,
    sensor_axis_tvalid);
  input sensor_axis_aclk;
  input sensor_axis_aresetn;
  input [15:0]sensor_axis_tdata;
  input [1:0]sensor_axis_tkeep;
  input sensor_axis_tlast;
  output sensor_axis_tready;
  input sensor_axis_tvalid;

  wire sensor_axis_aclk;
  wire sensor_axis_aresetn;
  wire [15:0]sensor_axis_tdata;
  wire [1:0]sensor_axis_tkeep;
  wire sensor_axis_tlast;
  wire sensor_axis_tready;
  wire sensor_axis_tvalid;

  dma_system dma_system_i
       (.sensor_axis_aclk(sensor_axis_aclk),
        .sensor_axis_aresetn(sensor_axis_aresetn),
        .sensor_axis_tdata(sensor_axis_tdata),
        .sensor_axis_tkeep(sensor_axis_tkeep),
        .sensor_axis_tlast(sensor_axis_tlast),
        .sensor_axis_tready(sensor_axis_tready),
        .sensor_axis_tvalid(sensor_axis_tvalid));
endmodule
