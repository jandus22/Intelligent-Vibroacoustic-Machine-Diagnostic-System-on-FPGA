# 2026-08-06T09:39:17.114843556
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.create_platform_component(name = "spi_dma_platform",hw_design = "$COMPONENT_LOCATION/../../export/iis3dwbg1_dma.xsa",os = "standalone",cpu = "psu_cortexa53_0",domain_name = "standalone_psu_cortexa53_0",architecture = "64-bit",compiler = "gcc")

platform = client.get_component(name="spi_dma_platform")
status = platform.build()

comp = client.create_app_component(name="spi_dma_s2mm_test",platform = "$COMPONENT_LOCATION/../spi_dma_platform/export/spi_dma_platform/spi_dma_platform.xpfm",domain = "standalone_psu_cortexa53_0")

status = platform.build()

comp = client.get_component(name="spi_dma_s2mm_test")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

status = comp.clean()

status = platform.build()

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../export/iis3dwbg1_dma.xsa")

status = platform.build()

status = comp.clean()

status = platform.build()

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

