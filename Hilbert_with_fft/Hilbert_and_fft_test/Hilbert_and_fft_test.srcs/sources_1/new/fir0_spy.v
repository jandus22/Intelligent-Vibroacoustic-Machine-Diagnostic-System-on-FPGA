`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 12:48:17 PM
// Design Name: 
// Module Name: fir0_spy
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


module fir0_spy (
    input  wire        aclk,
    input  wire        aresetn,
    
    // Podpinasz to pod magistralę wychodzącą z FIR0
    input  wire [15:0] s_axis_tdata,
    input  wire        s_axis_tvalid,
    input  wire        s_axis_tready,
    input  wire        s_axis_tlast,

    // Wyjścia do podglądu w symulacji (Waveform)
    output reg [15:0] debug_x,
    output reg [15:0] debug_y,
    output reg [15:0] debug_z
);

    // Licznik kanałów (0=X, 1=Y, 2=Z)
    reg [1:0] chan_cnt;

    always @(posedge aclk) begin
        if (!aresetn) begin
            chan_cnt <= 2'b0;
            debug_x  <= 16'b0;
            debug_y  <= 16'b0;
            debug_z  <= 16'b0;
        end else begin
            // Sprawdzamy czy nastąpił transfer (Handshake)
            if (s_axis_tvalid && s_axis_tready) begin
                
                // Przypisujemy dane do odpowiedniego kanału
                case (chan_cnt)
                    2'd0: debug_x <= s_axis_tdata;
                    2'd1: debug_y <= s_axis_tdata;
                    2'd2: debug_z <= s_axis_tdata;
                endcase

                // Inkrementacja licznika lub reset przy TLAST
                if (s_axis_tlast || chan_cnt == 2'd2) begin
                    chan_cnt <= 2'b0;
                end else begin
                    chan_cnt <= chan_cnt + 1'b1;
                end
            end
        end
    end

endmodule
