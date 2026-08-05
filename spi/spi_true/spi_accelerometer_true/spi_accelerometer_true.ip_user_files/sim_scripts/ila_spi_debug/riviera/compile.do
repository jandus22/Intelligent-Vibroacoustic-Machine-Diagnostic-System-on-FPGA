transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../../../../../../../Xilinx/2025.2/data/rsb/busdef" "+incdir+../../../../spi_accelerometer_true.gen/sources_1/ip/ila_spi_debug/hdl/verilog" -l xpm -l xil_defaultlib \
"/home/kuszman/Xilinx/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/kuszman/Xilinx/2025.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"/home/kuszman/Xilinx/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../../../../Xilinx/2025.2/data/rsb/busdef" "+incdir+../../../../spi_accelerometer_true.gen/sources_1/ip/ila_spi_debug/hdl/verilog" -l xpm -l xil_defaultlib \
"../../../../spi_accelerometer_true.gen/sources_1/ip/ila_spi_debug/sim/ila_spi_debug.v" \

vlog -work xil_defaultlib \
"glbl.v"

