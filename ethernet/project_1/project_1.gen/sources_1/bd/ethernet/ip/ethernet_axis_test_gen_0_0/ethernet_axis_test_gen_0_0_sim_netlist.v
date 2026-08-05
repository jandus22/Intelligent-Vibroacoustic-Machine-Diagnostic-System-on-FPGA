// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue Jul 28 08:21:09 2026
// Host        : Magisterka running 64-bit Ubuntu 26.04 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/project_1/project_1.gen/sources_1/bd/ethernet/ip/ethernet_axis_test_gen_0_0/ethernet_axis_test_gen_0_0_sim_netlist.v
// Design      : ethernet_axis_test_gen_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xck26-sfvc784-2LV-c
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ethernet_axis_test_gen_0_0,axis_test_gen,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "axis_test_gen,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module ethernet_axis_test_gen_0_0
   (clk,
    rstn,
    m_axis_tdata,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF m_axis, ASSOCIATED_RESET rstn, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN ethernet_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rstn RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rstn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rstn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 99999001, PHASE 0.0, CLK_DOMAIN ethernet_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0" *) output [31:0]m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *) output m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *) input m_axis_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *) output m_axis_tlast;

  wire \<const0> ;
  wire clk;
  wire [31:0]\^m_axis_tdata ;
  wire m_axis_tlast;
  wire m_axis_tready;
  wire rstn;

  assign m_axis_tdata[31:28] = \^m_axis_tdata [31:28];
  assign m_axis_tdata[27] = \<const0> ;
  assign m_axis_tdata[26] = \^m_axis_tdata [31];
  assign m_axis_tdata[25] = \<const0> ;
  assign m_axis_tdata[24] = \^m_axis_tdata [31];
  assign m_axis_tdata[23] = \<const0> ;
  assign m_axis_tdata[22] = \<const0> ;
  assign m_axis_tdata[21] = \<const0> ;
  assign m_axis_tdata[20] = \<const0> ;
  assign m_axis_tdata[19] = \<const0> ;
  assign m_axis_tdata[18] = \<const0> ;
  assign m_axis_tdata[17] = \<const0> ;
  assign m_axis_tdata[16] = \<const0> ;
  assign m_axis_tdata[15] = \<const0> ;
  assign m_axis_tdata[14] = \<const0> ;
  assign m_axis_tdata[13] = \<const0> ;
  assign m_axis_tdata[12] = \<const0> ;
  assign m_axis_tdata[11:0] = \^m_axis_tdata [11:0];
  assign m_axis_tvalid = rstn;
  GND GND
       (.G(\<const0> ));
  ethernet_axis_test_gen_0_0_axis_test_gen inst
       (.Q({\^m_axis_tdata [30],\^m_axis_tdata [28]}),
        .clk(clk),
        .m_axis_tdata({\^m_axis_tdata [31],\^m_axis_tdata [29],\^m_axis_tdata [11:0]}),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .rstn(rstn));
endmodule

(* ORIG_REF_NAME = "axis_test_gen" *) 
module ethernet_axis_test_gen_0_0_axis_test_gen
   (Q,
    m_axis_tlast,
    m_axis_tdata,
    clk,
    rstn,
    m_axis_tready);
  output [1:0]Q;
  output m_axis_tlast;
  output [13:0]m_axis_tdata;
  input clk;
  input rstn;
  input m_axis_tready;

  wire \FSM_onehot_state[2]_i_1_n_0 ;
  wire \FSM_onehot_state[2]_i_2_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire [1:0]Q;
  wire clk;
  wire [13:0]m_axis_tdata;
  wire m_axis_tlast;
  wire m_axis_tlast_INST_0_i_1_n_0;
  wire m_axis_tlast_INST_0_i_2_n_0;
  wire m_axis_tready;
  wire rstn;
  wire [11:0]sample_cnt;
  wire \sample_cnt[11]_i_1_n_0 ;
  wire \sample_cnt[11]_i_2_n_0 ;
  wire \sample_cnt[11]_i_3_n_0 ;
  wire \sample_cnt[1]_i_1_n_0 ;
  wire \sample_cnt[3]_i_1_n_0 ;
  wire \sample_cnt[6]_i_1_n_0 ;
  wire \sample_cnt[6]_i_2_n_0 ;
  wire [10:0]sample_cnt__0;

  LUT1 #(
    .INIT(2'h1)) 
    \FSM_onehot_state[2]_i_1 
       (.I0(rstn),
        .O(\FSM_onehot_state[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hAAAAAAA8)) 
    \FSM_onehot_state[2]_i_2 
       (.I0(m_axis_tready),
        .I1(m_axis_tlast),
        .I2(Q[1]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .I4(Q[0]),
        .O(\FSM_onehot_state[2]_i_2_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk),
        .CE(\FSM_onehot_state[2]_i_2_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[3] ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(\FSM_onehot_state[2]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk),
        .CE(\FSM_onehot_state[2]_i_2_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[0] ),
        .Q(Q[0]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk),
        .CE(\FSM_onehot_state[2]_i_2_n_0 ),
        .D(Q[0]),
        .Q(Q[1]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk),
        .CE(\FSM_onehot_state[2]_i_2_n_0 ),
        .D(Q[1]),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[0]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[0]),
        .O(m_axis_tdata[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[10]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[10]),
        .O(m_axis_tdata[10]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[11]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[11]),
        .O(m_axis_tdata[11]));
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[1]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[1]),
        .O(m_axis_tdata[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \m_axis_tdata[24]_INST_0 
       (.I0(Q[0]),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(Q[1]),
        .O(m_axis_tdata[13]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \m_axis_tdata[29]_INST_0 
       (.I0(Q[0]),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata[12]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[2]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[2]),
        .O(m_axis_tdata[2]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[3]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[3]),
        .O(m_axis_tdata[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[4]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[4]),
        .O(m_axis_tdata[4]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[5]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[5]),
        .O(m_axis_tdata[5]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[6]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[6]),
        .O(m_axis_tdata[6]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[7]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[7]),
        .O(m_axis_tdata[7]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[8]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[8]),
        .O(m_axis_tdata[8]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[9]_INST_0 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[9]),
        .O(m_axis_tdata[9]));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    m_axis_tlast_INST_0
       (.I0(sample_cnt[7]),
        .I1(sample_cnt[6]),
        .I2(m_axis_tlast_INST_0_i_1_n_0),
        .I3(sample_cnt[8]),
        .I4(sample_cnt[9]),
        .I5(m_axis_tlast_INST_0_i_2_n_0),
        .O(m_axis_tlast));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    m_axis_tlast_INST_0_i_1
       (.I0(sample_cnt[1]),
        .I1(sample_cnt[0]),
        .I2(sample_cnt[2]),
        .I3(sample_cnt[5]),
        .I4(sample_cnt[4]),
        .I5(sample_cnt[3]),
        .O(m_axis_tlast_INST_0_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    m_axis_tlast_INST_0_i_2
       (.I0(sample_cnt[11]),
        .I1(sample_cnt[10]),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .O(m_axis_tlast_INST_0_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \sample_cnt[0]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[0]),
        .O(sample_cnt__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \sample_cnt[10]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(\sample_cnt[11]_i_3_n_0 ),
        .I2(sample_cnt[10]),
        .O(sample_cnt__0[10]));
  LUT3 #(
    .INIT(8'hA8)) 
    \sample_cnt[11]_i_1 
       (.I0(m_axis_tready),
        .I1(Q[1]),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h7800)) 
    \sample_cnt[11]_i_2 
       (.I0(\sample_cnt[11]_i_3_n_0 ),
        .I1(sample_cnt[10]),
        .I2(sample_cnt[11]),
        .I3(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[11]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h80000000)) 
    \sample_cnt[11]_i_3 
       (.I0(sample_cnt[9]),
        .I1(sample_cnt[8]),
        .I2(m_axis_tlast_INST_0_i_1_n_0),
        .I3(sample_cnt[6]),
        .I4(sample_cnt[7]),
        .O(\sample_cnt[11]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \sample_cnt[1]_i_1 
       (.I0(sample_cnt[0]),
        .I1(sample_cnt[1]),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \sample_cnt[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[1]),
        .I2(sample_cnt[0]),
        .I3(sample_cnt[2]),
        .O(sample_cnt__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7F800000)) 
    \sample_cnt[3]_i_1 
       (.I0(sample_cnt[2]),
        .I1(sample_cnt[0]),
        .I2(sample_cnt[1]),
        .I3(sample_cnt[3]),
        .I4(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \sample_cnt[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[3]),
        .I2(sample_cnt[1]),
        .I3(sample_cnt[0]),
        .I4(sample_cnt[2]),
        .I5(sample_cnt[4]),
        .O(sample_cnt__0[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h2AAA8000)) 
    \sample_cnt[5]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[4]),
        .I2(\sample_cnt[6]_i_2_n_0 ),
        .I3(sample_cnt[3]),
        .I4(sample_cnt[5]),
        .O(sample_cnt__0[5]));
  LUT6 #(
    .INIT(64'h7FFF800000000000)) 
    \sample_cnt[6]_i_1 
       (.I0(\sample_cnt[6]_i_2_n_0 ),
        .I1(sample_cnt[5]),
        .I2(sample_cnt[4]),
        .I3(sample_cnt[3]),
        .I4(sample_cnt[6]),
        .I5(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \sample_cnt[6]_i_2 
       (.I0(sample_cnt[2]),
        .I1(sample_cnt[0]),
        .I2(sample_cnt[1]),
        .O(\sample_cnt[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \sample_cnt[7]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[6]),
        .I2(m_axis_tlast_INST_0_i_1_n_0),
        .I3(sample_cnt[7]),
        .O(sample_cnt__0[7]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h2AAA8000)) 
    \sample_cnt[8]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(m_axis_tlast_INST_0_i_1_n_0),
        .I2(sample_cnt[6]),
        .I3(sample_cnt[7]),
        .I4(sample_cnt[8]),
        .O(sample_cnt__0[8]));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \sample_cnt[9]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[7]),
        .I2(sample_cnt[6]),
        .I3(m_axis_tlast_INST_0_i_1_n_0),
        .I4(sample_cnt[8]),
        .I5(sample_cnt[9]),
        .O(sample_cnt__0[9]));
  FDRE \sample_cnt_reg[0] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[0]),
        .Q(sample_cnt[0]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[10] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[10]),
        .Q(sample_cnt[10]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[11] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(\sample_cnt[11]_i_2_n_0 ),
        .Q(sample_cnt[11]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[1] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(\sample_cnt[1]_i_1_n_0 ),
        .Q(sample_cnt[1]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[2] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[2]),
        .Q(sample_cnt[2]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[3] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(\sample_cnt[3]_i_1_n_0 ),
        .Q(sample_cnt[3]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[4] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[4]),
        .Q(sample_cnt[4]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[5] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[5]),
        .Q(sample_cnt[5]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[6] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(\sample_cnt[6]_i_1_n_0 ),
        .Q(sample_cnt[6]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[7] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[7]),
        .Q(sample_cnt[7]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[8] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[8]),
        .Q(sample_cnt[8]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
  FDRE \sample_cnt_reg[9] 
       (.C(clk),
        .CE(\sample_cnt[11]_i_1_n_0 ),
        .D(sample_cnt__0[9]),
        .Q(sample_cnt[9]),
        .R(\FSM_onehot_state[2]_i_1_n_0 ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
