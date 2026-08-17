# 2026-08-12T07:30:32.467345909
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="spi_dma_platform")
status = platform.build()

comp = client.get_component(name="spi_dma_s2mm_test")
comp.build()

vitis.dispose()

