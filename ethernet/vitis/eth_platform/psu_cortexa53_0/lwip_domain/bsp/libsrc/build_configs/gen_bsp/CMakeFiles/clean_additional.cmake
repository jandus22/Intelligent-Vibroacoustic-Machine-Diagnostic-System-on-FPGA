# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/lwipopts.h"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/sleep.h"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xemac_ieee_reg.h"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xemacpsif_hw.h"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xiltimer.h"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xlwipconfig.h"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/include/xtimer_config.h"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/lib/liblwip220.a"
  "/home/janecki/workspace_vitis/eth_platform/psu_cortexa53_0/lwip_domain/bsp/lib/libxiltimer.a"
  )
endif()
