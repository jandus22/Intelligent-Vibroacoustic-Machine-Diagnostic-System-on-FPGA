`timescale 1ns / 1ps

module axis_test_gen (
    input  wire        clk,
    input  wire        rstn,

    output reg  [31:0] m_axis_tdata,
    output reg         m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         m_axis_tlast
);

    reg [10:0] sample_cnt;   // 0..1023
    reg [31:0] frame_id;
    reg [1:0]  state;

    localparam ST_HDR0 = 2'd0;
    localparam ST_HDR1 = 2'd1;
    localparam ST_HDR2 = 2'd2;
    localparam ST_DATA = 2'd3;

    wire axis_transfer;

    assign axis_transfer = m_axis_tvalid && m_axis_tready;

    /*
     * Dane wyjściowe zależą wyłącznie od aktualnego stanu.
     * Gdy TREADY = 0, stan i dane pozostają niezmienione.
     */
    always @(*) begin
        m_axis_tdata  = 32'd0;
        m_axis_tvalid = rstn;
        m_axis_tlast  = 1'b0;

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
                m_axis_tdata = {21'd0, sample_cnt};

                if (sample_cnt == 11'd1023)
                    m_axis_tlast = 1'b1;
            end

            default: begin
                m_axis_tdata = 32'd0;
            end
        endcase
    end

    /*
     * Stan zmienia się wyłącznie po rzeczywistym przesłaniu słowa,
     * czyli przy jednoczesnym TVALID i TREADY.
     */
    always @(posedge clk) begin
        if (!rstn) begin
            sample_cnt <= 11'd0;
            frame_id   <= 32'd0;
            state      <= ST_HDR0;
        end else if (axis_transfer) begin
            case (state)
                ST_HDR0: begin
                    state <= ST_HDR1;
                end

                ST_HDR1: begin
                    state <= ST_HDR2;
                end

                ST_HDR2: begin
                    sample_cnt <= 11'd0;
                    state      <= ST_DATA;
                end

                ST_DATA: begin
                    if (sample_cnt == 11'd1023) begin
                        sample_cnt <= 11'd0;
                        frame_id   <= frame_id + 1'b1;
                        state      <= ST_HDR0;
                    end else begin
                        sample_cnt <= sample_cnt + 1'b1;
                    end
                end

                default: begin
                    sample_cnt <= 11'd0;
                    state      <= ST_HDR0;
                end
            endcase
        end
    end

endmodule