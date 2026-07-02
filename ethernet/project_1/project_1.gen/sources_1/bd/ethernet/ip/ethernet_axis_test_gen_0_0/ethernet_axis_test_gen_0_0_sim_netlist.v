// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue Mar 24 16:34:17 2026
// Host        : DESKTOP-1D7OT4F running 64-bit Ubuntu 22.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/janecki/magister/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/project_1/project_1.gen/sources_1/bd/ethernet/ip/ethernet_axis_test_gen_0_0/ethernet_axis_test_gen_0_0_sim_netlist.v
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

  wire clk;
  wire [31:0]m_axis_tdata;
  wire m_axis_tlast;
  wire m_axis_tready;
  wire m_axis_tvalid;
  wire rstn;

  ethernet_axis_test_gen_0_0_axis_test_gen inst
       (.clk(clk),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .m_axis_tvalid(m_axis_tvalid),
        .rstn(rstn));
endmodule

(* ORIG_REF_NAME = "axis_test_gen" *) 
module ethernet_axis_test_gen_0_0_axis_test_gen
   (m_axis_tvalid,
    m_axis_tdata,
    m_axis_tlast,
    rstn,
    clk,
    m_axis_tready);
  output m_axis_tvalid;
  output [31:0]m_axis_tdata;
  output m_axis_tlast;
  input rstn;
  input clk;
  input m_axis_tready;

  wire \FSM_onehot_state[3]_i_1_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[1] ;
  wire \FSM_onehot_state_reg_n_0_[2] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire clk;
  wire \frame_id[0]_i_1_n_0 ;
  wire \frame_id[0]_i_3_n_0 ;
  wire \frame_id[0]_i_4_n_0 ;
  wire \frame_id[0]_i_5_n_0 ;
  wire [31:0]frame_id_reg;
  wire \frame_id_reg[0]_i_2_n_0 ;
  wire \frame_id_reg[0]_i_2_n_1 ;
  wire \frame_id_reg[0]_i_2_n_10 ;
  wire \frame_id_reg[0]_i_2_n_11 ;
  wire \frame_id_reg[0]_i_2_n_12 ;
  wire \frame_id_reg[0]_i_2_n_13 ;
  wire \frame_id_reg[0]_i_2_n_14 ;
  wire \frame_id_reg[0]_i_2_n_15 ;
  wire \frame_id_reg[0]_i_2_n_2 ;
  wire \frame_id_reg[0]_i_2_n_3 ;
  wire \frame_id_reg[0]_i_2_n_4 ;
  wire \frame_id_reg[0]_i_2_n_5 ;
  wire \frame_id_reg[0]_i_2_n_6 ;
  wire \frame_id_reg[0]_i_2_n_7 ;
  wire \frame_id_reg[0]_i_2_n_8 ;
  wire \frame_id_reg[0]_i_2_n_9 ;
  wire \frame_id_reg[16]_i_1_n_0 ;
  wire \frame_id_reg[16]_i_1_n_1 ;
  wire \frame_id_reg[16]_i_1_n_10 ;
  wire \frame_id_reg[16]_i_1_n_11 ;
  wire \frame_id_reg[16]_i_1_n_12 ;
  wire \frame_id_reg[16]_i_1_n_13 ;
  wire \frame_id_reg[16]_i_1_n_14 ;
  wire \frame_id_reg[16]_i_1_n_15 ;
  wire \frame_id_reg[16]_i_1_n_2 ;
  wire \frame_id_reg[16]_i_1_n_3 ;
  wire \frame_id_reg[16]_i_1_n_4 ;
  wire \frame_id_reg[16]_i_1_n_5 ;
  wire \frame_id_reg[16]_i_1_n_6 ;
  wire \frame_id_reg[16]_i_1_n_7 ;
  wire \frame_id_reg[16]_i_1_n_8 ;
  wire \frame_id_reg[16]_i_1_n_9 ;
  wire \frame_id_reg[24]_i_1_n_1 ;
  wire \frame_id_reg[24]_i_1_n_10 ;
  wire \frame_id_reg[24]_i_1_n_11 ;
  wire \frame_id_reg[24]_i_1_n_12 ;
  wire \frame_id_reg[24]_i_1_n_13 ;
  wire \frame_id_reg[24]_i_1_n_14 ;
  wire \frame_id_reg[24]_i_1_n_15 ;
  wire \frame_id_reg[24]_i_1_n_2 ;
  wire \frame_id_reg[24]_i_1_n_3 ;
  wire \frame_id_reg[24]_i_1_n_4 ;
  wire \frame_id_reg[24]_i_1_n_5 ;
  wire \frame_id_reg[24]_i_1_n_6 ;
  wire \frame_id_reg[24]_i_1_n_7 ;
  wire \frame_id_reg[24]_i_1_n_8 ;
  wire \frame_id_reg[24]_i_1_n_9 ;
  wire \frame_id_reg[8]_i_1_n_0 ;
  wire \frame_id_reg[8]_i_1_n_1 ;
  wire \frame_id_reg[8]_i_1_n_10 ;
  wire \frame_id_reg[8]_i_1_n_11 ;
  wire \frame_id_reg[8]_i_1_n_12 ;
  wire \frame_id_reg[8]_i_1_n_13 ;
  wire \frame_id_reg[8]_i_1_n_14 ;
  wire \frame_id_reg[8]_i_1_n_15 ;
  wire \frame_id_reg[8]_i_1_n_2 ;
  wire \frame_id_reg[8]_i_1_n_3 ;
  wire \frame_id_reg[8]_i_1_n_4 ;
  wire \frame_id_reg[8]_i_1_n_5 ;
  wire \frame_id_reg[8]_i_1_n_6 ;
  wire \frame_id_reg[8]_i_1_n_7 ;
  wire \frame_id_reg[8]_i_1_n_8 ;
  wire \frame_id_reg[8]_i_1_n_9 ;
  wire [31:0]m_axis_tdata;
  wire \m_axis_tdata[31]_i_1_n_0 ;
  wire \m_axis_tdata[31]_i_2_n_0 ;
  wire [31:0]m_axis_tdata_1;
  wire m_axis_tlast;
  wire m_axis_tlast_i_1_n_0;
  wire m_axis_tready;
  wire m_axis_tvalid;
  wire rstn;
  wire [9:0]sample_cnt;
  wire \sample_cnt[1]_i_1_n_0 ;
  wire \sample_cnt[8]_i_2_n_0 ;
  wire \sample_cnt[9]_i_1_n_0 ;
  wire \sample_cnt[9]_i_2_n_0 ;
  wire \sample_cnt[9]_i_3_n_0 ;
  wire [8:0]sample_cnt_0;
  wire [7:7]\NLW_frame_id_reg[24]_i_1_CO_UNCONNECTED ;

  LUT6 #(
    .INIT(64'hFFFEAAAAAAAAAAAA)) 
    \FSM_onehot_state[3]_i_1 
       (.I0(\frame_id[0]_i_1_n_0 ),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .I3(\FSM_onehot_state_reg_n_0_[2] ),
        .I4(m_axis_tready),
        .I5(m_axis_tvalid),
        .O(\FSM_onehot_state[3]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk),
        .CE(\FSM_onehot_state[3]_i_1_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[3] ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(\m_axis_tdata[31]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk),
        .CE(\FSM_onehot_state[3]_i_1_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[0] ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk),
        .CE(\FSM_onehot_state[3]_i_1_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[1] ),
        .Q(\FSM_onehot_state_reg_n_0_[2] ),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk),
        .CE(\FSM_onehot_state[3]_i_1_n_0 ),
        .D(\FSM_onehot_state_reg_n_0_[2] ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \frame_id[0]_i_1 
       (.I0(\sample_cnt[8]_i_2_n_0 ),
        .I1(\frame_id[0]_i_3_n_0 ),
        .I2(sample_cnt[7]),
        .I3(sample_cnt[8]),
        .I4(sample_cnt[9]),
        .I5(\frame_id[0]_i_4_n_0 ),
        .O(\frame_id[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \frame_id[0]_i_3 
       (.I0(sample_cnt[5]),
        .I1(sample_cnt[6]),
        .O(\frame_id[0]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \frame_id[0]_i_4 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(m_axis_tvalid),
        .I2(m_axis_tready),
        .O(\frame_id[0]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \frame_id[0]_i_5 
       (.I0(frame_id_reg[0]),
        .O(\frame_id[0]_i_5_n_0 ));
  FDRE \frame_id_reg[0] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_15 ),
        .Q(frame_id_reg[0]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 \frame_id_reg[0]_i_2 
       (.CI(1'b0),
        .CI_TOP(1'b0),
        .CO({\frame_id_reg[0]_i_2_n_0 ,\frame_id_reg[0]_i_2_n_1 ,\frame_id_reg[0]_i_2_n_2 ,\frame_id_reg[0]_i_2_n_3 ,\frame_id_reg[0]_i_2_n_4 ,\frame_id_reg[0]_i_2_n_5 ,\frame_id_reg[0]_i_2_n_6 ,\frame_id_reg[0]_i_2_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1}),
        .O({\frame_id_reg[0]_i_2_n_8 ,\frame_id_reg[0]_i_2_n_9 ,\frame_id_reg[0]_i_2_n_10 ,\frame_id_reg[0]_i_2_n_11 ,\frame_id_reg[0]_i_2_n_12 ,\frame_id_reg[0]_i_2_n_13 ,\frame_id_reg[0]_i_2_n_14 ,\frame_id_reg[0]_i_2_n_15 }),
        .S({frame_id_reg[7:1],\frame_id[0]_i_5_n_0 }));
  FDRE \frame_id_reg[10] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_13 ),
        .Q(frame_id_reg[10]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[11] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_12 ),
        .Q(frame_id_reg[11]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[12] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_11 ),
        .Q(frame_id_reg[12]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[13] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_10 ),
        .Q(frame_id_reg[13]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[14] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_9 ),
        .Q(frame_id_reg[14]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[15] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_8 ),
        .Q(frame_id_reg[15]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[16] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_15 ),
        .Q(frame_id_reg[16]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 \frame_id_reg[16]_i_1 
       (.CI(\frame_id_reg[8]_i_1_n_0 ),
        .CI_TOP(1'b0),
        .CO({\frame_id_reg[16]_i_1_n_0 ,\frame_id_reg[16]_i_1_n_1 ,\frame_id_reg[16]_i_1_n_2 ,\frame_id_reg[16]_i_1_n_3 ,\frame_id_reg[16]_i_1_n_4 ,\frame_id_reg[16]_i_1_n_5 ,\frame_id_reg[16]_i_1_n_6 ,\frame_id_reg[16]_i_1_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\frame_id_reg[16]_i_1_n_8 ,\frame_id_reg[16]_i_1_n_9 ,\frame_id_reg[16]_i_1_n_10 ,\frame_id_reg[16]_i_1_n_11 ,\frame_id_reg[16]_i_1_n_12 ,\frame_id_reg[16]_i_1_n_13 ,\frame_id_reg[16]_i_1_n_14 ,\frame_id_reg[16]_i_1_n_15 }),
        .S(frame_id_reg[23:16]));
  FDRE \frame_id_reg[17] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_14 ),
        .Q(frame_id_reg[17]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[18] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_13 ),
        .Q(frame_id_reg[18]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[19] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_12 ),
        .Q(frame_id_reg[19]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[1] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_14 ),
        .Q(frame_id_reg[1]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[20] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_11 ),
        .Q(frame_id_reg[20]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[21] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_10 ),
        .Q(frame_id_reg[21]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[22] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_9 ),
        .Q(frame_id_reg[22]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[23] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[16]_i_1_n_8 ),
        .Q(frame_id_reg[23]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[24] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_15 ),
        .Q(frame_id_reg[24]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 \frame_id_reg[24]_i_1 
       (.CI(\frame_id_reg[16]_i_1_n_0 ),
        .CI_TOP(1'b0),
        .CO({\NLW_frame_id_reg[24]_i_1_CO_UNCONNECTED [7],\frame_id_reg[24]_i_1_n_1 ,\frame_id_reg[24]_i_1_n_2 ,\frame_id_reg[24]_i_1_n_3 ,\frame_id_reg[24]_i_1_n_4 ,\frame_id_reg[24]_i_1_n_5 ,\frame_id_reg[24]_i_1_n_6 ,\frame_id_reg[24]_i_1_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\frame_id_reg[24]_i_1_n_8 ,\frame_id_reg[24]_i_1_n_9 ,\frame_id_reg[24]_i_1_n_10 ,\frame_id_reg[24]_i_1_n_11 ,\frame_id_reg[24]_i_1_n_12 ,\frame_id_reg[24]_i_1_n_13 ,\frame_id_reg[24]_i_1_n_14 ,\frame_id_reg[24]_i_1_n_15 }),
        .S(frame_id_reg[31:24]));
  FDRE \frame_id_reg[25] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_14 ),
        .Q(frame_id_reg[25]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[26] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_13 ),
        .Q(frame_id_reg[26]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[27] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_12 ),
        .Q(frame_id_reg[27]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[28] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_11 ),
        .Q(frame_id_reg[28]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[29] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_10 ),
        .Q(frame_id_reg[29]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[2] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_13 ),
        .Q(frame_id_reg[2]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[30] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_9 ),
        .Q(frame_id_reg[30]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[31] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[24]_i_1_n_8 ),
        .Q(frame_id_reg[31]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[3] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_12 ),
        .Q(frame_id_reg[3]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[4] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_11 ),
        .Q(frame_id_reg[4]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[5] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_10 ),
        .Q(frame_id_reg[5]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[6] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_9 ),
        .Q(frame_id_reg[6]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[7] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[0]_i_2_n_8 ),
        .Q(frame_id_reg[7]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \frame_id_reg[8] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_15 ),
        .Q(frame_id_reg[8]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 \frame_id_reg[8]_i_1 
       (.CI(\frame_id_reg[0]_i_2_n_0 ),
        .CI_TOP(1'b0),
        .CO({\frame_id_reg[8]_i_1_n_0 ,\frame_id_reg[8]_i_1_n_1 ,\frame_id_reg[8]_i_1_n_2 ,\frame_id_reg[8]_i_1_n_3 ,\frame_id_reg[8]_i_1_n_4 ,\frame_id_reg[8]_i_1_n_5 ,\frame_id_reg[8]_i_1_n_6 ,\frame_id_reg[8]_i_1_n_7 }),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({\frame_id_reg[8]_i_1_n_8 ,\frame_id_reg[8]_i_1_n_9 ,\frame_id_reg[8]_i_1_n_10 ,\frame_id_reg[8]_i_1_n_11 ,\frame_id_reg[8]_i_1_n_12 ,\frame_id_reg[8]_i_1_n_13 ,\frame_id_reg[8]_i_1_n_14 ,\frame_id_reg[8]_i_1_n_15 }),
        .S(frame_id_reg[15:8]));
  FDRE \frame_id_reg[9] 
       (.C(clk),
        .CE(\frame_id[0]_i_1_n_0 ),
        .D(\frame_id_reg[8]_i_1_n_14 ),
        .Q(frame_id_reg[9]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[0]_i_1 
       (.I0(sample_cnt[0]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .I3(frame_id_reg[0]),
        .O(m_axis_tdata_1[0]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[10]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[10]),
        .O(m_axis_tdata_1[10]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[11]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[11]),
        .O(m_axis_tdata_1[11]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[12]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[12]),
        .O(m_axis_tdata_1[12]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[13]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[13]),
        .O(m_axis_tdata_1[13]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[14]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[14]),
        .O(m_axis_tdata_1[14]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[15]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[15]),
        .O(m_axis_tdata_1[15]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[16]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[16]),
        .O(m_axis_tdata_1[16]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[17]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[17]),
        .O(m_axis_tdata_1[17]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[18]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[18]),
        .O(m_axis_tdata_1[18]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[19]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[19]),
        .O(m_axis_tdata_1[19]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[1]_i_1 
       (.I0(sample_cnt[1]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[1]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[1]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[20]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[20]),
        .O(m_axis_tdata_1[20]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[21]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[21]),
        .O(m_axis_tdata_1[21]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[22]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[22]),
        .O(m_axis_tdata_1[22]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[23]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[23]),
        .O(m_axis_tdata_1[23]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[24]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[24]),
        .O(m_axis_tdata_1[24]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[25]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[25]),
        .O(m_axis_tdata_1[25]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[26]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[26]),
        .O(m_axis_tdata_1[26]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[27]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[27]),
        .O(m_axis_tdata_1[27]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[28]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[28]),
        .O(m_axis_tdata_1[28]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[29]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[29]),
        .O(m_axis_tdata_1[29]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[2]_i_1 
       (.I0(sample_cnt[2]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[2]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[30]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[30]),
        .O(m_axis_tdata_1[30]));
  LUT1 #(
    .INIT(2'h1)) 
    \m_axis_tdata[31]_i_1 
       (.I0(rstn),
        .O(\m_axis_tdata[31]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[31]_i_2 
       (.I0(m_axis_tready),
        .I1(m_axis_tvalid),
        .O(\m_axis_tdata[31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \m_axis_tdata[31]_i_3 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(frame_id_reg[31]),
        .O(m_axis_tdata_1[31]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[3]_i_1 
       (.I0(sample_cnt[3]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[3]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[3]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[4]_i_1 
       (.I0(sample_cnt[4]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[4]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[4]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[5]_i_1 
       (.I0(sample_cnt[5]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[5]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[5]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[6]_i_1 
       (.I0(sample_cnt[6]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[6]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[6]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[7]_i_1 
       (.I0(sample_cnt[7]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[7]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[7]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[8]_i_1 
       (.I0(sample_cnt[8]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[8]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[8]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hF888)) 
    \m_axis_tdata[9]_i_1 
       (.I0(sample_cnt[9]),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(frame_id_reg[9]),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(m_axis_tdata_1[9]));
  FDRE \m_axis_tdata_reg[0] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[0]),
        .Q(m_axis_tdata[0]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[10] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[10]),
        .Q(m_axis_tdata[10]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[11] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[11]),
        .Q(m_axis_tdata[11]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[12] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[12]),
        .Q(m_axis_tdata[12]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[13] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[13]),
        .Q(m_axis_tdata[13]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[14] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[14]),
        .Q(m_axis_tdata[14]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[15] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[15]),
        .Q(m_axis_tdata[15]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[16] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[16]),
        .Q(m_axis_tdata[16]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[17] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[17]),
        .Q(m_axis_tdata[17]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[18] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[18]),
        .Q(m_axis_tdata[18]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[19] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[19]),
        .Q(m_axis_tdata[19]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[1] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[1]),
        .Q(m_axis_tdata[1]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[20] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[20]),
        .Q(m_axis_tdata[20]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[21] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[21]),
        .Q(m_axis_tdata[21]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[22] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[22]),
        .Q(m_axis_tdata[22]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[23] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[23]),
        .Q(m_axis_tdata[23]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[24] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[24]),
        .Q(m_axis_tdata[24]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[25] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[25]),
        .Q(m_axis_tdata[25]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[26] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[26]),
        .Q(m_axis_tdata[26]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[27] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[27]),
        .Q(m_axis_tdata[27]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[28] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[28]),
        .Q(m_axis_tdata[28]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[29] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[29]),
        .Q(m_axis_tdata[29]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[2] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[2]),
        .Q(m_axis_tdata[2]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[30] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[30]),
        .Q(m_axis_tdata[30]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[31] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[31]),
        .Q(m_axis_tdata[31]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[3] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[3]),
        .Q(m_axis_tdata[3]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[4] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[4]),
        .Q(m_axis_tdata[4]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[5] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[5]),
        .Q(m_axis_tdata[5]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[6] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[6]),
        .Q(m_axis_tdata[6]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[7] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[7]),
        .Q(m_axis_tdata[7]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[8] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[8]),
        .Q(m_axis_tdata[8]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \m_axis_tdata_reg[9] 
       (.C(clk),
        .CE(\m_axis_tdata[31]_i_2_n_0 ),
        .D(m_axis_tdata_1[9]),
        .Q(m_axis_tdata[9]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    m_axis_tlast_i_1
       (.I0(\frame_id[0]_i_1_n_0 ),
        .I1(rstn),
        .O(m_axis_tlast_i_1_n_0));
  FDRE m_axis_tlast_reg
       (.C(clk),
        .CE(1'b1),
        .D(m_axis_tlast_i_1_n_0),
        .Q(m_axis_tlast),
        .R(1'b0));
  FDRE m_axis_tvalid_reg
       (.C(clk),
        .CE(1'b1),
        .D(rstn),
        .Q(m_axis_tvalid),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \sample_cnt[0]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[0]),
        .O(sample_cnt_0[0]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \sample_cnt[1]_i_1 
       (.I0(sample_cnt[1]),
        .I1(sample_cnt[0]),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \sample_cnt[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[0]),
        .I2(sample_cnt[1]),
        .I3(sample_cnt[2]),
        .O(sample_cnt_0[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h2AAA8000)) 
    \sample_cnt[3]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[1]),
        .I2(sample_cnt[0]),
        .I3(sample_cnt[2]),
        .I4(sample_cnt[3]),
        .O(sample_cnt_0[3]));
  LUT6 #(
    .INIT(64'h2AAAAAAA80000000)) 
    \sample_cnt[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[2]),
        .I2(sample_cnt[1]),
        .I3(sample_cnt[3]),
        .I4(sample_cnt[0]),
        .I5(sample_cnt[4]),
        .O(sample_cnt_0[4]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h82)) 
    \sample_cnt[5]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(\sample_cnt[8]_i_2_n_0 ),
        .I2(sample_cnt[5]),
        .O(sample_cnt_0[5]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8A20)) 
    \sample_cnt[6]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(\sample_cnt[8]_i_2_n_0 ),
        .I2(sample_cnt[5]),
        .I3(sample_cnt[6]),
        .O(sample_cnt_0[6]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hA2AA0800)) 
    \sample_cnt[7]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[5]),
        .I2(\sample_cnt[8]_i_2_n_0 ),
        .I3(sample_cnt[6]),
        .I4(sample_cnt[7]),
        .O(sample_cnt_0[7]));
  LUT6 #(
    .INIT(64'hAA2AAAAA00800000)) 
    \sample_cnt[8]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(sample_cnt[7]),
        .I2(sample_cnt[6]),
        .I3(\sample_cnt[8]_i_2_n_0 ),
        .I4(sample_cnt[5]),
        .I5(sample_cnt[8]),
        .O(sample_cnt_0[8]));
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    \sample_cnt[8]_i_2 
       (.I0(sample_cnt[0]),
        .I1(sample_cnt[3]),
        .I2(sample_cnt[1]),
        .I3(sample_cnt[2]),
        .I4(sample_cnt[4]),
        .O(\sample_cnt[8]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h8880)) 
    \sample_cnt[9]_i_1 
       (.I0(m_axis_tvalid),
        .I1(m_axis_tready),
        .I2(\FSM_onehot_state_reg_n_0_[2] ),
        .I3(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBFFF400000000000)) 
    \sample_cnt[9]_i_2 
       (.I0(\sample_cnt[9]_i_3_n_0 ),
        .I1(sample_cnt[6]),
        .I2(sample_cnt[7]),
        .I3(sample_cnt[8]),
        .I4(sample_cnt[9]),
        .I5(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\sample_cnt[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \sample_cnt[9]_i_3 
       (.I0(sample_cnt[4]),
        .I1(sample_cnt[2]),
        .I2(sample_cnt[1]),
        .I3(sample_cnt[3]),
        .I4(sample_cnt[0]),
        .I5(sample_cnt[5]),
        .O(\sample_cnt[9]_i_3_n_0 ));
  FDRE \sample_cnt_reg[0] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[0]),
        .Q(sample_cnt[0]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[1] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(\sample_cnt[1]_i_1_n_0 ),
        .Q(sample_cnt[1]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[2] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[2]),
        .Q(sample_cnt[2]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[3] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[3]),
        .Q(sample_cnt[3]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[4] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[4]),
        .Q(sample_cnt[4]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[5] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[5]),
        .Q(sample_cnt[5]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[6] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[6]),
        .Q(sample_cnt[6]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[7] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[7]),
        .Q(sample_cnt[7]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[8] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(sample_cnt_0[8]),
        .Q(sample_cnt[8]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
  FDRE \sample_cnt_reg[9] 
       (.C(clk),
        .CE(\sample_cnt[9]_i_1_n_0 ),
        .D(\sample_cnt[9]_i_2_n_0 ),
        .Q(sample_cnt[9]),
        .R(\m_axis_tdata[31]_i_1_n_0 ));
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
