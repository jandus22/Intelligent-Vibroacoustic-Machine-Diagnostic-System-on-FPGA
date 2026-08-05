`timescale 1ns / 1ps

/*
 * Continuous AXI4-Stream test-frame generator.
 *
 * Frame format:
 *   word 0: 0xA5000000
 *   word 1: 0xB5000000
 *   word 2: 0xC5000000
 *   words 3..4098: samples 0..4095
 *
 * TLAST is asserted together with sample 4095.
 *
 * Counters advance only after a valid AXI4-Stream handshake, therefore
 * TDATA and TLAST remain stable while TREADY is low.
 */
module axis_test_gen (
    input  wire        clk,
    input  wire        rstn,

    output reg  [31:0] m_axis_tdata,
    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         m_axis_tlast
);

    localparam [1:0] ST_HDR0 = 2'd0;
    localparam [1:0] ST_HDR1 = 2'd1;
    localparam [1:0] ST_HDR2 = 2'd2;
    localparam [1:0] ST_DATA = 2'd3;

    localparam [11:0] LAST_SAMPLE = 12'd4095;

    reg [1:0]  state;
    reg [11:0] sample_cnt;

    wire axis_transfer;
    assign axis_transfer = m_axis_tvalid && m_axis_tready;

    always @(*) begin
        m_axis_tvalid = rstn;
        m_axis_tlast  = 1'b0;
        m_axis_tdata  = 32'd0;

        case (state)
            ST_HDR0: begin
                m_axis_tdata = 32'hA5000000;
            end

            ST_HDR1: begin
                m_axis_tdata = 32'hB5000000;
            end

            ST_HDR2: begin
                m_axis_tdata = 32'hC5000000;
            end

            ST_DATA: begin
                m_axis_tdata = {20'd0, sample_cnt};
                m_axis_tlast = (sample_cnt == LAST_SAMPLE);
            end

            default: begin
                m_axis_tdata = 32'hA5000000;
            end
        endcase
    end

    always @(posedge clk) begin
        if (!rstn) begin
            state      <= ST_HDR0;
            sample_cnt <= 12'd0;
        end else if (axis_transfer) begin
            case (state)
                ST_HDR0: begin
                    state <= ST_HDR1;
                end

                ST_HDR1: begin
                    state <= ST_HDR2;
                end

                ST_HDR2: begin
                    state      <= ST_DATA;
                    sample_cnt <= 12'd0;
                end

                ST_DATA: begin
                    if (sample_cnt == LAST_SAMPLE) begin
                        state      <= ST_HDR0;
                        sample_cnt <= 12'd0;
                    end else begin
                        sample_cnt <= sample_cnt + 12'd1;
                    end
                end

                default: begin
                    state      <= ST_HDR0;
                    sample_cnt <= 12'd0;
                end
            endcase
        end
    end

endmodule