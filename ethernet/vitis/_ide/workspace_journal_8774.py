# 2026-07-10T09:34:43.933549592
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

comp = client.get_component(name="dma_test_app")
comp.build()

vitis.dispose()

