# 2026-07-27T09:44:33.418710855
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

