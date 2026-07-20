# 2026-07-10T09:23:09.209845558
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
status = platform.build()

status = platform.build()

comp = client.get_component(name="udp_app")
comp.build()

vitis.dispose()

