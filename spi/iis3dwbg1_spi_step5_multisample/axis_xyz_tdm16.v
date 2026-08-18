`timescale 1ns / 1ps

// Converts one parallel XYZ sample into a continuous 16-bit TDM stream:
//
//   transfer 0: X[15:0]
//   transfer 1: Y[15:0]
//   transfer 2: Z[15:0]
//   transfer 3: X[15:0] of the next sample
//   ...
//
// A transfer occurs only when TVALID && TREADY are both high.
// TDATA, TVALID, TKEEP and TLAST remain stable while TREADY is low.
//
// TLAST_ON_Z:
//   0 - TLAST is always low. Recommended for a continuous graybox input.
//   1 - TLAST is asserted on every Z transfer as an optional XYZ marker.
//       Do not use this as a 1024-sample frame marker.
module axis_xyz_tdm16 #(
    parameter integer TLAST_ON_Z = 0
) (
    input  wire                    clk,
    input  wire                    rstn,

    input  wire signed [15:0]      sample_x,
    input  wire signed [15:0]      sample_y,
    input  wire signed [15:0]      sample_z,
    input  wire                    sample_valid,

    output reg                     sample_overflow,
    output reg [31:0]              stream_sample_count,
    output reg [31:0]              stream_word_count,

    output reg  [15:0]             m_axis_tdata,
    output reg  [1:0]              m_axis_tkeep,
    output reg                     m_axis_tvalid,
    input  wire                    m_axis_tready,
    output reg                     m_axis_tlast
);

    localparam [1:0]
        ST_IDLE   = 2'd0,
        ST_SEND_X = 2'd1,
        ST_SEND_Y = 2'd2,
        ST_SEND_Z = 2'd3;

    reg [1:0] state;

    // One complete 48-bit XYZ sample is held in ordinary FPGA registers.
    reg signed [15:0] x_buffer;
    reg signed [15:0] y_buffer;
    reg signed [15:0] z_buffer;

    wire axis_transfer = m_axis_tvalid && m_axis_tready;

    always @(*) begin
        m_axis_tdata  = 16'h0000;
        m_axis_tkeep  = 2'b11;
        m_axis_tvalid = 1'b0;
        m_axis_tlast  = 1'b0;

        case (state)
            ST_SEND_X: begin
                m_axis_tdata  = x_buffer;
                m_axis_tvalid = 1'b1;
            end

            ST_SEND_Y: begin
                m_axis_tdata  = y_buffer;
                m_axis_tvalid = 1'b1;
            end

            ST_SEND_Z: begin
                m_axis_tdata  = z_buffer;
                m_axis_tvalid = 1'b1;
                m_axis_tlast  = (TLAST_ON_Z != 0);
            end

            default: begin
                // ST_IDLE: no valid stream word.
            end
        endcase
    end

    always @(posedge clk) begin
        if (!rstn) begin
            state               <= ST_IDLE;
            x_buffer            <= 16'sd0;
            y_buffer            <= 16'sd0;
            z_buffer            <= 16'sd0;
            sample_overflow     <= 1'b0;
            stream_sample_count <= 32'd0;
            stream_word_count   <= 32'd0;
        end else begin
            case (state)
                ST_IDLE: begin
                    if (sample_valid) begin
                        x_buffer <= sample_x;
                        y_buffer <= sample_y;
                        z_buffer <= sample_z;
                        state    <= ST_SEND_X;
                    end
                end

                ST_SEND_X: begin
                    if (sample_valid)
                        sample_overflow <= 1'b1;

                    if (axis_transfer) begin
                        stream_word_count <= stream_word_count + 1'b1;
                        state             <= ST_SEND_Y;
                    end
                end

                ST_SEND_Y: begin
                    if (sample_valid)
                        sample_overflow <= 1'b1;

                    if (axis_transfer) begin
                        stream_word_count <= stream_word_count + 1'b1;
                        state             <= ST_SEND_Z;
                    end
                end

                ST_SEND_Z: begin
                    if (axis_transfer) begin
                        stream_word_count   <= stream_word_count + 1'b1;
                        stream_sample_count <= stream_sample_count + 1'b1;

                        // Zero-gap transition when a new complete XYZ sample
                        // is available exactly as the previous Z is accepted.
                        if (sample_valid) begin
                            x_buffer <= sample_x;
                            y_buffer <= sample_y;
                            z_buffer <= sample_z;
                            state    <= ST_SEND_X;
                        end else begin
                            state <= ST_IDLE;
                        end
                    end else if (sample_valid) begin
                        sample_overflow <= 1'b1;
                    end
                end

                default: begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end

endmodule
