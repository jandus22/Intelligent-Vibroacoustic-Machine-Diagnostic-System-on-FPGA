transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xbip_utils_v3_0_15
vlib riviera/axi_utils_v2_0_11
vlib riviera/xbip_pipe_v3_0_11
vlib riviera/fir_compiler_v7_2_26
vlib riviera/xil_defaultlib
vlib riviera/c_reg_fd_v12_0_11
vlib riviera/xbip_dsp48_wrapper_v3_0_7
vlib riviera/c_addsub_v12_0_21
vlib riviera/mult_gen_v12_0_24
vlib riviera/cordic_v6_0_25
vlib riviera/axis_infrastructure_v1_1_1
vlib riviera/axis_register_slice_v1_1_35
vlib riviera/axis_subset_converter_v1_1_36
vlib riviera/c_shift_ram_v12_0_20
vlib riviera/floating_point_v7_1_21
vlib riviera/cmpy_v6_0_27
vlib riviera/xfft_v9_1_15
vlib riviera/xlconstant_v1_1_10
vlib riviera/xlslice_v1_0_5

vmap xbip_utils_v3_0_15 riviera/xbip_utils_v3_0_15
vmap axi_utils_v2_0_11 riviera/axi_utils_v2_0_11
vmap xbip_pipe_v3_0_11 riviera/xbip_pipe_v3_0_11
vmap fir_compiler_v7_2_26 riviera/fir_compiler_v7_2_26
vmap xil_defaultlib riviera/xil_defaultlib
vmap c_reg_fd_v12_0_11 riviera/c_reg_fd_v12_0_11
vmap xbip_dsp48_wrapper_v3_0_7 riviera/xbip_dsp48_wrapper_v3_0_7
vmap c_addsub_v12_0_21 riviera/c_addsub_v12_0_21
vmap mult_gen_v12_0_24 riviera/mult_gen_v12_0_24
vmap cordic_v6_0_25 riviera/cordic_v6_0_25
vmap axis_infrastructure_v1_1_1 riviera/axis_infrastructure_v1_1_1
vmap axis_register_slice_v1_1_35 riviera/axis_register_slice_v1_1_35
vmap axis_subset_converter_v1_1_36 riviera/axis_subset_converter_v1_1_36
vmap c_shift_ram_v12_0_20 riviera/c_shift_ram_v12_0_20
vmap floating_point_v7_1_21 riviera/floating_point_v7_1_21
vmap cmpy_v6_0_27 riviera/cmpy_v6_0_27
vmap xfft_v9_1_15 riviera/xfft_v9_1_15
vmap xlconstant_v1_1_10 riviera/xlconstant_v1_1_10
vmap xlslice_v1_0_5 riviera/xlslice_v1_0_5

vcom -work xbip_utils_v3_0_15 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/fb6f/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_11 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/c6be/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_11 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/6a79/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work fir_compiler_v7_2_26 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/655f/hdl/fir_compiler_v7_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir_compiler_0_0/sim/Hilbert_fft_fir_compiler_0_0.vhd" \

vcom -work c_reg_fd_v12_0_11 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/0ff7/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_7 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/9bc6/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_21 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/ed70/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_24 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/6d7a/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work cordic_v6_0_25 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/32c3/hdl/cordic_v6_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_0_0/sim/Hilbert_fft_cordic_0_0.vhd" \

vlog -work axis_infrastructure_v1_1_1  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_register_slice_v1_1_35  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/be12/hdl/axis_register_slice_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tdata_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tuser_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tstrb_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tkeep_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tid_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tdest_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/tlast_Hilbert_fft_axis_subset_converter_0_0.v" \

vlog -work axis_subset_converter_v1_1_36  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/5e96/hdl/axis_subset_converter_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/hdl/top_Hilbert_fft_axis_subset_converter_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_0_0/sim/Hilbert_fft_axis_subset_converter_0_0.v" \

vcom -work c_shift_ram_v12_0_20 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/89b5/hdl/c_shift_ram_v12_0_vh_rfs.vhd" \

vcom -work floating_point_v7_1_21 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/c90d/hdl/floating_point_v7_1_vh_rfs.vhd" \

vcom -work cmpy_v6_0_27 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/c96a/hdl/cmpy_v6_0_vh_rfs.vhd" \

vcom -work xfft_v9_1_15 -2008  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/5ee3/hdl/xfft_v9_1_vh08_rfs.vhd" \

vcom -work xfft_v9_1_15 -93  -incr \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/5ee3/hdl/xfft_v9_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xfft_0_0/sim/Hilbert_fft_xfft_0_0.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_TDM_to_Parallel_Conv_0_0/sim/Hilbert_fft_TDM_to_Parallel_Conv_0_0.v" \

vlog -work xlconstant_v1_1_10  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/a165/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlconstant_0_0/sim/Hilbert_fft_xlconstant_0_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlconstant_1_0/sim/Hilbert_fft_xlconstant_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_brancher_0_0/sim/Hilbert_fft_brancher_0_0.v" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_1_3/sim/Hilbert_fft_cordic_1_3.vhd" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_1_4/sim/Hilbert_fft_cordic_1_4.vhd" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_cordic_1_5/sim/Hilbert_fft_cordic_1_5.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir0_spy_0_2/sim/Hilbert_fft_fir0_spy_0_2.v" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir_compiler_1_0/sim/Hilbert_fft_fir_compiler_1_0.vhd" \

vlog -work xlslice_v1_0_5  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/6792/hdl/xlslice_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../Hilbert_and_fft_test.gen/sources_1/bd/Hilbert_fft/ipshared/434f/hdl" "+incdir+../../../../../../../../2025.2/data/rsb/busdef" -l xbip_utils_v3_0_15 -l axi_utils_v2_0_11 -l xbip_pipe_v3_0_11 -l fir_compiler_v7_2_26 -l xil_defaultlib -l c_reg_fd_v12_0_11 -l xbip_dsp48_wrapper_v3_0_7 -l c_addsub_v12_0_21 -l mult_gen_v12_0_24 -l cordic_v6_0_25 -l axis_infrastructure_v1_1_1 -l axis_register_slice_v1_1_35 -l axis_subset_converter_v1_1_36 -l c_shift_ram_v12_0_20 -l floating_point_v7_1_21 -l cmpy_v6_0_27 -l xfft_v9_1_15 -l xlconstant_v1_1_10 -l xlslice_v1_0_5 \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlslice_1_0/sim/Hilbert_fft_xlslice_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_xlslice_1_1/sim/Hilbert_fft_xlslice_1_1.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir0_spy_1_0/sim/Hilbert_fft_fir0_spy_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_fir0_spy_1_1/sim/Hilbert_fft_fir0_spy_1_1.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/tdata_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/tuser_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/tstrb_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/tkeep_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/tid_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/tdest_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/tlast_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/hdl/top_Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/ip/Hilbert_fft_axis_subset_converter_1_0/sim/Hilbert_fft_axis_subset_converter_1_0.v" \
"../../../bd/Hilbert_fft/sim/Hilbert_fft.v" \

vlog -work xil_defaultlib \
"glbl.v"

