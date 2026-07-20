# 2026-07-20T11:58:51.197469579
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

status = comp.clean()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

