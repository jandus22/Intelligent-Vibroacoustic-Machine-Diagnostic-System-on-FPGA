onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib ila_spi_debug_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {ila_spi_debug.udo}

run 1000ns

quit -force
