# 2026-08-12T09:24:18.690638371
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="spi_dma_platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../spi_accelerometer_true/iis3dwbg1_kr260_hw_top.xsa")

status = platform.build()

status = platform.build()

comp = client.get_component(name="spi_dma_s2mm_test")
comp.build()

status = comp.clean()

status = platform.build()

comp.build()

vitis.dispose()

