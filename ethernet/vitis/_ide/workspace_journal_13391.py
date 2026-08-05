# 2026-07-27T12:28:25.903592840
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

vitis.dispose()

