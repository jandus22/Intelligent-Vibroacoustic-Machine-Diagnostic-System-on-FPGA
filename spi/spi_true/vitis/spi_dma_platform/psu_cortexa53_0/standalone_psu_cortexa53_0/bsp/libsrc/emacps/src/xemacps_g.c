#include "xemacps.h"

XEmacPs_Config XEmacPs_ConfigTable[] __attribute__ ((section (".drvcfg_sec"))) = {

	{
		"xlnx,zynqmp-gem", /* compatible */
		0xff0c0000, /* reg */
		0x0, /* dma-coherent */
		0x403b, /* interrupts */
		0xf9010000, /* interrupt-parent */
		0x2e, /* clocks */
		"rgmii-id", /* phy-mode */
		0x0, /* phy-handle */
		0x0, /* mdioproducer-baseaddr */
		0x0 /* gmiitorgmii-addr */
	},
	 {
		 NULL
	}
};