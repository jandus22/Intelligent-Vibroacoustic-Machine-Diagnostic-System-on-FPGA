`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2026 10:47:49 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module tb_top;

    // --- PARAMETRY ---
    parameter CLK_PERIOD = 10;          // 100 MHz
    parameter SAMPLE_PERIOD_US = 37.45; // 26.7 kHz (~37.45 us)
    parameter FFT_LEN = 1024;

    // --- SYGNAŁY ---
    reg clk = 0;
    reg aresetn = 0;
    
    // Interfejs wejściowy (udaje Twój SPI Master)
    reg [15:0] s_axis_tdata = 0;
    reg s_axis_tvalid = 0;
    wire s_axis_tready;
    reg s_axis_tlast = 0;

    // Interfejs wyjściowy (z FFT)
    wire [31:0] fft_x_out;
    wire [31:0] fft_y_out;
    wire [31:0] fft_z_out;
    wire m_axis_fft_tvalid;
    wire m_axis_fft_tlast;

    // --- GENERACJA ZEGARA ---
    always #(CLK_PERIOD/2) clk = ~clk;

    // --- INSTANCJA TWOJEGO PROJEKTU (WRAPPERA) ---
    // Musisz dopasować nazwy portów do swojego "Top Level"
    Hilbert_fft Hilbert_fft (
        .clk_100MHz        (clk),
        .aresetn           (aresetn),
        // Wejście (podpinasz pod pierwszy FIR)
        .s_axis_data_tdata (s_axis_tdata),
        .s_axis_data_tvalid(s_axis_tvalid),
        .s_axis_data_tready(s_axis_tready),
        .s_axis_data_tlast (s_axis_tlast),
        // Wyjście z FFT
        .fft_x_out         (fft_x_out),
        .fft_y_out         (fft_y_out),
        .fft_z_out         (fft_z_out)
        // Jeśli masz inne sygnały jak tvalid/tlast na wyjściu, dopisz je tu
    );

    // --- MATEMATYKA I SYMULACJA ---
    real pi = 3.1415926535;
    real freq_x = 1000.0; // 1 kHz
    real freq_y = 2000.0; // 2 kHz
    real freq_z = 3000.0; // 3 kHz
    real fs = 26700.0;
    real t = 0;

    initial begin
        $display("START SYMULACJI - Generowanie danych TDM dla 3 kanalow");
        
        // Reset systemu
        aresetn = 0;
        #(CLK_PERIOD * 10);
        aresetn = 1;
        #(CLK_PERIOD * 10);

        // Pętla główna: 1024 zestawy XYZ
        for (int i = 0; i < FFT_LEN; i++) begin
            
            t = i / fs; // Czas dla danej próbki

            // --- KANAŁ X ---
            @(posedge clk);
            s_axis_tvalid = 1;
            s_axis_tdata = $signed(16000.0 * $sin(2.0 * pi * freq_x * t)); 
            s_axis_tlast = 0;
            while(!s_axis_tready) @(posedge clk); // Handshake

            // --- KANAŁ Y ---
            @(posedge clk);
            s_axis_tdata = $signed(16000.0 * $sin(2.0 * pi * freq_y * t)); 
            while(!s_axis_tready) @(posedge clk);

            // --- KANAŁ Z ---
            @(posedge clk);
            if (i == FFT_LEN - 1) s_axis_tlast = 1; // TLAST tylko na samym końcu bloku 3072
            s_axis_tdata = $signed(16000.0 * $sin(2.0 * pi * freq_z * t)); 
            while(!s_axis_tready) @(posedge clk);
            
            // Ustawiamy TLAST tylko dla ostatniej próbki całego bloku
            if (i == FFT_LEN - 1) 
                s_axis_tlast <= 1;
            else 
                s_axis_tlast <= 0;
            
            do begin
                @(posedge clk);
            end while (!s_axis_tready);
            
            // Koniec paczki XYZ, czekamy na kolejny odczyt z akcelerometru
            s_axis_tvalid = 0;
            s_axis_tlast = 0;
            
            // Symulacja przerwy między odczytami SPI (~37 us)
            #(SAMPLE_PERIOD_US * 1000); 
        end

        $display("DANE WYSLANE. Czekam na wynik z FFT...");
        
        // Czekamy aż FFT zacznie wypluwać dane
        wait(m_axis_fft_tvalid);
        #(CLK_PERIOD * 5000); // Pozwól mu wypluć widmo
        
        $display("SYMULACJA ZAKONCZONA");
        $finish;
    end

endmodule
