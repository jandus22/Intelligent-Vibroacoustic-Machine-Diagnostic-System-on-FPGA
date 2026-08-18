# KR260 standalone IIS3DWBG1 hardware test
# Target: KR260 carrier Rev A02 / K26 SOM

# Carrier-board 25 MHz programmable clock
set_property PACKAGE_PIN C3 [get_ports clk_25mhz]
set_property IOSTANDARD LVCMOS18 [get_ports clk_25mhz]
create_clock -name clk_25mhz -period 40.000 [get_ports clk_25mhz]

# PMOD1 connector J2.
#
# Physical numbering:
#
# Upper row:  1, 3, 5, 7, 9, 11
# Lower row:  2, 4, 6, 8, 10, 12
#
# This design uses the four signal pins in the lower row:
#
# J2.2 -> CS_n
# J2.4 -> MOSI / sensor SDI / SDA
# J2.6 -> MISO / sensor SDO / SDO-SA0
# J2.8 -> SCLK / sensor SPC / SCL

# PMOD1 physical pin 2
set_property PACKAGE_PIN B10 [get_ports spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports spi_cs_n]
set_property DRIVE 4 [get_ports spi_cs_n]
set_property SLEW SLOW [get_ports spi_cs_n]

# PMOD1 physical pin 4
set_property PACKAGE_PIN E12 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]
set_property DRIVE 4 [get_ports spi_mosi]
set_property SLEW SLOW [get_ports spi_mosi]

# PMOD1 physical pin 6
set_property PACKAGE_PIN D11 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]

# PMOD1 physical pin 8
set_property PACKAGE_PIN B11 [get_ports spi_sclk]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sclk]
set_property DRIVE 4 [get_ports spi_sclk]
set_property SLEW SLOW [get_ports spi_sclk]

# Initial bring-up timing exceptions
set_false_path -from [get_ports spi_miso]
set_false_path -to [get_ports {spi_cs_n spi_mosi spi_sclk}]