`timescale 1ns / 1ps

// Minimal IIS3DWB controller:
//
// 1. Waits after FPGA reset.
// 2. Reads and validates WHO_AM_I.
// 3. Disables I2C.
// 4. Enables BDU and automatic register-address increment.
// 5. Selects 3-axis mode.
// 6. Enables the accelerometer at 26.667 kHz, +/-2 g.
// 7. Waits for the sensor turn-on time.
// 8. Reads back and validates configuration registers.
// 9. Polls STATUS_REG.
// 10. Reads X/Y/Z in one 6-byte burst.
// 11. Discards the first complete XYZ sample.
// 12. Outputs subsequent valid samples.
//
// On any initialization error, the controller waits STARTUP_MS
// and retries the complete WHO_AM_I / configuration sequence.
module iis3dwbg1_xyz #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer SPI_CLK_HZ  = 6_250_000,
    parameter integer STARTUP_MS  = 20,
    parameter integer TURN_ON_MS  = 10
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

    // ---------------------------------------------------------------------
    // SPI clock divider
    //
    // f_SPI = f_clk / (2 * CLK_DIV)
    //
    // For 25 MHz and SPI_CLK_HZ = 6.25 MHz:
    // CLK_DIV = 25 MHz / (2 * 6.25 MHz) = 2
    // ---------------------------------------------------------------------

    localparam integer CLK_DIV_RAW =
        CLK_FREQ_HZ / (2 * SPI_CLK_HZ);

    localparam integer CLK_DIV =
        (CLK_DIV_RAW < 1) ? 1 : CLK_DIV_RAW;

    // ---------------------------------------------------------------------
    // Initial/retry delay
    // ---------------------------------------------------------------------

    localparam integer STARTUP_CYCLES_RAW =
        (CLK_FREQ_HZ / 1000) * STARTUP_MS;

    localparam integer STARTUP_CYCLES =
        (STARTUP_CYCLES_RAW < 1) ? 1 : STARTUP_CYCLES_RAW;

    localparam integer STARTUP_W =
        (STARTUP_CYCLES <= 1) ? 1 : $clog2(STARTUP_CYCLES);

    // ---------------------------------------------------------------------
    // Sensor turn-on delay after CTRL1_XL = 0xA0
    // ---------------------------------------------------------------------

    localparam integer TURN_ON_CYCLES_RAW =
        (CLK_FREQ_HZ / 1000) * TURN_ON_MS;

    localparam integer TURN_ON_CYCLES =
        (TURN_ON_CYCLES_RAW < 1) ? 1 : TURN_ON_CYCLES_RAW;

    localparam integer TURN_ON_W =
        (TURN_ON_CYCLES <= 1) ? 1 : $clog2(TURN_ON_CYCLES);

    // ---------------------------------------------------------------------
    // Register definitions
    // ---------------------------------------------------------------------

    localparam [6:0] REG_WHO_AM_I  = 7'h0F;
    localparam [6:0] REG_CTRL1_XL  = 7'h10;
    localparam [6:0] REG_CTRL3_C   = 7'h12;
    localparam [6:0] REG_CTRL4_C   = 7'h13;
    localparam [6:0] REG_CTRL6_C   = 7'h15;
    localparam [6:0] REG_STATUS    = 7'h1E;
    localparam [6:0] REG_OUTX_L_A  = 7'h28;

    localparam [7:0] EXPECTED_WHO_AM_I = 8'h7B;

    // CTRL3_C:
    // BDU    = 1
    // SIM    = 0 -> 4-wire SPI
    // IF_INC = 1
    localparam [7:0] CTRL3_VALUE = 8'h44;

    // CTRL4_C:
    // I2C_disable = 1
    localparam [7:0] CTRL4_VALUE = 8'h04;

    // CTRL6_C:
    // XL_AXIS_SEL = 00 -> X, Y, Z active
    localparam [7:0] CTRL6_VALUE = 8'h00;

    // CTRL1_XL:
    // XL_EN = 101 -> accelerometer enabled
    // FS    = 00  -> +/-2 g
    // LPF2  = 0   -> LPF1 output
    localparam [7:0] CTRL1_VALUE = 8'hA0;

    // ---------------------------------------------------------------------
    // State machine
    // ---------------------------------------------------------------------

    localparam [4:0]
        ST_STARTUP            = 5'd0,

        ST_WHO_START          = 5'd1,
        ST_WHO_WAIT           = 5'd2,

        ST_CTRL4_START        = 5'd3,
        ST_CTRL4_WAIT         = 5'd4,

        ST_CTRL3_START        = 5'd5,
        ST_CTRL3_WAIT         = 5'd6,

        ST_CTRL6_START        = 5'd7,
        ST_CTRL6_WAIT         = 5'd8,

        ST_CTRL1_START        = 5'd9,
        ST_CTRL1_WAIT         = 5'd10,

        ST_TURN_ON_WAIT       = 5'd11,

        ST_VERIFY_CTRL4_START = 5'd12,
        ST_VERIFY_CTRL4_WAIT  = 5'd13,

        ST_VERIFY_CTRL3_START = 5'd14,
        ST_VERIFY_CTRL3_WAIT  = 5'd15,

        ST_VERIFY_CTRL6_START = 5'd16,
        ST_VERIFY_CTRL6_WAIT  = 5'd17,

        ST_VERIFY_CTRL1_START = 5'd18,
        ST_VERIFY_CTRL1_WAIT  = 5'd19,

        ST_STATUS_START       = 5'd20,
        ST_STATUS_WAIT        = 5'd21,

        ST_XYZ_START          = 5'd22,
        ST_XYZ_WAIT           = 5'd23,

        ST_ERROR              = 5'd24;

    reg [4:0] state;

    reg [STARTUP_W-1:0] startup_count;
    reg [TURN_ON_W-1:0] turn_on_count;

    // The first complete XYZ sample after enabling the sensor is read,
    // but intentionally not forwarded to the AXI4-Stream path.
    reg discard_first_sample;

    // ---------------------------------------------------------------------
    // Register transaction interface
    // ---------------------------------------------------------------------

    reg         tr_start;
    reg         tr_read;
    reg  [6:0]  tr_addr;
    reg  [7:0]  tr_write_data;
    reg  [2:0]  tr_read_count;

    wire [47:0] tr_read_data;
    wire        tr_busy;
    wire        tr_done;

    spi_register_access_mode0 #(
        .CLK_DIV        (CLK_DIV),
        .CS_HIGH_CYCLES (4)
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

    // ---------------------------------------------------------------------
    // Main controller
    // ---------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rstn) begin
            state                <= ST_STARTUP;

            startup_count        <= {STARTUP_W{1'b0}};
            turn_on_count        <= {TURN_ON_W{1'b0}};

            tr_start             <= 1'b0;
            tr_read              <= 1'b0;
            tr_addr              <= 7'h00;
            tr_write_data        <= 8'h00;
            tr_read_count        <= 3'd1;

            who_am_i             <= 8'h00;
            sensor_ok            <= 1'b0;
            configured           <= 1'b0;
            sensor_error         <= 1'b0;

            sample_x             <= 16'sd0;
            sample_y             <= 16'sd0;
            sample_z             <= 16'sd0;
            sample_valid         <= 1'b0;
            sample_count         <= 32'd0;

            discard_first_sample <= 1'b1;
        end else begin
            // Default one-clock pulses.
            tr_start     <= 1'b0;
            sample_valid <= 1'b0;

            case (state)

                // ---------------------------------------------------------
                // Initial power-up / retry delay
                // ---------------------------------------------------------

                ST_STARTUP: begin
                    sensor_ok    <= 1'b0;
                    configured   <= 1'b0;
                    sensor_error <= 1'b0;

                    if (startup_count == STARTUP_CYCLES - 1) begin
                        startup_count <= {STARTUP_W{1'b0}};
                        state         <= ST_WHO_START;
                    end else begin
                        startup_count <= startup_count + 1'b1;
                    end
                end

                // ---------------------------------------------------------
                // WHO_AM_I
                // ---------------------------------------------------------

                ST_WHO_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= REG_WHO_AM_I;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_WHO_WAIT;
                    end
                end

                ST_WHO_WAIT: begin
                    if (tr_done) begin
                        who_am_i <= tr_read_data[7:0];

                        if (tr_read_data[7:0] == EXPECTED_WHO_AM_I) begin
                            sensor_ok    <= 1'b1;
                            sensor_error <= 1'b0;
                            state        <= ST_CTRL4_START;
                        end else begin
                            sensor_ok     <= 1'b0;
                            configured    <= 1'b0;
                            sensor_error  <= 1'b1;
                            startup_count <= {STARTUP_W{1'b0}};
                            state         <= ST_ERROR;
                        end
                    end
                end

                // ---------------------------------------------------------
                // CTRL4_C = 0x04
                // Disable I2C.
                // ---------------------------------------------------------

                ST_CTRL4_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b0;
                        tr_addr       <= REG_CTRL4_C;
                        tr_write_data <= CTRL4_VALUE;
                        tr_start      <= 1'b1;
                        state         <= ST_CTRL4_WAIT;
                    end
                end

                ST_CTRL4_WAIT: begin
                    if (tr_done)
                        state <= ST_CTRL3_START;
                end

                // ---------------------------------------------------------
                // CTRL3_C = 0x44
                // BDU=1, 4-wire SPI, IF_INC=1.
                // ---------------------------------------------------------

                ST_CTRL3_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b0;
                        tr_addr       <= REG_CTRL3_C;
                        tr_write_data <= CTRL3_VALUE;
                        tr_start      <= 1'b1;
                        state         <= ST_CTRL3_WAIT;
                    end
                end

                ST_CTRL3_WAIT: begin
                    if (tr_done)
                        state <= ST_CTRL6_START;
                end

                // ---------------------------------------------------------
                // CTRL6_C = 0x00
                // Three-axis mode.
                // ---------------------------------------------------------

                ST_CTRL6_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b0;
                        tr_addr       <= REG_CTRL6_C;
                        tr_write_data <= CTRL6_VALUE;
                        tr_start      <= 1'b1;
                        state         <= ST_CTRL6_WAIT;
                    end
                end

                ST_CTRL6_WAIT: begin
                    if (tr_done)
                        state <= ST_CTRL1_START;
                end

                // ---------------------------------------------------------
                // CTRL1_XL = 0xA0
                // Enable sensor, 26.667 kHz, +/-2 g.
                // ---------------------------------------------------------

                ST_CTRL1_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b0;
                        tr_addr       <= REG_CTRL1_XL;
                        tr_write_data <= CTRL1_VALUE;
                        tr_start      <= 1'b1;
                        state         <= ST_CTRL1_WAIT;
                    end
                end

                ST_CTRL1_WAIT: begin
                    if (tr_done) begin
                        turn_on_count <= {TURN_ON_W{1'b0}};
                        state         <= ST_TURN_ON_WAIT;
                    end
                end

                // ---------------------------------------------------------
                // Wait after enabling the sensing chain.
                // ---------------------------------------------------------

                ST_TURN_ON_WAIT: begin
                    if (turn_on_count == TURN_ON_CYCLES - 1) begin
                        turn_on_count <= {TURN_ON_W{1'b0}};
                        state         <= ST_VERIFY_CTRL4_START;
                    end else begin
                        turn_on_count <= turn_on_count + 1'b1;
                    end
                end

                // ---------------------------------------------------------
                // Readback CTRL4_C
                // ---------------------------------------------------------

                ST_VERIFY_CTRL4_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= REG_CTRL4_C;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_VERIFY_CTRL4_WAIT;
                    end
                end

                ST_VERIFY_CTRL4_WAIT: begin
                    if (tr_done) begin
                        if (tr_read_data[7:0] == CTRL4_VALUE) begin
                            state <= ST_VERIFY_CTRL3_START;
                        end else begin
                            sensor_error  <= 1'b1;
                            sensor_ok     <= 1'b0;
                            configured    <= 1'b0;
                            startup_count <= {STARTUP_W{1'b0}};
                            state         <= ST_ERROR;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Readback CTRL3_C
                // ---------------------------------------------------------

                ST_VERIFY_CTRL3_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= REG_CTRL3_C;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_VERIFY_CTRL3_WAIT;
                    end
                end

                ST_VERIFY_CTRL3_WAIT: begin
                    if (tr_done) begin
                        if (tr_read_data[7:0] == CTRL3_VALUE) begin
                            state <= ST_VERIFY_CTRL6_START;
                        end else begin
                            sensor_error  <= 1'b1;
                            sensor_ok     <= 1'b0;
                            configured    <= 1'b0;
                            startup_count <= {STARTUP_W{1'b0}};
                            state         <= ST_ERROR;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Readback CTRL6_C
                // ---------------------------------------------------------

                ST_VERIFY_CTRL6_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= REG_CTRL6_C;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_VERIFY_CTRL6_WAIT;
                    end
                end

                ST_VERIFY_CTRL6_WAIT: begin
                    if (tr_done) begin
                        if (tr_read_data[7:0] == CTRL6_VALUE) begin
                            state <= ST_VERIFY_CTRL1_START;
                        end else begin
                            sensor_error  <= 1'b1;
                            sensor_ok     <= 1'b0;
                            configured    <= 1'b0;
                            startup_count <= {STARTUP_W{1'b0}};
                            state         <= ST_ERROR;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Readback CTRL1_XL
                // ---------------------------------------------------------

                ST_VERIFY_CTRL1_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= REG_CTRL1_XL;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_VERIFY_CTRL1_WAIT;
                    end
                end

                ST_VERIFY_CTRL1_WAIT: begin
                    if (tr_done) begin
                        if (tr_read_data[7:0] == CTRL1_VALUE) begin
                            configured           <= 1'b1;
                            sensor_error         <= 1'b0;
                            discard_first_sample <= 1'b1;
                            state                <= ST_STATUS_START;
                        end else begin
                            sensor_error  <= 1'b1;
                            sensor_ok     <= 1'b0;
                            configured    <= 1'b0;
                            startup_count <= {STARTUP_W{1'b0}};
                            state         <= ST_ERROR;
                        end
                    end
                end

                // ---------------------------------------------------------
                // Poll STATUS_REG.XLDA
                // ---------------------------------------------------------

                ST_STATUS_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= REG_STATUS;
                        tr_read_count <= 3'd1;
                        tr_start      <= 1'b1;
                        state         <= ST_STATUS_WAIT;
                    end
                end

                ST_STATUS_WAIT: begin
                    if (tr_done) begin
                        // STATUS_REG bit 0 = XLDA.
                        if (tr_read_data[0])
                            state <= ST_XYZ_START;
                        else
                            state <= ST_STATUS_START;
                    end
                end

                // ---------------------------------------------------------
                // Burst read OUTX_L_A ... OUTZ_H_A
                // ---------------------------------------------------------

                ST_XYZ_START: begin
                    if (!tr_busy) begin
                        tr_read       <= 1'b1;
                        tr_addr       <= REG_OUTX_L_A;
                        tr_read_count <= 3'd6;
                        tr_start      <= 1'b1;
                        state         <= ST_XYZ_WAIT;
                    end
                end

                ST_XYZ_WAIT: begin
                    if (tr_done) begin
                        if (discard_first_sample) begin
                            // The first complete XYZ set after sensor
                            // activation is intentionally discarded.
                            //
                            // Do not update sample_x/y/z.
                            // Do not pulse sample_valid.
                            // Do not increment sample_count.
                            discard_first_sample <= 1'b0;
                        end else begin
                            sample_x <= {
                                tr_read_data[15:8],
                                tr_read_data[7:0]
                            };

                            sample_y <= {
                                tr_read_data[31:24],
                                tr_read_data[23:16]
                            };

                            sample_z <= {
                                tr_read_data[47:40],
                                tr_read_data[39:32]
                            };

                            sample_valid <= 1'b1;
                            sample_count <= sample_count + 1'b1;
                        end

                        state <= ST_STATUS_START;
                    end
                end

                // ---------------------------------------------------------
                // Error delay and automatic retry
                // ---------------------------------------------------------

                ST_ERROR: begin
                    sensor_error <= 1'b1;
                    sensor_ok    <= 1'b0;
                    configured   <= 1'b0;

                    if (startup_count == STARTUP_CYCLES - 1) begin
                        startup_count        <= {STARTUP_W{1'b0}};
                        who_am_i             <= 8'h00;
                        sensor_error         <= 1'b0;
                        discard_first_sample <= 1'b1;
                        state                 <= ST_WHO_START;
                    end else begin
                        startup_count <= startup_count + 1'b1;
                    end
                end

                default: begin
                    state                 <= ST_STARTUP;
                    startup_count         <= {STARTUP_W{1'b0}};
                    turn_on_count         <= {TURN_ON_W{1'b0}};
                    sensor_ok             <= 1'b0;
                    configured            <= 1'b0;
                    sensor_error          <= 1'b0;
                    discard_first_sample  <= 1'b1;
                end
            endcase
        end
    end

endmodule