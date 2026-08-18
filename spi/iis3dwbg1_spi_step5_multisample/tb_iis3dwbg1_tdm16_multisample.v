`timescale 1ns / 1ps

module tb_iis3dwbg1_tdm16_multisample;

    localparam integer TARGET_SAMPLES = 12;
    localparam integer TARGET_WORDS   = TARGET_SAMPLES * 3;

    reg clk  = 1'b0;
    reg rstn = 1'b0;

    wire spi_sclk;
    wire spi_mosi;
    wire spi_miso;
    wire spi_cs_n;

    wire [15:0] m_axis_tdata;
    wire [1:0]  m_axis_tkeep;
    wire        m_axis_tvalid;
    reg         m_axis_tready = 1'b0;
    wire        m_axis_tlast;

    wire [7:0] who_am_i;
    wire sensor_ok;
    wire configured;
    wire sensor_error;
    wire signed [15:0] last_sample_x;
    wire signed [15:0] last_sample_y;
    wire signed [15:0] last_sample_z;
    wire [31:0] sensor_sample_count;
    wire [31:0] tdm_sample_count;
    wire [31:0] tdm_word_count;
    wire tdm_overflow;

    wire [7:0] model_ctrl1_xl;
    wire [7:0] model_ctrl3_c;
    wire [7:0] model_ctrl6_c;
    wire [31:0] generated_sample_count;

    integer transfer_index = 0;
    integer error_count    = 0;
    integer expected_sample_index;
    integer expected_axis;
    reg [15:0] expected_word;

    integer stall_remaining = 0;
    reg stall_0_done  = 1'b0;
    reg stall_10_done = 1'b0;
    reg stall_23_done = 1'b0;

    reg hold_active = 1'b0;
    reg [15:0] held_data;
    reg [1:0]  held_keep;
    reg        held_last;

    iis3dwbg1_tdm16 #(
        .CLK_FREQ_HZ(100_000_000),
        .SPI_CLK_HZ (5_000_000),
        .STARTUP_MS (0),
        .TLAST_ON_Z (0)
    ) dut (
        .clk                 (clk),
        .rstn                (rstn),
        .spi_sclk            (spi_sclk),
        .spi_mosi            (spi_mosi),
        .spi_miso            (spi_miso),
        .spi_cs_n            (spi_cs_n),
        .m_axis_tdata        (m_axis_tdata),
        .m_axis_tkeep        (m_axis_tkeep),
        .m_axis_tvalid       (m_axis_tvalid),
        .m_axis_tready       (m_axis_tready),
        .m_axis_tlast        (m_axis_tlast),
        .who_am_i            (who_am_i),
        .sensor_ok           (sensor_ok),
        .configured          (configured),
        .sensor_error        (sensor_error),
        .last_sample_x       (last_sample_x),
        .last_sample_y       (last_sample_y),
        .last_sample_z       (last_sample_z),
        .sensor_sample_count (sensor_sample_count),
        .tdm_sample_count    (tdm_sample_count),
        .tdm_word_count      (tdm_word_count),
        .tdm_overflow        (tdm_overflow)
    );

    iis3dwbg1_sensor_model_multisample #(
        .SAMPLE_PERIOD_NS(37500)
    ) sensor_model (
        .spi_sclk               (spi_sclk),
        .spi_mosi               (spi_mosi),
        .spi_miso               (spi_miso),
        .spi_cs_n               (spi_cs_n),
        .ctrl1_xl               (model_ctrl1_xl),
        .ctrl3_c                (model_ctrl3_c),
        .ctrl6_c                (model_ctrl6_c),
        .generated_sample_count (generated_sample_count)
    );

    always #5 clk = ~clk; // 100 MHz

    // Deliberately stop the receiver on three different TDM words.
    // The stalls are much shorter than one accelerometer sample period.
    always @(negedge clk) begin
        if (!rstn) begin
            m_axis_tready <= 1'b0;
            stall_remaining = 0;
        end else if (stall_remaining > 0) begin
            m_axis_tready <= 1'b0;
            stall_remaining = stall_remaining - 1;
        end else if (!stall_0_done &&
                     (transfer_index == 0) && m_axis_tvalid) begin
            m_axis_tready <= 1'b0;
            stall_remaining = 40;
            stall_0_done = 1'b1;
        end else if (!stall_10_done &&
                     (transfer_index == 10) && m_axis_tvalid) begin
            m_axis_tready <= 1'b0;
            stall_remaining = 80;
            stall_10_done = 1'b1;
        end else if (!stall_23_done &&
                     (transfer_index == 23) && m_axis_tvalid) begin
            m_axis_tready <= 1'b0;
            stall_remaining = 120;
            stall_23_done = 1'b1;
        end else begin
            m_axis_tready <= 1'b1;
        end
    end

    // Scoreboard and AXI stability monitor.
    always @(posedge clk) begin
        if (!rstn) begin
            transfer_index = 0;
            error_count = 0;
            hold_active = 1'b0;
        end else begin
            // AXI rule: when TVALID=1 and TREADY=0, all output fields must
            // remain unchanged until the transfer is accepted.
            if (m_axis_tvalid && !m_axis_tready) begin
                if (!hold_active) begin
                    held_data   = m_axis_tdata;
                    held_keep   = m_axis_tkeep;
                    held_last   = m_axis_tlast;
                    hold_active = 1'b1;
                end else if ((m_axis_tdata !== held_data) ||
                             (m_axis_tkeep !== held_keep) ||
                             (m_axis_tlast !== held_last) ||
                             (m_axis_tvalid !== 1'b1)) begin
                    $display("ERROR: AXI output changed during backpressure at word %0d",
                             transfer_index);
                    error_count = error_count + 1;
                end
            end else begin
                hold_active = 1'b0;
            end

            if (m_axis_tvalid && m_axis_tready) begin
                expected_sample_index = transfer_index / 3;
                expected_axis         = transfer_index % 3;

                case (expected_axis)
                    0: expected_word = 16'h1000 + expected_sample_index;
                    1: expected_word = 16'h8000 + expected_sample_index;
                    2: expected_word = 16'hF000 + expected_sample_index;
                    default: expected_word = 16'hDEAD;
                endcase

                if (m_axis_tdata !== expected_word) begin
                    $display("ERROR: word %0d: expected 0x%04h, got 0x%04h",
                             transfer_index, expected_word, m_axis_tdata);
                    error_count = error_count + 1;
                end

                if (m_axis_tkeep !== 2'b11) begin
                    $display("ERROR: word %0d: TKEEP=%b, expected 11",
                             transfer_index, m_axis_tkeep);
                    error_count = error_count + 1;
                end

                if (m_axis_tlast !== 1'b0) begin
                    $display("ERROR: word %0d: TLAST should stay low",
                             transfer_index);
                    error_count = error_count + 1;
                end

                transfer_index = transfer_index + 1;
            end
        end
    end

    initial begin
        #100;
        rstn = 1'b1;

        wait (tdm_sample_count == TARGET_SAMPLES);
        #100;

        if ((who_am_i             == 8'h7B)         &&
            (sensor_ok            == 1'b1)          &&
            (configured           == 1'b1)          &&
            (sensor_error         == 1'b0)          &&
            (model_ctrl3_c        == 8'h44)         &&
            (model_ctrl6_c        == 8'h00)         &&
            (model_ctrl1_xl       == 8'hA0)         &&
            (sensor_sample_count  == TARGET_SAMPLES) &&
            (tdm_sample_count     == TARGET_SAMPLES) &&
            (tdm_word_count       == TARGET_WORDS)   &&
            (generated_sample_count == TARGET_SAMPLES) &&
            (transfer_index       == TARGET_WORDS)   &&
            (tdm_overflow         == 1'b0)          &&
            (stall_0_done         == 1'b1)          &&
            (stall_10_done        == 1'b1)          &&
            (stall_23_done        == 1'b1)          &&
            (error_count          == 0)) begin
            $display("PASS: %0d consecutive IIS3DWBG1 samples", TARGET_SAMPLES);
            $display("PASS: TDM order stayed X,Y,Z for all %0d words", TARGET_WORDS);
            $display("PASS: three backpressure intervals preserved AXI data");
            $display("PASS: tdm_overflow remained 0");
            $display("Last XYZ: X=0x%04h Y=0x%04h Z=0x%04h",
                     last_sample_x, last_sample_y, last_sample_z);
        end else begin
            $display("FAIL: multi-sample TDM verification");
            $display("WHO=0x%02h ok=%b cfg=%b err=%b",
                     who_am_i, sensor_ok, configured, sensor_error);
            $display("generated=%0d sensor=%0d tdm_samples=%0d tdm_words=%0d transfers=%0d",
                     generated_sample_count, sensor_sample_count,
                     tdm_sample_count, tdm_word_count, transfer_index);
            $display("overflow=%b errors=%0d stalls=%b%b%b",
                     tdm_overflow, error_count,
                     stall_23_done, stall_10_done, stall_0_done);
        end

        $finish;
    end

    initial begin
        #2_000_000;
        $display("FAIL: simulation timeout");
        $finish;
    end

endmodule
