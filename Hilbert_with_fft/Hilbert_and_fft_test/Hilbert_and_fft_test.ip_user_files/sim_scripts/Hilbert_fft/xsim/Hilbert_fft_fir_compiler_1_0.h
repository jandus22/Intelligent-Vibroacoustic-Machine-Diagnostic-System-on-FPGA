
//------------------------------------------------------------------------------
// (c) Copyright 2023 Advanced Micro Devices. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------ 
//
// C Model configuration for the "Hilbert_fft_fir_compiler_1_0" instance.
//
//------------------------------------------------------------------------------
//
// coefficients: -73,0,-83,0,-129,0,-189,0,-267,0,-367,0,-494,0,-654,0,-858,0,-1122,0,-1471,0,-1958,0,-2693,0,-3963,0,-6826,0,-20818,0,20818,0,6826,0,3963,0,2693,0,1958,0,1471,0,1122,0,858,0,654,0,494,0,367,0,267,0,189,0,129,0,83,0,73
// chanpats: 173
// name: Hilbert_fft_fir_compiler_1_0
// data_coefficient_type: 0
// filter_type: 3
// rate_change: 0
// interp_rate: 1
// decim_rate: 1
// zero_pack_factor: 1
// coeff_padding: 0
// num_coeffs: 63
// coeff_sets: 1
// reloadable: 0
// is_halfband: 0
// quantization: 1
// coeff_width: 16
// coeff_fract_width: 0
// chan_seq: 0
// num_channels: 3
// num_paths: 1
// data_width: 16
// data_fract_width: 0
// output_rounding_mode: 4
// output_width: 16
// accum_width: 33
// output_fract_width: 0
// config_method: 0

const double Hilbert_fft_fir_compiler_1_0_coefficients[63] = {-73,0,-83,0,-129,0,-189,0,-267,0,-367,0,-494,0,-654,0,-858,0,-1122,0,-1471,0,-1958,0,-2693,0,-3963,0,-6826,0,-20818,0,20818,0,6826,0,3963,0,2693,0,1958,0,1471,0,1122,0,858,0,654,0,494,0,367,0,267,0,189,0,129,0,83,0,73};

const xip_fir_v7_2_pattern Hilbert_fft_fir_compiler_1_0_chanpats[1] = {P_BASIC};

static xip_fir_v7_2_config gen_Hilbert_fft_fir_compiler_1_0_config() {
  xip_fir_v7_2_config config;
  config.name                = "Hilbert_fft_fir_compiler_1_0";
  config.data_coefficient_type = XIP_FIR_REAL_TYPE;
  config.filter_type         = 3;
  config.rate_change         = XIP_FIR_INTEGER_RATE;
  config.interp_rate         = 1;
  config.decim_rate          = 1;
  config.zero_pack_factor    = 1;
  config.coeff               = &Hilbert_fft_fir_compiler_1_0_coefficients[0];
  config.coeff_padding       = 0;
  config.num_coeffs          = 63;
  config.coeff_sets          = 1;
  config.reloadable          = 0;
  config.is_halfband         = 0;
  config.quantization        = XIP_FIR_QUANTIZED_ONLY;
  config.coeff_width         = 16;
  config.coeff_fract_width   = 0;
  config.chan_seq            = XIP_FIR_BASIC_CHAN_SEQ;
  config.num_channels        = 3;
  config.init_pattern        = Hilbert_fft_fir_compiler_1_0_chanpats[0];
  config.num_paths           = 1;
  config.data_width          = 16;
  config.data_fract_width    = 0;
  config.output_rounding_mode= XIP_FIR_CONVERGENT_EVEN;
  config.output_width        = 16;
  config.accum_width         = 33;
  config.output_fract_width  = 0;
  config.config_method       = XIP_FIR_CONFIG_SINGLE;
  return config;
}

const xip_fir_v7_2_config Hilbert_fft_fir_compiler_1_0_config = gen_Hilbert_fft_fir_compiler_1_0_config();

