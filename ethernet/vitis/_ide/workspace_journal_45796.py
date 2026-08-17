# 2026-07-29T09:03:20.964174799
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.get_component(name="eth_platform")
domain = platform.get_domain(name="lwip_domain")

status = domain.set_config(option = "lib", param = "lwip220_temac_phy_link_speed", value = "CONFIG_LINKSPEED_AUTODETECT", lib_name="lwip220")

status = domain.set_config(option = "lib", param = "lwip220_temac_phy_link_speed", value = "CONFIG_LINKSPEED1000", lib_name="lwip220")

status = platform.build()

comp = client.get_component(name="udp_app")
status = comp.clean()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

status = client.set_embedded_sw_repo(level="LOCAL", path=["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/local_sw_repo"])

status = domain.regenerate()

status = platform.build()

status = comp.clean()

status = platform.build()

comp.build()

<<<<<<< Updated upstream
status = comp.clean()

status = platform.build()

comp.build()

=======
>>>>>>> Stashed changes
status = platform.build()

comp.build()

vitis.dispose()

