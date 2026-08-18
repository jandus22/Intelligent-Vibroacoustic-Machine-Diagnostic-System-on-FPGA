`timescale 1ns / 1ps

// Minimal IIS3DWBG1 controller:
// 1. reads WHO_AM_I,
// 2. enables BDU and automatic address increment,
// 3. selects 3-axis mode,
// 4. enables the accelerometer at 26.667 kHz, +/-2 g,
// 5. polls STATUS_REG,
// 6. reads X/Y/Z in one 6-byte burst.
module iis3dwbg1_xyz #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer SPI_CLK_HZ  = 5_000_000,
    parameter integer STARTUP_MS  = 20
) (
    input  wire                    clk,
    input  wire                    rstn,

    output wire                    spi_sclk,
    output wire                    spi_mosi,
    input  wire                    spi_miso,
    output wire                    spi_cs_n,

    output reg  [7:0]              who_am_i,
    output reg                     sensor_ok,
    output reg                     configured,
    output reg                     sensor_error,

    output reg signed [15:0]       sample_x,
    output reg signed [15:0]       sample_y,
    output reg signed [15:0]       sample_z,
    output reg                     sample_valid,
    output reg [31:0]              sample_count
);

    localparam integer CLK_DIV_RAW = CLK_FREQ_HZ / (2 * SPI_CLK_HZ);
    localparam integer CLK_DIV     = (CLK_DIV_RAW < 1) ? 1 : CLK_DIV_RAW;

    localparam integer WAIT_CYCLES_RAW = (CLK_FREQ_HZ / 1000) * STARTUP_MS;
    localparam integer WAIT_CYCLES     = (WAIT_CYCLES_RAW < 1) ? 1 : WAIT_CYCLES_RAW;
    localparam integer WAIT_W          = (WAIT_CYCLES <= 1) ? 1 : $clog2(WAIT_CYCLES);

    localparam [4:0]
        ST_STARTUP      = 5'd0,
        ST_WHO_START    = 5'd1,
        ST_WHO_WAIT     = 5'd2,
        ST_CTRL3_START  = 5'd3,
        ST_CTRL3_WAIT   = 5'd4,
        ST_CTRL6_START  = 5'd5,
        ST_CTRL6_WAIT   = 5'd6,
        ST_CTRL1_START  = 5'd7,
        ST_CTRL1_WAIT   = 5'd8,
        ST_STATUS_START = 5'd9,
        ST_STATUS_WAIT  = 5'd10,
        ST_XYZ_START    = 5'd11,
        ST_XYZ_WAIT     = 5'd12,
        ST_ERROR        = 5'd13;

    reg [4:0] state;
    reg [WAIT_W-1:0] startup_count;

    reg        tr_start;
    reg        tr_read;
    reg [6:0]  tr_addr;
    reg [7:0]  tr_write_data;
    reg [2:0]  tr_read_count;
    wire [47:0] tr_read_data;
    wire       tr_busy;
    wire       tr_done;

    spi_register_access_mode0 #(
        .CLK_DIV(CLK_DIV),
        .CS_HIGH_CYCLES(4)
    ) transaction_inst (
        .clk            (clk),
        .rstn           (rstn),
        .start          (tr_start),
        .read_not_write (tr_read),
        .register_addr  (tr_addr),
        .write_data     (tr_write_data),
        .read_count     (tr_read_count),
        .read_data      (tr_read_data),
        .busy           (tr_busy),
        .done           (tr_done),
        .spi_sclk       (spi_sclk),
        .spi_mosi       (spi_mosi),
        .spi_miso       (spi_miso),
        .spi_cs_n       (spi_cs_n)
    );

    always @(posedge clk) begin
        if (!rstn) begin
            state         <= ST_STARTUP;
            startup_count <= {WAIT_W{1'b0}};
            tr_start      <= 1'b0;
            tr_read       <= 1'b0;
            tr_addr       <= 7'h00;
            tr_write_data <= 8'h00;
            tr_read_count <= 3'd1;

            who_am_i      <= 8'h00;
            sensor_ok     <= 1'b0;
            configured    <= 1'b0;
            sensor_error  <= 1'b0;
            sample_x      <= 16'sd0;
            sample_y      <= 16'sd0;
            sample_z      <= 16'sd0;
            sample_valid  <= 1'b0;
            sample_count  <= 32'd0;
        end else begin
            tr_start     <= 1'b0;
            sample_valid <= 1'b0;

            case (state)
                ST_STARTUP: begin
                    if (startup_count == WAIT_CYCLES - 1) begin
                        startup_count <= {WAIT_W{1'b0}};
                        state         <= ST_WHO_START;
                    end else begin
                        startup_count <= startup_count + 1'b1;
                    end
                end

                ST_WHO_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= 7'h0F;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_WHO_WAIT;
                    end
                end

                ST_WHO_WAIT: begin
                    if (tr_done) begin
                        who_am_i <= tr_read_data[7:0];

                        if (tr_read_data[7:0] == 8'h7B) begin
                            sensor_ok <= 1'b1;
                            state     <= ST_CTRL3_START;
                        end else begin
                            sensor_ok    <= 1'b0;
                            sensor_error <= 1'b1;
                            state        <= ST_ERROR;
                        end
                    end
                end

                ST_CTRL3_START: begin
                    if (!tr_busy) begin
                        // CTRL3_C = 0x44: BDU=1, IF_INC=1.
                        tr_read       <= 1'b0;
                        tr_addr       <= 7'h12;
                        tr_write_data <= 8'h44;
                        tr_start      <= 1'b1;
                        state         <= ST_CTRL3_WAIT;
                    end
                end

                ST_CTRL3_WAIT: begin
                    if (tr_done)
                        state <= ST_CTRL6_START;
                end

                ST_CTRL6_START: begin
                    if (!tr_busy) begin
                        // CTRL6_C = 0x00: three-axis mode.
                        tr_read       <= 1'b0;
                        tr_addr       <= 7'h15;
                        tr_write_data <= 8'h00;
                        tr_start      <= 1'b1;
                        state         <= ST_CTRL6_WAIT;
                    end
                end

                ST_CTRL6_WAIT: begin
                    if (tr_done)
                        state <= ST_CTRL1_START;
                end

                ST_CTRL1_START: begin
                    if (!tr_busy) begin
                        // CTRL1_XL = 0xA0: sensor enabled, 26.667 kHz, +/-2 g.
                        tr_read       <= 1'b0;
                        tr_addr       <= 7'h10;
                        tr_write_data <= 8'hA0;
                        tr_start      <= 1'b1;
                        state         <= ST_CTRL1_WAIT;
                    end
                end

                ST_CTRL1_WAIT: begin
                    if (tr_done) begin
                        configured <= 1'b1;
                        state      <= ST_STATUS_START;
                    end
                end

                ST_STATUS_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= 7'h1E;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_STATUS_WAIT;
                    end
                end

                ST_STATUS_WAIT: begin
                    if (tr_done) begin
                        if (tr_read_data[0])
                            state <= ST_XYZ_START;
                        else
                            state <= ST_STATUS_START;
                    end
                end

                ST_XYZ_START: begin
                    if (!tr_busy) begin
                        // Burst read: 0x28..0x2D = XL,XH,YL,YH,ZL,ZH.
                        tr_read       <= 1'b1;
                        tr_addr       <= 7'h28;
                        tr_read_count <= 3'd6;
                        tr_start      <= 1'b1;
                        state         <= ST_XYZ_WAIT;
                    end
                end

                ST_XYZ_WAIT: begin
                    if (tr_done) begin
                        sample_x     <= {tr_read_data[15:8],  tr_read_data[7:0]};
                        sample_y     <= {tr_read_data[31:24], tr_read_data[23:16]};
                        sample_z     <= {tr_read_data[47:40], tr_read_data[39:32]};
                        sample_valid <= 1'b1;
                        sample_count <= sample_count + 1'b1;
                        state        <= ST_STATUS_START;
                    end
                end

                ST_ERROR: begin
                    // Hold the error until reset.
                    sensor_error <= 1'b1;
                end

                default: begin
                    state <= ST_STARTUP;
                end
            endcase
        end
    end

endmodule
