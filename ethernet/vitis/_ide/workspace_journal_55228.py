# 2026-07-16T08:25:53.327601127
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

status = platform.build()

comp = client.get_component(name="dma_test_app")
comp.build()

status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

status = platform.build()

comp = client.get_component(name="dma_test_app")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../project_1/ethernet_wrapper.xsa")

status = platform.build()

status = platform.build()

comp.build()

status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

status = platform.build()

comp = client.get_component(name="dma_test_app")
comp.build()

vitis.dispose()

