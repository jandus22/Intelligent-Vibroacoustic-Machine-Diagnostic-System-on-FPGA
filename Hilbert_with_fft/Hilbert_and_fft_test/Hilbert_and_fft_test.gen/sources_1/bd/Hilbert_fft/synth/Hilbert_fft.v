//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
//Date        : Wed Jul  8 19:25:07 2026
//Host        : qtaz running 64-bit Ubuntu 24.04.4 LTS
//Command     : generate_target Hilbert_fft.bd
//Design      : Hilbert_fft
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "Hilbert_fft,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=Hilbert_fft,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=18,numReposBlks=18,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=5,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "Hilbert_fft.hwdef" *) 
module Hilbert_fft
   (aresetn,
    clk_100MHz,
    fft_x_out,
    fft_y_out,
    fft_z_out,
    s_axis_data_tdata,
    s_axis_data_tlast,
    s_axis_data_tready,
    s_axis_data_tvalid);
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.ARESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, ASSOCIATED_RESET aresetn, CLK_DOMAIN Hilbert_fft_clk_100MHz, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_100MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.FFT_X_OUT DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.FFT_X_OUT, LAYERED_METADATA undef" *) output [31:0]fft_x_out;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.FFT_Y_OUT DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.FFT_Y_OUT, LAYERED_METADATA undef" *) output [31:0]fft_y_out;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.FFT_Z_OUT DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.FFT_Z_OUT, LAYERED_METADATA undef" *) output [31:0]fft_z_out;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.S_AXIS_DATA_TDATA DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.S_AXIS_DATA_TDATA, LAYERED_METADATA undef" *) input [15:0]s_axis_data_tdata;
  input s_axis_data_tlast;
  output s_axis_data_tready;
  input s_axis_data_tvalid;

  wire [95:0]TDM_to_Parallel_Conv_0_m_axis_TDATA;
  wire TDM_to_Parallel_Conv_0_m_axis_TLAST;
  wire TDM_to_Parallel_Conv_0_m_axis_TREADY;
  wire TDM_to_Parallel_Conv_0_m_axis_TVALID;
  wire aresetn;
  wire [15:0]axis_subset_converter_1_M_AXIS_TDATA;
  wire brancher_0_m_axis_tvalid;
  wire [31:0]brancher_0_x_out;
  wire [31:0]brancher_0_y_out;
  wire [31:0]brancher_0_z_out;
  wire clk_100MHz;
  wire [31:0]fft_x_out;
  wire [31:0]fft_y_out;
  wire [31:0]fft_z_out;
  wire [39:0]fir_compiler_0_M_AXIS_DATA_TDATA;
  wire fir_compiler_0_m_axis_data_tlast;
  wire fir_compiler_0_m_axis_data_tvalid;
  wire [31:0]fir_compiler_1_m_axis_data_tdata;
  wire fir_compiler_1_m_axis_data_tlast;
  wire fir_compiler_1_m_axis_data_tvalid;
  wire fir_compiler_1_s_axis_data_tready;
  wire [15:0]imag_Dout;
  wire [15:0]rel_Dout;
  wire [15:0]s_axis_data_tdata;
  wire s_axis_data_tlast;
  wire s_axis_data_tready;
  wire s_axis_data_tvalid;
  wire [95:0]xfft_0_m_axis_data_tdata;
  wire xfft_0_m_axis_data_tvalid;
  wire [71:0]xlconstant_0_dout;
  wire [0:0]xlconstant_1_dout;

  Hilbert_fft_TDM_to_Parallel_Conv_0_0 TDM_to_Parallel_Conv_0
       (.clk(clk_100MHz),
        .m_axis_tdata(TDM_to_Parallel_Conv_0_m_axis_TDATA),
        .m_axis_tlast(TDM_to_Parallel_Conv_0_m_axis_TLAST),
        .m_axis_tready(TDM_to_Parallel_Conv_0_m_axis_TREADY),
        .m_axis_tvalid(TDM_to_Parallel_Conv_0_m_axis_TVALID),
        .rst_n(aresetn),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tlast(1'b0),
        .s_axis_tvalid(1'b0));
  Hilbert_fft_axis_subset_converter_0_0 axis_subset_converter_0
       (.aclk(clk_100MHz),
        .aresetn(aresetn),
        .m_axis_tready(1'b1),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tlast(1'b0),
        .s_axis_tvalid(1'b0));
  Hilbert_fft_axis_subset_converter_1_0 axis_subset_converter_1
       (.aclk(clk_100MHz),
        .aresetn(aresetn),
        .m_axis_tdata(axis_subset_converter_1_M_AXIS_TDATA),
        .m_axis_tready(1'b1),
        .s_axis_tdata(fir_compiler_0_M_AXIS_DATA_TDATA),
        .s_axis_tlast(1'b0),
        .s_axis_tvalid(1'b0));
  Hilbert_fft_brancher_0_0 brancher_0
       (.clk(clk_100MHz),
        .m_axis_tvalid(brancher_0_m_axis_tvalid),
        .rst_n(aresetn),
        .s_axis_tdata(xfft_0_m_axis_data_tdata),
        .s_axis_tvalid(xfft_0_m_axis_data_tvalid),
        .x_out(brancher_0_x_out),
        .y_out(brancher_0_y_out),
        .z_out(brancher_0_z_out));
  Hilbert_fft_cordic_0_0 cordic_0
       (.aclk(clk_100MHz),
        .s_axis_cartesian_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_cartesian_tlast(1'b0),
        .s_axis_cartesian_tvalid(1'b0));
  Hilbert_fft_cordic_1_3 cordic_1
       (.aclk(clk_100MHz),
        .m_axis_dout_tdata(fft_x_out),
        .s_axis_cartesian_tdata(brancher_0_x_out),
        .s_axis_cartesian_tvalid(brancher_0_m_axis_tvalid));
  Hilbert_fft_cordic_1_4 cordic_2
       (.aclk(clk_100MHz),
        .m_axis_dout_tdata(fft_y_out),
        .s_axis_cartesian_tdata(brancher_0_y_out),
        .s_axis_cartesian_tvalid(brancher_0_m_axis_tvalid));
  Hilbert_fft_cordic_1_5 cordic_3
       (.aclk(clk_100MHz),
        .m_axis_dout_tdata(fft_z_out),
        .s_axis_cartesian_tdata(brancher_0_z_out),
        .s_axis_cartesian_tvalid(brancher_0_m_axis_tvalid));
  Hilbert_fft_fir0_spy_0_2 fir0_spy_1
       (.aclk(clk_100MHz),
        .aresetn(aresetn),
        .s_axis_tdata(s_axis_data_tdata),
        .s_axis_tlast(s_axis_data_tlast),
        .s_axis_tready(s_axis_data_tready),
        .s_axis_tvalid(s_axis_data_tvalid));
  Hilbert_fft_fir0_spy_1_0 fir0_spy_2
       (.aclk(clk_100MHz),
        .aresetn(aresetn),
        .s_axis_tdata(imag_Dout),
        .s_axis_tlast(fir_compiler_1_m_axis_data_tlast),
        .s_axis_tready(fir_compiler_1_s_axis_data_tready),
        .s_axis_tvalid(fir_compiler_1_m_axis_data_tvalid));
  Hilbert_fft_fir0_spy_1_1 fir0_spy_3
       (.aclk(clk_100MHz),
        .aresetn(aresetn),
        .s_axis_tdata(rel_Dout),
        .s_axis_tlast(fir_compiler_1_m_axis_data_tlast),
        .s_axis_tready(fir_compiler_1_s_axis_data_tready),
        .s_axis_tvalid(fir_compiler_1_m_axis_data_tvalid));
  Hilbert_fft_fir_compiler_0_0 fir_compiler_0
       (.aclk(clk_100MHz),
        .m_axis_data_tdata(fir_compiler_0_M_AXIS_DATA_TDATA),
        .m_axis_data_tlast(fir_compiler_0_m_axis_data_tlast),
        .m_axis_data_tready(fir_compiler_1_s_axis_data_tready),
        .m_axis_data_tvalid(fir_compiler_0_m_axis_data_tvalid),
        .s_axis_data_tdata(s_axis_data_tdata),
        .s_axis_data_tlast(s_axis_data_tlast),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tvalid(s_axis_data_tvalid));
  Hilbert_fft_fir_compiler_1_0 fir_compiler_1
       (.aclk(clk_100MHz),
        .m_axis_data_tdata(fir_compiler_1_m_axis_data_tdata),
        .m_axis_data_tlast(fir_compiler_1_m_axis_data_tlast),
        .m_axis_data_tready(1'b1),
        .m_axis_data_tvalid(fir_compiler_1_m_axis_data_tvalid),
        .s_axis_data_tdata(axis_subset_converter_1_M_AXIS_TDATA),
        .s_axis_data_tlast(fir_compiler_0_m_axis_data_tlast),
        .s_axis_data_tready(fir_compiler_1_s_axis_data_tready),
        .s_axis_data_tvalid(fir_compiler_0_m_axis_data_tvalid));
  Hilbert_fft_xlslice_1_0 imag
       (.Din(fir_compiler_1_m_axis_data_tdata),
        .Dout(imag_Dout));
  Hilbert_fft_xlslice_1_1 rel
       (.Din(fir_compiler_1_m_axis_data_tdata),
        .Dout(rel_Dout));
  Hilbert_fft_xfft_0_0 xfft_0
       (.aclk(clk_100MHz),
        .m_axis_data_tdata(xfft_0_m_axis_data_tdata),
        .m_axis_data_tready(1'b1),
        .m_axis_data_tvalid(xfft_0_m_axis_data_tvalid),
        .s_axis_config_tdata(xlconstant_0_dout),
        .s_axis_config_tvalid(xlconstant_1_dout),
        .s_axis_data_tdata(TDM_to_Parallel_Conv_0_m_axis_TDATA),
        .s_axis_data_tlast(TDM_to_Parallel_Conv_0_m_axis_TLAST),
        .s_axis_data_tready(TDM_to_Parallel_Conv_0_m_axis_TREADY),
        .s_axis_data_tvalid(TDM_to_Parallel_Conv_0_m_axis_TVALID));
  Hilbert_fft_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  Hilbert_fft_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
endmodule
