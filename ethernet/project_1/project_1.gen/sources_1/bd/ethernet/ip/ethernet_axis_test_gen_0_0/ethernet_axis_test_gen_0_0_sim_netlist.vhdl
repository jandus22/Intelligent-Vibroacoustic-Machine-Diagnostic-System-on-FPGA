-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Tue Jul 28 08:21:09 2026
-- Host        : Magisterka running 64-bit Ubuntu 26.04 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/project_1/project_1.gen/sources_1/bd/ethernet/ip/ethernet_axis_test_gen_0_0/ethernet_axis_test_gen_0_0_sim_netlist.vhdl
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
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 13 downto 0 );
    clk : in STD_LOGIC;
    rstn : in STD_LOGIC;
    m_axis_tready : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of ethernet_axis_test_gen_0_0_axis_test_gen : entity is "axis_test_gen";
end ethernet_axis_test_gen_0_0_axis_test_gen;

architecture STRUCTURE of ethernet_axis_test_gen_0_0_axis_test_gen is
  signal \FSM_onehot_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[2]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[0]\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[3]\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^m_axis_tlast\ : STD_LOGIC;
  signal m_axis_tlast_INST_0_i_1_n_0 : STD_LOGIC;
  signal m_axis_tlast_INST_0_i_2_n_0 : STD_LOGIC;
  signal sample_cnt : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal \sample_cnt[11]_i_1_n_0\ : STD_LOGIC;
  signal \sample_cnt[11]_i_2_n_0\ : STD_LOGIC;
  signal \sample_cnt[11]_i_3_n_0\ : STD_LOGIC;
  signal \sample_cnt[1]_i_1_n_0\ : STD_LOGIC;
  signal \sample_cnt[3]_i_1_n_0\ : STD_LOGIC;
  signal \sample_cnt[6]_i_1_n_0\ : STD_LOGIC;
  signal \sample_cnt[6]_i_2_n_0\ : STD_LOGIC;
  signal \sample_cnt__0\ : STD_LOGIC_VECTOR ( 10 downto 0 );
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[0]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[1]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[2]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[3]\ : label is "ST_HDR0:0001,ST_HDR1:0010,ST_HDR2:0100,ST_DATA:1000";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \m_axis_tdata[0]_INST_0\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \m_axis_tdata[10]_INST_0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \m_axis_tdata[11]_INST_0\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \m_axis_tdata[24]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_axis_tdata[29]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \m_axis_tdata[2]_INST_0\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \m_axis_tdata[3]_INST_0\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \m_axis_tdata[4]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \m_axis_tdata[5]_INST_0\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \m_axis_tdata[6]_INST_0\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \m_axis_tdata[7]_INST_0\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \m_axis_tdata[8]_INST_0\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \m_axis_tdata[9]_INST_0\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of m_axis_tlast_INST_0_i_2 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \sample_cnt[0]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \sample_cnt[10]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \sample_cnt[11]_i_2\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \sample_cnt[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \sample_cnt[2]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \sample_cnt[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \sample_cnt[5]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \sample_cnt[6]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \sample_cnt[7]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \sample_cnt[8]_i_1\ : label is "soft_lutpair1";
begin
  Q(1 downto 0) <= \^q\(1 downto 0);
  m_axis_tlast <= \^m_axis_tlast\;
\FSM_onehot_state[2]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rstn,
      O => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state[2]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAAAAAA8"
    )
        port map (
      I0 => m_axis_tready,
      I1 => \^m_axis_tlast\,
      I2 => \^q\(1),
      I3 => \FSM_onehot_state_reg_n_0_[0]\,
      I4 => \^q\(0),
      O => \FSM_onehot_state[2]_i_2_n_0\
    );
\FSM_onehot_state_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[2]_i_2_n_0\,
      D => \FSM_onehot_state_reg_n_0_[3]\,
      Q => \FSM_onehot_state_reg_n_0_[0]\,
      S => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[2]_i_2_n_0\,
      D => \FSM_onehot_state_reg_n_0_[0]\,
      Q => \^q\(0),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[2]_i_2_n_0\,
      D => \^q\(0),
      Q => \^q\(1),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \FSM_onehot_state[2]_i_2_n_0\,
      D => \^q\(1),
      Q => \FSM_onehot_state_reg_n_0_[3]\,
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\m_axis_tdata[0]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(0),
      O => m_axis_tdata(0)
    );
\m_axis_tdata[10]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(10),
      O => m_axis_tdata(10)
    );
\m_axis_tdata[11]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(11),
      O => m_axis_tdata(11)
    );
\m_axis_tdata[1]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(1),
      O => m_axis_tdata(1)
    );
\m_axis_tdata[24]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \^q\(0),
      I1 => \FSM_onehot_state_reg_n_0_[0]\,
      I2 => \^q\(1),
      O => m_axis_tdata(13)
    );
\m_axis_tdata[29]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \^q\(0),
      I1 => \FSM_onehot_state_reg_n_0_[0]\,
      O => m_axis_tdata(12)
    );
\m_axis_tdata[2]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(2),
      O => m_axis_tdata(2)
    );
\m_axis_tdata[3]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(3),
      O => m_axis_tdata(3)
    );
\m_axis_tdata[4]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(4),
      O => m_axis_tdata(4)
    );
\m_axis_tdata[5]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(5),
      O => m_axis_tdata(5)
    );
\m_axis_tdata[6]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(6),
      O => m_axis_tdata(6)
    );
\m_axis_tdata[7]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(7),
      O => m_axis_tdata(7)
    );
\m_axis_tdata[8]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(8),
      O => m_axis_tdata(8)
    );
\m_axis_tdata[9]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(9),
      O => m_axis_tdata(9)
    );
m_axis_tlast_INST_0: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000080000000"
    )
        port map (
      I0 => sample_cnt(7),
      I1 => sample_cnt(6),
      I2 => m_axis_tlast_INST_0_i_1_n_0,
      I3 => sample_cnt(8),
      I4 => sample_cnt(9),
      I5 => m_axis_tlast_INST_0_i_2_n_0,
      O => \^m_axis_tlast\
    );
m_axis_tlast_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => sample_cnt(1),
      I1 => sample_cnt(0),
      I2 => sample_cnt(2),
      I3 => sample_cnt(5),
      I4 => sample_cnt(4),
      I5 => sample_cnt(3),
      O => m_axis_tlast_INST_0_i_1_n_0
    );
m_axis_tlast_INST_0_i_2: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => sample_cnt(11),
      I1 => sample_cnt(10),
      I2 => \FSM_onehot_state_reg_n_0_[3]\,
      O => m_axis_tlast_INST_0_i_2_n_0
    );
\sample_cnt[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(0),
      O => \sample_cnt__0\(0)
    );
\sample_cnt[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"28"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => \sample_cnt[11]_i_3_n_0\,
      I2 => sample_cnt(10),
      O => \sample_cnt__0\(10)
    );
\sample_cnt[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => m_axis_tready,
      I1 => \^q\(1),
      I2 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[11]_i_1_n_0\
    );
\sample_cnt[11]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7800"
    )
        port map (
      I0 => \sample_cnt[11]_i_3_n_0\,
      I1 => sample_cnt(10),
      I2 => sample_cnt(11),
      I3 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[11]_i_2_n_0\
    );
\sample_cnt[11]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80000000"
    )
        port map (
      I0 => sample_cnt(9),
      I1 => sample_cnt(8),
      I2 => m_axis_tlast_INST_0_i_1_n_0,
      I3 => sample_cnt(6),
      I4 => sample_cnt(7),
      O => \sample_cnt[11]_i_3_n_0\
    );
\sample_cnt[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"60"
    )
        port map (
      I0 => sample_cnt(0),
      I1 => sample_cnt(1),
      I2 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[1]_i_1_n_0\
    );
\sample_cnt[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2A80"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(1),
      I2 => sample_cnt(0),
      I3 => sample_cnt(2),
      O => \sample_cnt__0\(2)
    );
\sample_cnt[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7F800000"
    )
        port map (
      I0 => sample_cnt(2),
      I1 => sample_cnt(0),
      I2 => sample_cnt(1),
      I3 => sample_cnt(3),
      I4 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[3]_i_1_n_0\
    );
\sample_cnt[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2AAAAAAA80000000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(3),
      I2 => sample_cnt(1),
      I3 => sample_cnt(0),
      I4 => sample_cnt(2),
      I5 => sample_cnt(4),
      O => \sample_cnt__0\(4)
    );
\sample_cnt[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2AAA8000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(4),
      I2 => \sample_cnt[6]_i_2_n_0\,
      I3 => sample_cnt(3),
      I4 => sample_cnt(5),
      O => \sample_cnt__0\(5)
    );
\sample_cnt[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFF800000000000"
    )
        port map (
      I0 => \sample_cnt[6]_i_2_n_0\,
      I1 => sample_cnt(5),
      I2 => sample_cnt(4),
      I3 => sample_cnt(3),
      I4 => sample_cnt(6),
      I5 => \FSM_onehot_state_reg_n_0_[3]\,
      O => \sample_cnt[6]_i_1_n_0\
    );
\sample_cnt[6]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => sample_cnt(2),
      I1 => sample_cnt(0),
      I2 => sample_cnt(1),
      O => \sample_cnt[6]_i_2_n_0\
    );
\sample_cnt[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2A80"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(6),
      I2 => m_axis_tlast_INST_0_i_1_n_0,
      I3 => sample_cnt(7),
      O => \sample_cnt__0\(7)
    );
\sample_cnt[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2AAA8000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => m_axis_tlast_INST_0_i_1_n_0,
      I2 => sample_cnt(6),
      I3 => sample_cnt(7),
      I4 => sample_cnt(8),
      O => \sample_cnt__0\(8)
    );
\sample_cnt[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2AAAAAAA80000000"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[3]\,
      I1 => sample_cnt(7),
      I2 => sample_cnt(6),
      I3 => m_axis_tlast_INST_0_i_1_n_0,
      I4 => sample_cnt(8),
      I5 => sample_cnt(9),
      O => \sample_cnt__0\(9)
    );
\sample_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(0),
      Q => sample_cnt(0),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(10),
      Q => sample_cnt(10),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt[11]_i_2_n_0\,
      Q => sample_cnt(11),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt[1]_i_1_n_0\,
      Q => sample_cnt(1),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(2),
      Q => sample_cnt(2),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt[3]_i_1_n_0\,
      Q => sample_cnt(3),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(4),
      Q => sample_cnt(4),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(5),
      Q => sample_cnt(5),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt[6]_i_1_n_0\,
      Q => sample_cnt(6),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(7),
      Q => sample_cnt(7),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(8),
      Q => sample_cnt(8),
      R => \FSM_onehot_state[2]_i_1_n_0\
    );
\sample_cnt_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => \sample_cnt[11]_i_1_n_0\,
      D => \sample_cnt__0\(9),
      Q => sample_cnt(9),
      R => \FSM_onehot_state[2]_i_1_n_0\
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
  signal \<const0>\ : STD_LOGIC;
  signal \^m_axis_tdata\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^rstn\ : STD_LOGIC;
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
  \^rstn\ <= rstn;
  m_axis_tdata(31 downto 28) <= \^m_axis_tdata\(31 downto 28);
  m_axis_tdata(27) <= \<const0>\;
  m_axis_tdata(26) <= \^m_axis_tdata\(31);
  m_axis_tdata(25) <= \<const0>\;
  m_axis_tdata(24) <= \^m_axis_tdata\(31);
  m_axis_tdata(23) <= \<const0>\;
  m_axis_tdata(22) <= \<const0>\;
  m_axis_tdata(21) <= \<const0>\;
  m_axis_tdata(20) <= \<const0>\;
  m_axis_tdata(19) <= \<const0>\;
  m_axis_tdata(18) <= \<const0>\;
  m_axis_tdata(17) <= \<const0>\;
  m_axis_tdata(16) <= \<const0>\;
  m_axis_tdata(15) <= \<const0>\;
  m_axis_tdata(14) <= \<const0>\;
  m_axis_tdata(13) <= \<const0>\;
  m_axis_tdata(12) <= \<const0>\;
  m_axis_tdata(11 downto 0) <= \^m_axis_tdata\(11 downto 0);
  m_axis_tvalid <= \^rstn\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.ethernet_axis_test_gen_0_0_axis_test_gen
     port map (
      Q(1) => \^m_axis_tdata\(30),
      Q(0) => \^m_axis_tdata\(28),
      clk => clk,
      m_axis_tdata(13) => \^m_axis_tdata\(31),
      m_axis_tdata(12) => \^m_axis_tdata\(29),
      m_axis_tdata(11 downto 0) => \^m_axis_tdata\(11 downto 0),
      m_axis_tlast => m_axis_tlast,
      m_axis_tready => m_axis_tready,
      rstn => \^rstn\
    );
end STRUCTURE;
