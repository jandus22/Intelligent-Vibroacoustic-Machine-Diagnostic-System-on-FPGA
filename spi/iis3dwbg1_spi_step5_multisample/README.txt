IIS3DWBG1 SPI -> 16-bit AXI4-Stream TDM, etap 5
====================================================

Ten etap testuje wiele kolejnych próbek, a nie tylko pojedynczy zestaw XYZ.

Testowany strumień:
    X0 Y0 Z0 -> X1 Y1 Z1 -> ... -> X11 Y11 Z11

Model czujnika generuje:
    próbka n:
        X = 0x1000 + n
        Y = 0x8000 + n
        Z = 0xF000 + n

Testbench sprawdza:
- 12 kolejnych próbek,
- 36 kolejnych transferów 16-bitowych,
- stałą kolejność X -> Y -> Z,
- trzy okresy backpressure na różnych słowach,
- stabilność TDATA/TKEEP/TLAST przy TREADY=0,
- brak flagi tdm_overflow,
- poprawne liczniki próbek i słów.

DESIGN SOURCES
--------------
1. spi_master_byte_mode0.v
2. spi_register_access_mode0.v
3. iis3dwbg1_xyz.v
4. axis_xyz_tdm16.v
5. iis3dwbg1_tdm16.v

SIMULATION SOURCES
------------------
1. iis3dwbg1_sensor_model_multisample.v
2. tb_iis3dwbg1_tdm16_multisample.v

Ustaw jako Simulation Top:
    tb_iis3dwbg1_tdm16_multisample

Uruchom:
    run 2 ms

Oczekiwany wynik:
    PASS: 12 consecutive IIS3DWBG1 samples
    PASS: TDM order stayed X,Y,Z for all 36 words
    PASS: three backpressure intervals preserved AXI data
    PASS: tdm_overflow remained 0
    Last XYZ: X=0x100b Y=0x800b Z=0xf00b

Uwagi:
- m_axis_tlast pozostaje stale równy 0.
- m_axis_tkeep ma stale wartość 2'b11.
- serializer przechowuje jeden komplet XYZ w trzech rejestrach 16-bitowych.
- obecna wersja nie ma FIFO. Flaga tdm_overflow sygnalizuje, że odbiornik
  blokował strumień tak długo, iż nadeszła kolejna próbka z SPI.
