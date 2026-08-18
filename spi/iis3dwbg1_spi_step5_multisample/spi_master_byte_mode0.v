`timescale 1ns / 1ps

// Reusable 8-bit SPI master for SPI mode 0 (CPOL=0, CPHA=0).
// Chip-select is controlled by a higher-level transaction controller.
module spi_master_byte_mode0 #(
    parameter integer CLK_DIV = 10  // f_SCLK = f_clk / (2 * CLK_DIV)
) (
    input  wire       clk,
    input  wire       rstn,

    input  wire       start,
    input  wire [7:0] tx_data,
    output reg  [7:0] rx_data,
    output reg        busy,
    output reg        done,

    output reg        spi_sclk,
    output reg        spi_mosi,
    input  wire       spi_miso
);

    localparam integer DIV_W = (CLK_DIV <= 1) ? 1 : $clog2(CLK_DIV);

    reg [DIV_W-1:0] div_cnt;
    reg [2:0]       bit_idx;
    reg [7:0]       rx_shift;

    always @(posedge clk) begin
        if (!rstn) begin
            rx_data  <= 8'h00;
            busy     <= 1'b0;
            done     <= 1'b0;
            spi_sclk <= 1'b0;
            spi_mosi <= 1'b0;
            div_cnt  <= {DIV_W{1'b0}};
            bit_idx  <= 3'd7;
            rx_shift <= 8'h00;
        end else begin
            done <= 1'b0;

            if (!busy) begin
                spi_sclk <= 1'b0;
                div_cnt  <= {DIV_W{1'b0}};

                if (start) begin
                    busy     <= 1'b1;
                    bit_idx  <= 3'd7;
                    rx_shift <= 8'h00;
                    spi_mosi <= tx_data[7];
                end
            end else begin
                if (div_cnt == CLK_DIV - 1) begin
                    div_cnt <= {DIV_W{1'b0}};

                    if (spi_sclk == 1'b0) begin
                        // Mode 0: sample MISO on the rising edge.
                        spi_sclk          <= 1'b1;
                        rx_shift[bit_idx] <= spi_miso;
                    end else begin
                        // Prepare the next MOSI bit on the falling edge.
                        spi_sclk <= 1'b0;

                        if (bit_idx == 3'd0) begin
                            busy     <= 1'b0;
                            done     <= 1'b1;
                            rx_data  <= rx_shift;
                            spi_mosi <= 1'b0;
                        end else begin
                            bit_idx  <= bit_idx - 1'b1;
                            spi_mosi <= tx_data[bit_idx - 1'b1];
                        end
                    end
                end else begin
                    div_cnt <= div_cnt + 1'b1;
                end
            end
        end
    end

endmodule
