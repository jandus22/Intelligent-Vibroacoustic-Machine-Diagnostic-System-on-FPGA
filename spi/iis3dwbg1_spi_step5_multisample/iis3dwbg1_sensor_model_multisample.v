`timescale 1ns / 1ps

// Behavioral IIS3DWBG1 model used only in simulation.
//
// After the sensor is enabled, it produces deterministic consecutive samples:
//
//   sample 0: X=0x1000, Y=0x8000, Z=0xF000
//   sample 1: X=0x1001, Y=0x8001, Z=0xF001
//   sample 2: X=0x1002, Y=0x8002, Z=0xF002
//   ...
//
// BDU-like behavior is modeled: the XYZ registers are not updated while
// data_ready is set. A new sample is loaded only after the previous six-byte
// burst has been completed.
module iis3dwbg1_sensor_model_multisample #(
    parameter integer SAMPLE_PERIOD_NS = 37500
) (
    input  wire        spi_sclk,
    input  wire        spi_mosi,
    output reg         spi_miso,
    input  wire        spi_cs_n,

    output wire [7:0]  ctrl1_xl,
    output wire [7:0]  ctrl3_c,
    output wire [7:0]  ctrl6_c,
    output reg  [31:0] generated_sample_count
);

    reg [7:0] registers [0:127];

    reg [7:0] rx_shift;
    reg [7:0] command_byte;
    reg [6:0] current_addr;
    reg       command_received;
    reg       read_transaction;
    integer   rx_bit_count;
    integer   tx_bit_index;
    reg       data_ready;
    reg       sensor_enabled;
    integer   next_sample_index;

    assign ctrl1_xl = registers[7'h10];
    assign ctrl3_c  = registers[7'h12];
    assign ctrl6_c  = registers[7'h15];

    task load_sample;
        input integer sample_index;
        reg [15:0] x_value;
        reg [15:0] y_value;
        reg [15:0] z_value;
        begin
            x_value = 16'h1000 + sample_index;
            y_value = 16'h8000 + sample_index;
            z_value = 16'hF000 + sample_index;

            registers[7'h28] = x_value[7:0];
            registers[7'h29] = x_value[15:8];
            registers[7'h2A] = y_value[7:0];
            registers[7'h2B] = y_value[15:8];
            registers[7'h2C] = z_value[7:0];
            registers[7'h2D] = z_value[15:8];

            data_ready = 1'b1;
            generated_sample_count = generated_sample_count + 1'b1;
        end
    endtask

    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1)
            registers[i] = 8'h00;

        registers[7'h0F] = 8'h7B;

        rx_shift              = 8'h00;
        command_byte          = 8'h00;
        current_addr          = 7'h00;
        command_received      = 1'b0;
        read_transaction      = 1'b0;
        rx_bit_count          = 0;
        tx_bit_index          = 7;
        data_ready            = 1'b0;
        sensor_enabled        = 1'b0;
        next_sample_index     = 0;
        generated_sample_count = 32'd0;
        spi_miso              = 1'b0;
    end

    always @(negedge spi_cs_n) begin
        rx_shift         = 8'h00;
        command_byte     = 8'h00;
        current_addr     = 7'h00;
        command_received = 1'b0;
        read_transaction = 1'b0;
        rx_bit_count     = 0;
        tx_bit_index     = 7;
        spi_miso         = 1'b0;
    end

    always @(posedge spi_cs_n) begin
        spi_miso = 1'b0;
    end

    // MOSI is sampled on rising SCLK edges in SPI mode 0.
    always @(posedge spi_sclk) begin
        if (!spi_cs_n) begin
            if (!command_received) begin
                rx_shift = {rx_shift[6:0], spi_mosi};

                if (rx_bit_count == 7) begin
                    command_byte      = rx_shift;
                    read_transaction  = rx_shift[7];
                    current_addr      = rx_shift[6:0];
                    command_received  = 1'b1;
                    rx_bit_count      = 0;
                    tx_bit_index      = 7;
                end else begin
                    rx_bit_count = rx_bit_count + 1;
                end
            end else if (!read_transaction) begin
                rx_shift = {rx_shift[6:0], spi_mosi};

                if (rx_bit_count == 7) begin
                    registers[current_addr] = rx_shift;

                    if ((current_addr == 7'h10) && (rx_shift == 8'hA0)) begin
                        sensor_enabled = 1'b1;

                        // The first sample becomes available immediately in
                        // this simulation model.
                        if (!data_ready) begin
                            load_sample(next_sample_index);
                            next_sample_index = next_sample_index + 1;
                        end
                    end

                    if (registers[7'h12][2])
                        current_addr = current_addr + 1'b1;

                    rx_bit_count = 0;
                end else begin
                    rx_bit_count = rx_bit_count + 1;
                end
            end else begin
                // One MISO data bit has just been sampled by the master.
                if (tx_bit_index == 0) begin
                    // The final Z_H byte releases the current BDU-held sample.
                    if (current_addr == 7'h2D)
                        data_ready = 1'b0;

                    if (registers[7'h12][2])
                        current_addr = current_addr + 1'b1;

                    tx_bit_index = 7;
                end else begin
                    tx_bit_index = tx_bit_index - 1;
                end
            end
        end
    end

    // MISO changes on falling SCLK edges in SPI mode 0.
    always @(negedge spi_sclk) begin
        if (!spi_cs_n && command_received && read_transaction) begin
            if (current_addr == 7'h1E)
                spi_miso = (tx_bit_index == 0) ? data_ready : 1'b0;
            else
                spi_miso = registers[current_addr][tx_bit_index];
        end else begin
            spi_miso = 1'b0;
        end
    end

    // Generate the next measurement at the configured output-data interval.
    initial begin
        wait (sensor_enabled == 1'b1);

        forever begin
            #(SAMPLE_PERIOD_NS);

            if (!data_ready) begin
                load_sample(next_sample_index);
                next_sample_index = next_sample_index + 1;
            end
        end
    end

endmodule
