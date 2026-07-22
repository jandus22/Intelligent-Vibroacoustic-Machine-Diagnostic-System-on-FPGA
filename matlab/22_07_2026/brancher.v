`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 04:11:52 AM
// Design Name: 
// Module Name: brancher
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


module brancher(
    input wire clk,
    input wire rst_n,
    // Wejście z CORDIC (po Subset Converterze - 32 bity: 16R + 16I)
    input wire [95:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire m_axis_tvalid,
    output wire [31:0] x_out,
    output wire [31:0] y_out,
    output wire [31:0] z_out
    );
    
    reg [31:0] out_x, out_y, out_z;
    reg reg_tvalid;
    
    always @(posedge clk) begin
        reg_tvalid <= s_axis_tvalid;
        out_x <= s_axis_tdata[31:0]; 
        out_y <= s_axis_tdata[63:32]; 
        out_z <= s_axis_tdata[95:64]; 
    end
    
    assign m_axis_tvalid = reg_tvalid;
    assign x_out = out_x;
    assign y_out = out_y;
    assign z_out = out_z;
    
endmodule
