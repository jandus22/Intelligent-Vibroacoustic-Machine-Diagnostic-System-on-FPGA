`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: janecki n kids
// Engineer: janecki
// 
// Create Date: 03/24/2026 03:57:09 PM
// Design Name: 
// Module Name: axis_test_gen
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


module axis_test_gen (
    input  wire        clk,
    input  wire        rstn,

    output reg [31:0]  m_axis_tdata,
    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         m_axis_tlast
);

    reg [10:0] sample_cnt;   // 0 .. 1023
    reg [31:0] frame_id;
    reg [1:0]  state;

    localparam ST_HDR0 = 2'd0;
    localparam ST_HDR1 = 2'd1;
    localparam ST_HDR2 = 2'd2;
    localparam ST_DATA = 2'd3;

    always @(posedge clk) begin
        if (!rstn) begin
            m_axis_tdata  <= 32'd0;
            m_axis_tvalid <= 1'b0;
            m_axis_tlast  <= 1'b0;
            sample_cnt    <= 11'd0;
            frame_id      <= 32'd0;
            state         <= ST_HDR0;
        end else begin
            m_axis_tvalid <= 1'b1;
            m_axis_tlast  <= 1'b0;

            if (m_axis_tvalid && m_axis_tready) begin
                case (state)
                    ST_HDR0: begin
                        m_axis_tdata <= frame_id;     // word[0] = frame_id
                        state <= ST_HDR1;
                    end

                    ST_HDR1: begin
                        m_axis_tdata <= 32'd0;        // word[1] = ml_result
                        state <= ST_HDR2;
                    end

                    ST_HDR2: begin
                        m_axis_tdata <= 32'd0;        // word[2] = reserved / confidence
                        sample_cnt <= 11'd0;
                        state <= ST_DATA;
                    end

                    ST_DATA: begin
                        m_axis_tdata <= {21'd0, sample_cnt}; // test data 0..1023

                        if (sample_cnt == 11'd1023) begin
                            m_axis_tlast <= 1'b1;
                            sample_cnt   <= 11'd0;
                            frame_id     <= frame_id + 1'b1;
                            state        <= ST_HDR0;
                        end else begin
                            sample_cnt <= sample_cnt + 1'b1;
                        end
                    end

                    default: begin
                        state <= ST_HDR0;
                    end
                endcase
            end
        end
    end

endmodule
