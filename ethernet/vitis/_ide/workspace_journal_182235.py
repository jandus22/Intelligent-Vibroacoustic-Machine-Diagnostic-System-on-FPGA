# 2026-07-20T11:17:27.841244709
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

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld"])

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld"])

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld"])

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld"])

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src"])

status = platform.build()

comp.build()

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld"])

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld"])

comp.set_app_config(key = "USER_LINKER_SCRIPT", values = ["/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld"])

component = client.get_component(name="udp_app")

lscript = component.get_ld_script(path="/home/kuszman/Magisterka/Intelligent-Vibroacoustic-Machine-Diagnostic-System-on-FPGA/ethernet/vitis/udp_app/src/lscript.ld")

lscript.regenerate()

status = platform.build()

comp.build()

lscript.regenerate()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

vitis.dispose()

