# 2026-08-12T08:53:54.354916470
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

vitis.dispose()

