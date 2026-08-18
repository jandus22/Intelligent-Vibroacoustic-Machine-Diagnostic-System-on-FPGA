# Etap 6 setup script.
# Run this script in the Tcl Console of an OPEN Vivado project targeting KR260.
#
# Example:
#   cd /home/user/Downloads/iis3dwbg1_spi_step6_kr260_hw
#   source setup_step6_in_current_project.tcl

set script_dir [file normalize [file dirname [info script]]]

puts "INFO: Adding IIS3DWBG1 design sources from $script_dir"

set rtl_files [list \
    "$script_dir/spi_master_byte_mode0.v" \
    "$script_dir/spi_register_access_mode0.v" \
    "$script_dir/iis3dwbg1_xyz.v" \
    "$script_dir/axis_xyz_tdm16.v" \
    "$script_dir/iis3dwbg1_tdm16.v" \
    "$script_dir/iis3dwbg1_kr260_hw_top.v" \
]

foreach rtl_file $rtl_files {
    if {![file exists $rtl_file]} {
        error "Missing RTL file: $rtl_file"
    }

    # Replace files from earlier stages that have the same filename/module.
    set rtl_norm [file normalize $rtl_file]
    set rtl_base [file tail $rtl_file]
    foreach existing_file [get_files -quiet "*$rtl_base"] {
        set existing_norm [file normalize $existing_file]
        if {$existing_norm ne $rtl_norm} {
            puts "INFO: Removing older source: $existing_file"
            remove_files $existing_file
        }
    }

    if {[llength [get_files -quiet $rtl_norm]] == 0} {
        add_files -norecurse $rtl_norm
    }
}

set xdc_file "$script_dir/kr260_pmod1_spi.xdc"
if {![file exists $xdc_file]} {
    error "Missing constraints file: $xdc_file"
}
if {[llength [get_files -quiet $xdc_file]] == 0} {
    add_files -fileset constrs_1 -norecurse $xdc_file
}

# Create the ILA only once.
if {[llength [get_ips -quiet ila_spi_debug]] == 0} {
    create_ip \
        -name ila \
        -vendor xilinx.com \
        -library ip \
        -module_name ila_spi_debug
}

set_property -dict [list \
    CONFIG.C_DATA_DEPTH       {4096} \
    CONFIG.C_NUM_OF_PROBES    {12} \
    CONFIG.C_PROBE0_WIDTH     {8} \
    CONFIG.C_PROBE1_WIDTH     {4} \
    CONFIG.C_PROBE2_WIDTH     {16} \
    CONFIG.C_PROBE3_WIDTH     {16} \
    CONFIG.C_PROBE4_WIDTH     {16} \
    CONFIG.C_PROBE5_WIDTH     {16} \
    CONFIG.C_PROBE6_WIDTH     {1} \
    CONFIG.C_PROBE7_WIDTH     {32} \
    CONFIG.C_PROBE8_WIDTH     {32} \
    CONFIG.C_PROBE9_WIDTH     {32} \
    CONFIG.C_PROBE10_WIDTH    {1} \
    CONFIG.C_PROBE11_WIDTH    {1} \
    CONFIG.C_ADV_TRIGGER      {true} \
] [get_ips ila_spi_debug]

generate_target all [get_ips ila_spi_debug]
catch {
    export_ip_user_files \
        -of_objects [get_ips ila_spi_debug] \
        -no_script \
        -sync \
        -force \
        -quiet
}

set_property top iis3dwbg1_kr260_hw_top [current_fileset]
update_compile_order -fileset sources_1

puts ""
puts "============================================================"
puts "STEP 6 READY"
puts "Top: iis3dwbg1_kr260_hw_top"
puts "Clock: KR260 HPA_CLK0P_CLK, 25 MHz"
puts "SPI: PMOD1 pins 1..4"
puts "Next: Run Synthesis -> Run Implementation -> Generate Bitstream"
puts "============================================================"
