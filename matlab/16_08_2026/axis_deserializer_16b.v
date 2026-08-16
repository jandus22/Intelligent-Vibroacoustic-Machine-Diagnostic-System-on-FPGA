`timescale 1ns / 1ps

module axis_deserializer_16b (
    input  wire        clk,
    input  wire        ce, 

    // ---------------------------------------------------
    // WEJŚCIE (Slave) - Dane szeregowe 16-bit z FIR
    // ---------------------------------------------------
    input  wire [15:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    input  wire        s_axis_tlast,
    output wire        s_axis_tready,

    // ---------------------------------------------------
    // WYJŚCIE (Master) - 3 oddzielne kanały danych, 
    // zsynchronizowane jednym TVALID / TREADY
    // ---------------------------------------------------
    output wire [15:0] m_data_x,
    output wire [15:0] m_data_y,
    output wire [15:0] m_data_z,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready
);

    // Rejestry przechowujące poszczególne próbki 16-bitowe z wartościami początkowymi
    reg [15:0] reg_x = 16'd0;
    reg [15:0] reg_y = 16'd0;
    reg [15:0] reg_z = 16'd0;
    
    reg [1:0]  word_counter  = 2'd0;
    reg        valid_out_reg = 1'b0;

    // Jesteśmy gotowi przyjąć nowe dane (s_tready = 1) jeśli:
    // a) nie mamy nic do wystawienia na wyjściu (~valid_out_reg)
    // b) mamy coś do wystawienia, ale odbiorca właśnie to akceptuje (m_axis_tready = 1)
    assign s_axis_tready = (~valid_out_reg) | m_axis_tready;

    always @(posedge clk) begin
        
        // Opuszczenie flagi TVALID po udanym przesłaniu paczki (gdy odbiorca potwierdzi TREADY)
        if (valid_out_reg && m_axis_tready) begin
            valid_out_reg <= 1'b0;
        end

        // Kiedy przychodzą ważne dane wejściowe
        if (s_axis_tvalid && s_axis_tready) begin
            
            if (s_axis_tlast) begin
                // Flaga TLAST oznacza ostatnią próbkę (Z). 
                // Zapisujemy ją i dajemy znać, że cała trójka jest gotowa.
                reg_z         <= s_axis_tdata;
                valid_out_reg <= 1'b1;
                word_counter  <= 2'd0; // Reset licznika
            end else begin
                // Zwykłe próbki bez TLAST (X oraz Y)
                case (word_counter)
                    2'd0: begin 
                        reg_x <= s_axis_tdata; 
                        word_counter <= 2'd1; 
                    end
                    2'd1: begin 
                        reg_y <= s_axis_tdata; 
                        word_counter <= 2'd2; 
                    end
                    2'd2: begin 
                        // Zabezpieczenie: jeśli TLAST by nie przyszedł, traktujemy 
                        // trzecią próbkę jako końcową i wystawiamy całą paczkę.
                        reg_z <= s_axis_tdata;
                        valid_out_reg <= 1'b1;
                        word_counter <= 2'd0;
                    end
                endcase
            end
        end
    end

    // Przypisanie wewnętrznych rejestrów do oddzielnych wyjść
    assign m_data_x      = reg_x;
    assign m_data_y      = reg_y;
    assign m_data_z      = reg_z;
    assign m_axis_tvalid = valid_out_reg;

endmodule