//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
//Date        : Sun Feb  8 14:59:50 2026
//Host        : qtaz running 64-bit Ubuntu 24.04.3 LTS
//Command     : generate_target spi_module_wrapper.bd
//Design      : spi_module_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module spi_module_wrapper
   (som240_1_connector_gem2_led_tri_o,
    som240_1_connector_hpa_clk0p_clk,
    som240_1_connector_pmod1_spi_io0_io,
    som240_1_connector_pmod1_spi_io1_io,
    som240_1_connector_pmod1_spi_ss_io);
  output [2:0]som240_1_connector_gem2_led_tri_o;
  input som240_1_connector_hpa_clk0p_clk;
  inout som240_1_connector_pmod1_spi_io0_io;
  inout som240_1_connector_pmod1_spi_io1_io;
  inout som240_1_connector_pmod1_spi_ss_io;

  wire [2:0]som240_1_connector_gem2_led_tri_o;
  wire som240_1_connector_hpa_clk0p_clk;
  wire som240_1_connector_pmod1_spi_io0_i;
  wire som240_1_connector_pmod1_spi_io0_io;
  wire som240_1_connector_pmod1_spi_io0_o;
  wire som240_1_connector_pmod1_spi_io0_t;
  wire som240_1_connector_pmod1_spi_io1_i;
  wire som240_1_connector_pmod1_spi_io1_io;
  wire som240_1_connector_pmod1_spi_io1_o;
  wire som240_1_connector_pmod1_spi_io1_t;
  wire som240_1_connector_pmod1_spi_ss_i;
  wire som240_1_connector_pmod1_spi_ss_io;
  wire som240_1_connector_pmod1_spi_ss_o;
  wire som240_1_connector_pmod1_spi_ss_t;

  IOBUF som240_1_connector_pmod1_spi_io0_iobuf
       (.I(som240_1_connector_pmod1_spi_io0_o),
        .IO(som240_1_connector_pmod1_spi_io0_io),
        .O(som240_1_connector_pmod1_spi_io0_i),
        .T(som240_1_connector_pmod1_spi_io0_t));
  IOBUF som240_1_connector_pmod1_spi_io1_iobuf
       (.I(som240_1_connector_pmod1_spi_io1_o),
        .IO(som240_1_connector_pmod1_spi_io1_io),
        .O(som240_1_connector_pmod1_spi_io1_i),
        .T(som240_1_connector_pmod1_spi_io1_t));
  IOBUF som240_1_connector_pmod1_spi_ss_iobuf
       (.I(som240_1_connector_pmod1_spi_ss_o),
        .IO(som240_1_connector_pmod1_spi_ss_io),
        .O(som240_1_connector_pmod1_spi_ss_i),
        .T(som240_1_connector_pmod1_spi_ss_t));
  spi_module spi_module_i
       (.som240_1_connector_gem2_led_tri_o(som240_1_connector_gem2_led_tri_o),
        .som240_1_connector_hpa_clk0p_clk(som240_1_connector_hpa_clk0p_clk),
        .som240_1_connector_pmod1_spi_io0_i(som240_1_connector_pmod1_spi_io0_i),
        .som240_1_connector_pmod1_spi_io0_o(som240_1_connector_pmod1_spi_io0_o),
        .som240_1_connector_pmod1_spi_io0_t(som240_1_connector_pmod1_spi_io0_t),
        .som240_1_connector_pmod1_spi_io1_i(som240_1_connector_pmod1_spi_io1_i),
        .som240_1_connector_pmod1_spi_io1_o(som240_1_connector_pmod1_spi_io1_o),
        .som240_1_connector_pmod1_spi_io1_t(som240_1_connector_pmod1_spi_io1_t),
        .som240_1_connector_pmod1_spi_ss_i(som240_1_connector_pmod1_spi_ss_i),
        .som240_1_connector_pmod1_spi_ss_o(som240_1_connector_pmod1_spi_ss_o),
        .som240_1_connector_pmod1_spi_ss_t(som240_1_connector_pmod1_spi_ss_t));
endmodule
