# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/lwipopts.h"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/sleep.h"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xemac_ieee_reg.h"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xemacpsif_hw.h"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xiltimer.h"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xlwipconfig.h"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xtimer_config.h"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/lib/liblwip220.a"
  "/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/lib/libxiltimer.a"
  )
endif()
