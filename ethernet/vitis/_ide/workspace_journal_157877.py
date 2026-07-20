# 2026-07-20T10:25:58.057035255
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

comp = client.get_component(name="dma_test_app")
comp.build()

status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

component = client.get_component(name="udp_app")

lscript = component.get_ld_script(path="/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld")

lscript.regenerate()

status = platform.build()

comp.build()

status = platform.build()

comp = client.get_component(name="dma_test_app")
comp.build()

status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

