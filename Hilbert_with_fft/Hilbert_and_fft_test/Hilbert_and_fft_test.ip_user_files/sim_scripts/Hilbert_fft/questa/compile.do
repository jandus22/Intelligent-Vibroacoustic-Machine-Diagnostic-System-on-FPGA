vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xbip_utils_v3_0_15
vlib questa_lib/msim/axi_utils_v2_0_11
vlib questa_lib/msim/xbip_pipe_v3_0_11
vlib questa_lib/msim/fir_compiler_v7_2_26
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/c_reg_fd_v12_0_11
vlib questa_lib/msim/xbip_dsp48_wrapper_v3_0_7
vlib questa_lib/msim/c_addsub_v12_0_21
vlib questa_lib/msim/mult_gen_v12_0_24
vlib questa_lib/msim/cordic_v6_0_25
vlib questa_lib/msim/axis_infrastructure_v1_1_1
vlib questa_lib/msim/axis_register_slice_v1_1_35
vlib questa_lib/msim/axis_subset_converter_v1_1_36
vlib questa_lib/msim/c_shift_ram_v12_0_20
vlib questa_lib/msim/floating_point_v7_1_21
vlib questa_lib/msim/cmpy_v6_0_27
vlib questa_lib/msim/xfft_v9_1_15
vlib questa_lib/msim/xlconstant_v1_1_10
vlib questa_lib/msim/xlslice_v1_0_5

vmap xbip_utils_v3_0_15 questa_lib/msim/xbip_utils_v3_0_15
vmap axi_utils_v2_0_11 questa_lib/msim/axi_utils_v2_0_11
vmap xbip_pipe_v3_0_11 questa_lib/msim/xbip_pipe_v3_0_11
vmap fir_compiler_v7_2_26 questa_lib/msim/fir_compiler_v7_2_26
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap c_reg_fd_v12_0_11 questa_lib/msim/c_reg_fd_v12_0_11
vmap xbip_dsp48_wrapper_v3_0_7 questa_lib/msim/xbip_dsp48_wrapper_v3_0_7
vmap c_addsub_v12_0_21 questa_lib/msim/c_addsub_v12_0_21
vmap mult_gen_v12_0_24 questa_lib/msim/mult_gen_v12_0_24
vmap cordic_v6_0_25 questa_lib/msim/cordic_v6_0_25
vmap axis_infrastructure_v1_1_1 questa_lib/msim/axis_infrastructure_v1_1_1
vmap axis_register_slice_v1_1_35 questa_lib/msim/axis_register_slice_v1_1_35
vmap axis_subset_converter_v1_1_36 questa_lib/msim/axis_subset_converter_v1_1_36
vmap c_shift_ram_v12_0_20 questa_lib/msim/c_shift_ram_v12_0_20
vmap floating_point_v7_1_21 questa_lib/msim/floating_point_v7_1_21
vmap cmpy_v6_0_27 questa_lib/msim/cmpy_v6_0_27
vmap xfft_v9_1_15 questa_lib/msim/xfft_v9_1_15
vmap xlconstant_v1_1_10 questa_lib/msim/xlconstant_v1_1_10
vmap xlslice_v1_0_5 questa_lib/msim/xlslice_v1_0_5

vcom -work xbip_utils_v3_0_15 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/fb6f/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_11 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/c6be/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_11 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/6a79/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work fir_compiler_v7_2_26 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/655f/hdl/fir_compiler_v7_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir_compiler_0_0/sim/Hilbert_fft_fir_compiler_0_0.vhd" \

vcom -work c_reg_fd_v12_0_11 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/0ff7/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_7 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/9bc6/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_21 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/ed70/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_24 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/6d7a/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work cordic_v6_0_25 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/32c3/hdl/cordic_v6_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_0_0/sim/Hilbert_fft_cordic_0_0.vhd" \

vlog -work axis_infrastructure_v1_1_1 -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_register_slice_v1_1_35 -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/be12/hdl/axis_register_slice_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tdata_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tuser_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tstrb_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tkeep_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tid_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tdest_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tlast_Hilbert_fft_axis_subset_converter_0_0.v" \

vlog -work axis_subset_converter_v1_1_36 -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/5e96/hdl/axis_subset_converter_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/top_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/sim/Hilbert_fft_axis_subset_converter_0_0.v" \

vcom -work c_shift_ram_v12_0_20 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/89b5/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \

vcom -work floating_point_v7_1_21 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/c90d/hdl/floating_point_v7_1_vh_rfs.vhd" \

vcom -work cmpy_v6_0_27 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/c96a/hdl/cmpy_v6_0_vh_rfs.vhd" \

vcom -work xfft_v9_1_15 -64 -2008  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/5ee3/hdl/xfft_v9_1_vh08_rfs.vhd" \

vcom -work xfft_v9_1_15 -64 -93  \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/5ee3/hdl/xfft_v9_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xfft_0_0/sim/Hilbert_fft_xfft_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_TDM_to_Parallel_Conv_0_0/sim/Hilbert_fft_TDM_to_Parallel_Conv_0_0.v" \

vlog -work xlconstant_v1_1_10 -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/a165/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlconstant_0_0/sim/Hilbert_fft_xlconstant_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlconstant_1_0/sim/Hilbert_fft_xlconstant_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_brancher_0_0/sim/Hilbert_fft_brancher_0_0.v" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_1_3/sim/Hilbert_fft_cordic_1_3.vhd" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_1_4/sim/Hilbert_fft_cordic_1_4.vhd" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_1_5/sim/Hilbert_fft_cordic_1_5.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir0_spy_0_2/sim/Hilbert_fft_fir0_spy_0_2.v" \

vlog -work xlslice_v1_0_5 -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/6792/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlslice_0_0/sim/Hilbert_fft_xlslice_0_0.v" \
"../../../bd/Hilbert_fft/sim/Hilbert_fft.v" \

vcom -work xil_defaultlib -64 -93  \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir_compiler_1_0/sim/Hilbert_fft_fir_compiler_1_0.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlslice_1_0/sim/Hilbert_fft_xlslice_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlslice_1_1/sim/Hilbert_fft_xlslice_1_1.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir0_spy_1_0/sim/Hilbert_fft_fir0_spy_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir0_spy_1_1/sim/Hilbert_fft_fir0_spy_1_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

