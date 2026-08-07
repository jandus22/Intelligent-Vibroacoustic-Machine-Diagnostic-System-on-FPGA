set_property SRC_FILE_INFO {cfile:/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/spi/spi_true/spi_accelerometer_true/spi_accelerometer_true.gen/sources_1/bd/dma_system/ip/dma_system_rst_ps8_0_99M_1/dma_system_rst_ps8_0_99M_1_ooc.xdc rfile:../../../../../spi_accelerometer_true.gen/sources_1/bd/dma_system/ip/dma_system_rst_ps8_0_99M_1/dma_system_rst_ps8_0_99M_1_ooc.xdc id:1 order:EARLY scoped_inst:U0} [current_design]
set_property SRC_FILE_INFO {cfile:/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/spi/spi_true/spi_accelerometer_true/spi_accelerometer_true.runs/dma_system_rst_ps8_0_99M_1_synth_1/dont_touch.xdc rfile:../../../dont_touch.xdc id:2} [current_design]
set_property SRC_FILE_INFO {cfile:/home/kuszman/Xilinx/2025.2/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_single.tcl rfile:../../../../../../../../../../Xilinx/2025.2/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_single.tcl id:3 order:LATE scoped_inst:U0/EXT_LPF/ACTIVE_LOW_AUX.ACT_LO_AUX unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/home/kuszman/Xilinx/2025.2/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_single.tcl rfile:../../../../../../../../../../Xilinx/2025.2/data/ip/xpm/xpm_cdc/tcl/xpm_cdc_single.tcl id:4 order:LATE scoped_inst:U0/EXT_LPF/ACTIVE_LOW_EXT.ACT_LO_EXT unmanaged:yes} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:55 export:INPUT save:INPUT read:FILTER_OUT_OF_CONTEXT} [current_design]
create_clock -period 10.000 -name slowest_sync_clk [get_ports slowest_sync_clk]
set_property src_info {type:XDC file:2 line:9 export:INPUT save:INPUT read:READ} [current_design]
set_property KEEP_HIERARCHY SOFT [get_cells U0]
current_instance U0/EXT_LPF/ACTIVE_LOW_AUX.ACT_LO_AUX
set_property src_info {type:SCOPED_XDC file:3 line:5 export:INPUT save:NONE read:READ} [current_design]
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
current_instance
current_instance U0/EXT_LPF/ACTIVE_LOW_EXT.ACT_LO_EXT
set_property src_info {type:SCOPED_XDC file:4 line:5 export:INPUT save:NONE read:READ} [current_design]
set_false_path -to [get_cells {syncstages_ff_reg[0]}]
