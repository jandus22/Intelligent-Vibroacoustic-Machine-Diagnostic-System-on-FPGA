`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2026 02:44:32 PM
// Design Name: 
// Module Name: TDM to Parallel Converter
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


module tdm_to_parallel_converter(
    input wire clk,
    input wire rst_n,
    // Wejście z CORDIC (po Subset Converterze - 32 bity: 16R + 16I)
    input wire [31:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,
    // Wyjście do FFT (96 bitów)
    output reg [95:0] m_axis_tdata,
    output reg m_axis_tvalid,
    input wire m_axis_tready,
    output reg m_axis_tlast
    );
reg [31:0] sample_x, sample_y;
    reg [1:0] channel_cnt;

    assign s_axis_tready = m_axis_tready || !m_axis_tvalid;

    always @(posedge clk) begin
        if (!rst_n) begin
            channel_cnt <= 0;
            m_axis_tvalid <= 0;
        end else if (s_axis_tvalid && s_axis_tready) begin
            case (channel_cnt)
                2'd0: begin // Wpadło X
                    sample_x <= s_axis_tdata;
                    channel_cnt <= 2'd1;
                    m_axis_tvalid <= 0;
                end
                2'd1: begin // Wpadło Y
                    sample_y <= s_axis_tdata;
                    channel_cnt <= 2'd2;
                    m_axis_tvalid <= 0;
                end
                2'd2: begin // Wpadło Z
                    m_axis_tdata <= {s_axis_tdata, sample_y, sample_x};
                    m_axis_tvalid <= 1;
                    m_axis_tlast <= s_axis_tlast; // TLAST leci tylko z paczką 96-bit
                    channel_cnt <= 2'd0;
                end
            endcase
        end else if (m_axis_tready) begin
            m_axis_tvalid <= 0;
        end
    end
endmodule
