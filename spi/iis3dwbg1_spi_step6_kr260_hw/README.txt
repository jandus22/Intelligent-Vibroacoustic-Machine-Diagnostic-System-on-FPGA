IIS3DWBG1 SPI -> TDM16 -> KR260 hardware test, etap 6
==========================================================

CEL
---
To jest samodzielny projekt sprzętowy do uruchomienia kontrolera SPI na
KR260 bez procesora, DMA, grayboxa i Ethernetu.

Tor:
    IIS3DWBG1
        -> SPI 4-przewodowe
        -> komplet XYZ
        -> TDM 16 bit: X, Y, Z
        -> ILA

ZEGAR
-----
Top korzysta bezpośrednio z zegara HPA_CLK0P_CLK 25 MHz dostępnego
na płytce KR260. Nie trzeba uruchamiać aplikacji w Vitis ani zegara z PS.

SPI pracuje z częstotliwością 6.25 MHz:
    25 MHz / (2 * 2) = 6.25 MHz

PLIKI
-----
Design Sources:
- spi_master_byte_mode0.v
- spi_register_access_mode0.v
- iis3dwbg1_xyz.v
- axis_xyz_tdm16.v
- iis3dwbg1_tdm16.v
- iis3dwbg1_kr260_hw_top.v

Constraints:
- kr260_pmod1_spi.xdc

Setup:
- setup_step6_in_current_project.tcl

URUCHOMIENIE W VIVADO
---------------------
1. Otwórz projekt utworzony dla KR260.
2. W Tcl Console wykonaj:

       cd /home/kuszman/Downloads/iis3dwbg1_spi_step6_kr260_hw
       source setup_step6_in_current_project.tcl

3. Skrypt:
   - doda wszystkie źródła,
   - doda XDC,
   - utworzy ILA,
   - ustawi iis3dwbg1_kr260_hw_top jako top.

4. Uruchom:
   - Run Synthesis,
   - Run Implementation,
   - Generate Bitstream.

5. Po podłączeniu czujnika:
   - Open Hardware Manager,
   - Program Device,
   - otwórz hw_ila_1 / ILA,
   - ustaw trigger np. probe6 == 1, czyli m_axis_tvalid.

PMOD1
-----
Standardowy układ SPI:

    PMOD1 pin 1 -> spi_cs_n -> CS czujnika
    PMOD1 pin 2 -> spi_mosi -> SDI czujnika
    PMOD1 pin 3 -> spi_miso <- SDO czujnika
    PMOD1 pin 4 -> spi_sclk -> SPC czujnika
    PMOD1 pin 5 -> GND
    PMOD1 pin 6 -> 3.3 V

Nie podłączaj zasilania przy włączonej płytce. Najpierw wyłącz KR260.

ILA – PROBES
------------
probe0  [7:0]  WHO_AM_I
probe1  [3:0]  status:
                 bit 3 = tdm_overflow
                 bit 2 = sensor_error
                 bit 1 = configured
                 bit 0 = sensor_ok
probe2  [15:0] X
probe3  [15:0] Y
probe4  [15:0] Z
probe5  [15:0] TDM data
probe6          TDM valid
probe7  [31:0] licznik próbek odebranych z SPI
probe8  [31:0] licznik pełnych zestawów TDM
probe9  [31:0] licznik słów TDM
probe10         CS_n
probe11         SCLK

OCZEKIWANY STAN PO PODŁĄCZENIU
------------------------------
probe0 = 0x7B
probe1 = 0b0011
probe7 rośnie
probe8 rośnie
probe9 rośnie trzy razy szybciej niż probe8
probe5 pokazuje kolejno X, Y, Z przy impulsach probe6

BEZ CZUJNIKA
------------
Po zaprogramowaniu bez podłączonego czujnika WHO_AM_I będzie niepoprawne,
a sensor_error zostanie ustawiony. Jest to oczekiwane. Po podłączeniu
czujnika trzeba ponownie zaprogramować bitstream albo zresetować płytkę,
ponieważ obecny sterownik zatrzymuje się po błędnym WHO_AM_I.

UWAGA O XDC
-----------
Plik XDC jest przygotowany dla standardowego mapowania PMOD1 na
KR260 carrier Rev A02. Przed finalną integracją z głównym projektem
warto porównać mapowanie z board files zainstalowanymi w używanej
wersji Vivado.
