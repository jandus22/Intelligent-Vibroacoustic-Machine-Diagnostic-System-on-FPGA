-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Tue Mar 24 16:34:17 2026
-- Host        : DESKTOP-1D7OT4F running 64-bit Ubuntu 22.04.5 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/janecki/magister/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/project_1/project_1.gen/sources_1/bd/ethernet/ip/ethernet_axis_test_gen_0_0/ethernet_axis_test_gen_0_0_sim_netlist.vhdl
-- Design      : ethernet_axis_test_gen_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xck26-sfvc784-2LV-c
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ethernet_axis_test_gen_0_0_axis_test_gen is
  port (
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    rstn : in STD_LOGIC;
    clk : in STD_LOGIC;
    m_axis_tready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of ethernet_axis_test_gen_0_0_axis_test_gen : entity is "axis_test_gen";
end ethernet_axis_test_gen_0_0_axis_test_gen;

architecture STRUCTURE of ethernet_axis_test_gen_0_0_axis_test_gen is
  signal \FSM_onehot_state[3]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[0]\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[1]\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[2]\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[3]\ : STD_LOGIC;
  signal \frame_id[0]_i_1_n_0\ : STD_LOGIC;
  signal \frame_id[0]_i_3_n_0\ : STD_LOGIC;
  signal \frame_id[0]_i_4_n_0\ : STD_LOGIC;
  signal \frame_id[0]_i_5_n_0\ : STD_LOGIC;
  signal frame_id_reg : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \frame_id_reg[0]_i_2_n_0\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_1\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_10\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_11\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_12\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_13\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_14\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_15\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_2\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_3\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_4\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_5\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_6\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_7\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_8\ : STD_LOGIC;
  signal \frame_id_reg[0]_i_2_n_9\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_10\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_11\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_12\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_13\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_14\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_15\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_8\ : STD_LOGIC;
  signal \frame_id_reg[16]_i_1_n_9\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_10\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_11\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_12\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_13\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_14\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_15\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_8\ : STD_LOGIC;
  signal \frame_id_reg[24]_i_1_n_9\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_10\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_11\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_12\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_13\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_14\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_15\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_8\ : STD_LOGIC;
  signal \frame_id_reg[8]_i_1_n_9\ : STD_LOGIC;
  signal \m_axis_tdata[31]_i_1_n_0\ : STD_LOGIC;
  signal \m_axis_tdata[31]_i_2_n_0\ : STD_LOGIC;
  signal m_axis_tdata_1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m_axis_tlast_i_1_n_0 : STD_LOGIC;
  signal \^m_axis_tvalid\ : STD_LOGIC;
  signal sample_cnt : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \sample_cnt[1]_i_1_n_0\ : STD_LOGIC;
  signal \sample_cnt[8]_i_2_n_0\ : STD_LOGIC;
  signal \sample_cnt[9]_i_1_n_0\ : STD_LOGIC;
  signal \sample_cnt[9]_i_2_n_0\ : STD_LOGIC;
  signal \sample_cnt[9]_i_3_n_0\ : STD_LOGIC;
  signal sample_cnt_0 : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal \NLW_frame_id_reg[24]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[0]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[1]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[2]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[3]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \frame_id[0]_i_3\ : label is "soft_lutpair5";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \frame_id_reg[0]_i_2\ : label is 35;
  attribute ADDER_THRESHOLD of \frame_id_reg[16]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \frame_id_reg[24]_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \frame_id_reg[8]_i_1\ : label is 35;
  attribute SOFT_HLUTNM of \m_axis_tdata[0]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \m_axis_tdata[10]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \m_axis_tdata[11]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \m_axis_tdata[12]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \m_axis_tdata[13]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \m_axis_tdata[14]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \m_axis_tdata[15]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \m_axis_tdata[16]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \m_axis_tdata[17]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \m_axis_tdata[18]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \m_axis_tdata[19]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \m_axis_tdata[1]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \m_axis_tdata[20]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \m_axis_tdata[21]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \m_axis_tdata[22]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \m_axis_tdata[23]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \m_axis_tdata[24]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \m_axis_tdata[25]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \m_axis_tdata[26]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \m_axis_tdata[27]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \m_axis_tdata[28]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \m_axis_tdata[29]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \m_axis_tdata[2]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \m_axis_tdata[30]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_tdata[31]_i_3\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdata[3]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \m_axis_tdata[4]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \m_axis_tdata[5]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_axis_tdata[6]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \m_axis_tdata[7]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \m_axis_tdata[8]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \m_axis_tdata[9]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \sample_cnt[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \sample_cnt[1]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \sample_cnt[2]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \sample_cnt[3]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \sample_cnt[5]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \sample_cnt[6]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \sample_cnt[7]_i_1\ : label is "soft_lutpair0";
begin
  m_axis_tvalid <= \^m_axis_tvalid\;
\FSM_onehot_state[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFEAAAAAAAAAAAA"
    )
        port map (
      I0 => \frame_id[0]_i_1_n_0\,
      I1 => \FSM_onehot_state_reg_n_0_[0]\,
      I2 => \FSM_onehot_state_reg_n_0_[1]\,
      I3 => \FSM_onehot_state_reg_n_0_[2]\,
      I4 => m_axis_tready,
      I5 => \^m_axis_tvalid\,
      O => \FSM_onehot_state[3]_i_1_n_0\
    );
\FSM_onehot_state_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[3]_i_1_n_0\,
      D => \FSM_onehot_state_reg_n_0_[3]\,
      Q => \FSM_onehot_state_reg_n_0_[0]\,
      S => \m_axis_tdata[31]_i_1_n_0\
    );
\FSM_onehot_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[3]_i_1_n_0\,
      D => \FSM_onehot_state_reg_n_0_[0]\,
      Q => \FSM_onehot_state_reg_n_0_[1]\,
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\FSM_onehot_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[3]_i_1_n_0\,
      D => \FSM_onehot_state_reg_n_0_[1]\,
      Q => \FSM_onehot_state_reg_n_0_[2]\,
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\FSM_onehot_state_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[3]_i_1_n_0\,
      D => \FSM_onehot_state_reg_n_0_[2]\,
      Q => \FSM_onehot_state_reg_n_0_[3]\,
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000010000000"
    )
        port map (
      I0 => \sample_cnt[8]_i_2_n_0\,
      I1 => \frame_id[0]_i_3_n_0\,
      I2 => sample_cnt(7),
      I3 => sample_cnt(8),
      I4 => sample_cnt(9),
      I5 => \frame_id[0]_i_4_n_0\,
      O => \frame_id[0]_i_1_n_0\
    );
\frame_id[0]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => sample_cnt(5),
      I1 => sample_cnt(6),
      O => \frame_id[0]_i_3_n_0\
    );
\frame_id[0]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => \^m_axis_tvalid\,
      I2 => m_axis_tready,
      O => \frame_id[0]_i_4_n_0\
    );
\frame_id[0]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => frame_id_reg(0),
      O => \frame_id[0]_i_5_n_0\
    );
\frame_id_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_15\,
      Q => frame_id_reg(0),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[0]_i_2\: unisim.vcomponents.CARRY8
     port map (
      CI => '0',
      CI_TOP => '0',
      CO(7) => \frame_id_reg[0]_i_2_n_0\,
      CO(6) => \frame_id_reg[0]_i_2_n_1\,
      CO(5) => \frame_id_reg[0]_i_2_n_2\,
      CO(4) => \frame_id_reg[0]_i_2_n_3\,
      CO(3) => \frame_id_reg[0]_i_2_n_4\,
      CO(2) => \frame_id_reg[0]_i_2_n_5\,
      CO(1) => \frame_id_reg[0]_i_2_n_6\,
      CO(0) => \frame_id_reg[0]_i_2_n_7\,
      DI(7 downto 0) => B"00000001",
      O(7) => \frame_id_reg[0]_i_2_n_8\,
      O(6) => \frame_id_reg[0]_i_2_n_9\,
      O(5) => \frame_id_reg[0]_i_2_n_10\,
      O(4) => \frame_id_reg[0]_i_2_n_11\,
      O(3) => \frame_id_reg[0]_i_2_n_12\,
      O(2) => \frame_id_reg[0]_i_2_n_13\,
      O(1) => \frame_id_reg[0]_i_2_n_14\,
      O(0) => \frame_id_reg[0]_i_2_n_15\,
      S(7 downto 1) => frame_id_reg(7 downto 1),
      S(0) => \frame_id[0]_i_5_n_0\
    );
\frame_id_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_13\,
      Q => frame_id_reg(10),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_12\,
      Q => frame_id_reg(11),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_11\,
      Q => frame_id_reg(12),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_10\,
      Q => frame_id_reg(13),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_9\,
      Q => frame_id_reg(14),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_8\,
      Q => frame_id_reg(15),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_15\,
      Q => frame_id_reg(16),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[16]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \frame_id_reg[8]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \frame_id_reg[16]_i_1_n_0\,
      CO(6) => \frame_id_reg[16]_i_1_n_1\,
      CO(5) => \frame_id_reg[16]_i_1_n_2\,
      CO(4) => \frame_id_reg[16]_i_1_n_3\,
      CO(3) => \frame_id_reg[16]_i_1_n_4\,
      CO(2) => \frame_id_reg[16]_i_1_n_5\,
      CO(1) => \frame_id_reg[16]_i_1_n_6\,
      CO(0) => \frame_id_reg[16]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \frame_id_reg[16]_i_1_n_8\,
      O(6) => \frame_id_reg[16]_i_1_n_9\,
      O(5) => \frame_id_reg[16]_i_1_n_10\,
      O(4) => \frame_id_reg[16]_i_1_n_11\,
      O(3) => \frame_id_reg[16]_i_1_n_12\,
      O(2) => \frame_id_reg[16]_i_1_n_13\,
      O(1) => \frame_id_reg[16]_i_1_n_14\,
      O(0) => \frame_id_reg[16]_i_1_n_15\,
      S(7 downto 0) => frame_id_reg(23 downto 16)
    );
\frame_id_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_14\,
      Q => frame_id_reg(17),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_13\,
      Q => frame_id_reg(18),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_12\,
      Q => frame_id_reg(19),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_14\,
      Q => frame_id_reg(1),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_11\,
      Q => frame_id_reg(20),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_10\,
      Q => frame_id_reg(21),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_9\,
      Q => frame_id_reg(22),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[16]_i_1_n_8\,
      Q => frame_id_reg(23),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_15\,
      Q => frame_id_reg(24),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[24]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \frame_id_reg[16]_i_1_n_0\,
      CI_TOP => '0',
      CO(7) => \NLW_frame_id_reg[24]_i_1_CO_UNCONNECTED\(7),
      CO(6) => \frame_id_reg[24]_i_1_n_1\,
      CO(5) => \frame_id_reg[24]_i_1_n_2\,
      CO(4) => \frame_id_reg[24]_i_1_n_3\,
      CO(3) => \frame_id_reg[24]_i_1_n_4\,
      CO(2) => \frame_id_reg[24]_i_1_n_5\,
      CO(1) => \frame_id_reg[24]_i_1_n_6\,
      CO(0) => \frame_id_reg[24]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \frame_id_reg[24]_i_1_n_8\,
      O(6) => \frame_id_reg[24]_i_1_n_9\,
      O(5) => \frame_id_reg[24]_i_1_n_10\,
      O(4) => \frame_id_reg[24]_i_1_n_11\,
      O(3) => \frame_id_reg[24]_i_1_n_12\,
      O(2) => \frame_id_reg[24]_i_1_n_13\,
      O(1) => \frame_id_reg[24]_i_1_n_14\,
      O(0) => \frame_id_reg[24]_i_1_n_15\,
      S(7 downto 0) => frame_id_reg(31 downto 24)
    );
\frame_id_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_14\,
      Q => frame_id_reg(25),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_13\,
      Q => frame_id_reg(26),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_12\,
      Q => frame_id_reg(27),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_11\,
      Q => frame_id_reg(28),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_10\,
      Q => frame_id_reg(29),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_13\,
      Q => frame_id_reg(2),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_9\,
      Q => frame_id_reg(30),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[24]_i_1_n_8\,
      Q => frame_id_reg(31),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_12\,
      Q => frame_id_reg(3),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_11\,
      Q => frame_id_reg(4),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_10\,
      Q => frame_id_reg(5),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_9\,
      Q => frame_id_reg(6),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[0]_i_2_n_8\,
      Q => frame_id_reg(7),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_15\,
      Q => frame_id_reg(8),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\frame_id_reg[8]_i_1\: unisim.vcomponents.CARRY8
     port map (
      CI => \frame_id_reg[0]_i_2_n_0\,
      CI_TOP => '0',
      CO(7) => \frame_id_reg[8]_i_1_n_0\,
      CO(6) => \frame_id_reg[8]_i_1_n_1\,
      CO(5) => \frame_id_reg[8]_i_1_n_2\,
      CO(4) => \frame_id_reg[8]_i_1_n_3\,
      CO(3) => \frame_id_reg[8]_i_1_n_4\,
      CO(2) => \frame_id_reg[8]_i_1_n_5\,
      CO(1) => \frame_id_reg[8]_i_1_n_6\,
      CO(0) => \frame_id_reg[8]_i_1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \frame_id_reg[8]_i_1_n_8\,
      O(6) => \frame_id_reg[8]_i_1_n_9\,
      O(5) => \frame_id_reg[8]_i_1_n_10\,
      O(4) => \frame_id_reg[8]_i_1_n_11\,
      O(3) => \frame_id_reg[8]_i_1_n_12\,
      O(2) => \frame_id_reg[8]_i_1_n_13\,
      O(1) => \frame_id_reg[8]_i_1_n_14\,
      O(0) => \frame_id_reg[8]_i_1_n_15\,
      S(7 downto 0) => frame_id_reg(15 downto 8)
    );
\frame_id_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \frame_id[0]_i_1_n_0\,
      D => \frame_id_reg[8]_i_1_n_14\,
      Q => frame_id_reg(9),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(0),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => \FSM_onehot_state_reg_n_0_[0]\,
      I3 => frame_id_reg(0),
      O => m_axis_tdata_1(0)
    );
\m_axis_tdata[10]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(10),
      O => m_axis_tdata_1(10)
    );
\m_axis_tdata[11]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(11),
      O => m_axis_tdata_1(11)
    );
\m_axis_tdata[12]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(12),
      O => m_axis_tdata_1(12)
    );
\m_axis_tdata[13]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(13),
      O => m_axis_tdata_1(13)
    );
\m_axis_tdata[14]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(14),
      O => m_axis_tdata_1(14)
    );
\m_axis_tdata[15]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(15),
      O => m_axis_tdata_1(15)
    );
\m_axis_tdata[16]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(16),
      O => m_axis_tdata_1(16)
    );
\m_axis_tdata[17]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(17),
      O => m_axis_tdata_1(17)
    );
\m_axis_tdata[18]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(18),
      O => m_axis_tdata_1(18)
    );
\m_axis_tdata[19]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(19),
      O => m_axis_tdata_1(19)
    );
\m_axis_tdata[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(1),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(1),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(1)
    );
\m_axis_tdata[20]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(20),
      O => m_axis_tdata_1(20)
    );
\m_axis_tdata[21]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(21),
      O => m_axis_tdata_1(21)
    );
\m_axis_tdata[22]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(22),
      O => m_axis_tdata_1(22)
    );
\m_axis_tdata[23]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(23),
      O => m_axis_tdata_1(23)
    );
\m_axis_tdata[24]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(24),
      O => m_axis_tdata_1(24)
    );
\m_axis_tdata[25]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(25),
      O => m_axis_tdata_1(25)
    );
\m_axis_tdata[26]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(26),
      O => m_axis_tdata_1(26)
    );
\m_axis_tdata[27]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(27),
      O => m_axis_tdata_1(27)
    );
\m_axis_tdata[28]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(28),
      O => m_axis_tdata_1(28)
    );
\m_axis_tdata[29]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(29),
      O => m_axis_tdata_1(29)
    );
\m_axis_tdata[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(2),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(2),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(2)
    );
\m_axis_tdata[30]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(30),
      O => m_axis_tdata_1(30)
    );
\m_axis_tdata[31]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rstn,
      O => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata[31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => m_axis_tready,
      I1 => \^m_axis_tvalid\,
      O => \m_axis_tdata[31]_i_2_n_0\
    );
\m_axis_tdata[31]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[0]\,
      I1 => frame_id_reg(31),
      O => m_axis_tdata_1(31)
    );
\m_axis_tdata[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(3),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(3),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(3)
    );
\m_axis_tdata[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(4),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(4),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(4)
    );
\m_axis_tdata[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(5),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(5),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(5)
    );
\m_axis_tdata[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(6),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(6),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(6)
    );
\m_axis_tdata[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(7),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(7),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(7)
    );
\m_axis_tdata[8]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(8),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(8),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(8)
    );
\m_axis_tdata[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => sample_cnt(9),
      I1 => \FSM_onehot_state_reg_n_0_[3]\,
      I2 => frame_id_reg(9),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata_1(9)
    );
\m_axis_tdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(0),
      Q => m_axis_tdata(0),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(10),
      Q => m_axis_tdata(10),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(11),
      Q => m_axis_tdata(11),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(12),
      Q => m_axis_tdata(12),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(13),
      Q => m_axis_tdata(13),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(14),
      Q => m_axis_tdata(14),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(15),
      Q => m_axis_tdata(15),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(16),
      Q => m_axis_tdata(16),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(17),
      Q => m_axis_tdata(17),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(18),
      Q => m_axis_tdata(18),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(19),
      Q => m_axis_tdata(19),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(1),
      Q => m_axis_tdata(1),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(20),
      Q => m_axis_tdata(20),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(21),
      Q => m_axis_tdata(21),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(22),
      Q => m_axis_tdata(22),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(23),
      Q => m_axis_tdata(23),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(24),
      Q => m_axis_tdata(24),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(25),
      Q => m_axis_tdata(25),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(26),
      Q => m_axis_tdata(26),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(27),
      Q => m_axis_tdata(27),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(28),
      Q => m_axis_tdata(28),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(29),
      Q => m_axis_tdata(29),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(2),
      Q => m_axis_tdata(2),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(30),
      Q => m_axis_tdata(30),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(31),
      Q => m_axis_tdata(31),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(3),
      Q => m_axis_tdata(3),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(4),
      Q => m_axis_tdata(4),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(5),
      Q => m_axis_tdata(5),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(6),
      Q => m_axis_tdata(6),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(7),
      Q => m_axis_tdata(7),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(8),
      Q => m_axis_tdata(8),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\m_axis_tdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \m_axis_tdata[31]_i_2_n_0\,
      D => m_axis_tdata_1(9),
      Q => m_axis_tdata(9),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
m_axis_tlast_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \frame_id[0]_i_1_n_0\,
      I1 => rstn,
      O => m_axis_tlast_i_1_n_0
    );
m_axis_tlast_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => m_axis_tlast_i_1_n_0,
      Q => m_axis_tlast,
      R => '0'
    );
m_axis_tvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => rstn,
      Q => \^m_axis_tvalid\,
      R => '0'
    );
\sample_cnt[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(0),
      O => sample_cnt_0(0)
    );
\sample_cnt[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"60"
    )
        port map (
      I0 => sample_cnt(1),
      I1 => sample_cnt(0),
      I2 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[1]_i_1_n_0\
    );
\sample_cnt[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2A80"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(0),
      I2 => sample_cnt(1),
      I3 => sample_cnt(2),
      O => sample_cnt_0(2)
    );
\sample_cnt[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2AAA8000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(1),
      I2 => sample_cnt(0),
      I3 => sample_cnt(2),
      I4 => sample_cnt(3),
      O => sample_cnt_0(3)
    );
\sample_cnt[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2AAAAAAA80000000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(2),
      I2 => sample_cnt(1),
      I3 => sample_cnt(3),
      I4 => sample_cnt(0),
      I5 => sample_cnt(4),
      O => sample_cnt_0(4)
    );
\sample_cnt[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"82"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => \sample_cnt[8]_i_2_n_0\,
      I2 => sample_cnt(5),
      O => sample_cnt_0(5)
    );
\sample_cnt[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8A20"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => \sample_cnt[8]_i_2_n_0\,
      I2 => sample_cnt(5),
      I3 => sample_cnt(6),
      O => sample_cnt_0(6)
    );
\sample_cnt[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A2AA0800"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(5),
      I2 => \sample_cnt[8]_i_2_n_0\,
      I3 => sample_cnt(6),
      I4 => sample_cnt(7),
      O => sample_cnt_0(7)
    );
\sample_cnt[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AA2AAAAA00800000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(7),
      I2 => sample_cnt(6),
      I3 => \sample_cnt[8]_i_2_n_0\,
      I4 => sample_cnt(5),
      I5 => sample_cnt(8),
      O => sample_cnt_0(8)
    );
\sample_cnt[8]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFFFFFF"
    )
        port map (
      I0 => sample_cnt(0),
      I1 => sample_cnt(3),
      I2 => sample_cnt(1),
      I3 => sample_cnt(2),
      I4 => sample_cnt(4),
      O => \sample_cnt[8]_i_2_n_0\
    );
\sample_cnt[9]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8880"
    )
        port map (
      I0 => \^m_axis_tvalid\,
      I1 => m_axis_tready,
      I2 => \FSM_onehot_state_reg_n_0_[2]\,
      I3 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[9]_i_1_n_0\
    );
\sample_cnt[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BFFF400000000000"
    )
        port map (
      I0 => \sample_cnt[9]_i_3_n_0\,
      I1 => sample_cnt(6),
      I2 => sample_cnt(7),
      I3 => sample_cnt(8),
      I4 => sample_cnt(9),
      I5 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[9]_i_2_n_0\
    );
\sample_cnt[9]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => sample_cnt(4),
      I1 => sample_cnt(2),
      I2 => sample_cnt(1),
      I3 => sample_cnt(3),
      I4 => sample_cnt(0),
      I5 => sample_cnt(5),
      O => \sample_cnt[9]_i_3_n_0\
    );
\sample_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(0),
      Q => sample_cnt(0),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => \sample_cnt[1]_i_1_n_0\,
      Q => sample_cnt(1),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(2),
      Q => sample_cnt(2),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(3),
      Q => sample_cnt(3),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(4),
      Q => sample_cnt(4),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(5),
      Q => sample_cnt(5),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(6),
      Q => sample_cnt(6),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(7),
      Q => sample_cnt(7),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => sample_cnt_0(8),
      Q => sample_cnt(8),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
\sample_cnt_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[9]_i_1_n_0\,
      D => \sample_cnt[9]_i_2_n_0\,
      Q => sample_cnt(9),
      R => \m_axis_tdata[31]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ethernet_axis_test_gen_0_0 is
  port (
    clk : in STD_LOGIC;
    rstn : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tlast : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of ethernet_axis_test_gen_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of ethernet_axis_test_gen_0_0 : entity is "ethernet_axis_test_gen_0_0,axis_test_gen,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of ethernet_axis_test_gen_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of ethernet_axis_test_gen_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of ethernet_axis_test_gen_0_0 : entity is "axis_test_gen,Vivado 2025.2";
end ethernet_axis_test_gen_0_0;

architecture STRUCTURE of ethernet_axis_test_gen_0_0 is
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF m_axis, ASSOCIATED_RESET rstn, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN ethernet_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tlast : signal is "xilinx.com:interface:axis:1.0 m_axis TLAST";
  attribute X_INTERFACE_INFO of m_axis_tready : signal is "xilinx.com:interface:axis:1.0 m_axis TREADY";
  attribute X_INTERFACE_INFO of m_axis_tvalid : signal is "xilinx.com:interface:axis:1.0 m_axis TVALID";
  attribute X_INTERFACE_INFO of rstn : signal is "xilinx.com:signal:reset:1.0 rstn RST";
  attribute X_INTERFACE_MODE of rstn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of rstn : signal is "XIL_INTERFACENAME rstn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_tdata : signal is "xilinx.com:interface:axis:1.0 m_axis TDATA";
  attribute X_INTERFACE_MODE of m_axis_tdata : signal is "master";
  attribute X_INTERFACE_PARAMETER of m_axis_tdata : signal is "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 99999001, PHASE 0.0, CLK_DOMAIN ethernet_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0";
begin
inst: entity work.ethernet_axis_test_gen_0_0_axis_test_gen
     port map (
      clk => clk,
      m_axis_tdata(31 downto 0) => m_axis_tdata(31 downto 0),
      m_axis_tlast => m_axis_tlast,
      m_axis_tready => m_axis_tready,
      m_axis_tvalid => m_axis_tvalid,
      rstn => rstn
    );
end STRUCTURE;
