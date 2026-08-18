`timescale 1ns / 1ps

// Executes one complete IIS3DWBG1-style SPI register transaction.
// Supported operations:
//   - one-byte register write,
//   - burst read of 1..6 bytes while CS remains low.
// Read byte 0 is stored in read_data[7:0], byte 1 in [15:8], etc.
module spi_register_access_mode0 #(
    parameter integer CLK_DIV        = 10,
    parameter integer CS_HIGH_CYCLES = 4
) (
    input  wire        clk,
    input  wire        rstn,

    input  wire        start,
    input  wire        read_not_write,
    input  wire [6:0]  register_addr,
    input  wire [7:0]  write_data,
    input  wire [2:0]  read_count,

    output reg  [47:0] read_data,
    output reg         busy,
    output reg         done,

    output wire        spi_sclk,
    output wire        spi_mosi,
    input  wire        spi_miso,
    output reg         spi_cs_n
);

    localparam integer GAP_W = (CS_HIGH_CYCLES <= 1) ? 1 : $clog2(CS_HIGH_CYCLES);

    localparam [2:0]
        ST_IDLE       = 3'd0,
        ST_WAIT_CMD   = 3'd1,
        ST_WAIT_WRITE = 3'd2,
        ST_WAIT_READ  = 3'd3,
        ST_CS_GAP     = 3'd4;

    reg [2:0] state;

    reg       byte_start;
    reg [7:0] byte_tx_data;
    wire [7:0] byte_rx_data;
    wire      byte_busy;
    wire      byte_done;

    reg       op_read;
    reg [7:0] op_write_data;
    reg [2:0] op_read_count;
    reg [2:0] byte_index;
    reg [GAP_W-1:0] gap_count;

    spi_master_byte_mode0 #(
        .CLK_DIV(CLK_DIV)
    ) byte_master_inst (
        .clk      (clk),
        .rstn     (rstn),
        .start    (byte_start),
        .tx_data  (byte_tx_data),
        .rx_data  (byte_rx_data),
        .busy     (byte_busy),
        .done     (byte_done),
        .spi_sclk (spi_sclk),
        .spi_mosi (spi_mosi),
        .spi_miso (spi_miso)
    );

    always @(posedge clk) begin
        if (!rstn) begin
            state          <= ST_IDLE;
            byte_start     <= 1'b0;
            byte_tx_data   <= 8'h00;
            read_data      <= 48'h000000000000;
            busy           <= 1'b0;
            done           <= 1'b0;
            spi_cs_n       <= 1'b1;
            op_read        <= 1'b0;
            op_write_data  <= 8'h00;
            op_read_count  <= 3'd1;
            byte_index     <= 3'd0;
            gap_count      <= {GAP_W{1'b0}};
        end else begin
            byte_start <= 1'b0;
            done       <= 1'b0;

            case (state)
                ST_IDLE: begin
                    spi_cs_n <= 1'b1;
                    busy     <= 1'b0;

                    if (start) begin
                        busy          <= 1'b1;
                        spi_cs_n      <= 1'b0;
                        op_read       <= read_not_write;
                        op_write_data <= write_data;
                        op_read_count <= (read_count == 3'd0) ? 3'd1 : read_count;
                        byte_index    <= 3'd0;
                        read_data     <= 48'h000000000000;

                        // Command byte: bit 7 = R/W, bits 6:0 = address.
                        byte_tx_data <= {read_not_write, register_addr};
                        byte_start   <= 1'b1;
                        state        <= ST_WAIT_CMD;
                    end
                end

                ST_WAIT_CMD: begin
                    if (byte_done) begin
                        if (op_read) begin
                            byte_tx_data <= 8'h00;
                            byte_start   <= 1'b1;
                            state        <= ST_WAIT_READ;
                        end else begin
                            byte_tx_data <= op_write_data;
                            byte_start   <= 1'b1;
                            state        <= ST_WAIT_WRITE;
                        end
                    end
                end

                ST_WAIT_WRITE: begin
                    if (byte_done) begin
                        spi_cs_n  <= 1'b1;
                        gap_count <= {GAP_W{1'b0}};
                        state     <= ST_CS_GAP;
                    end
                end

                ST_WAIT_READ: begin
                    if (byte_done) begin
                        case (byte_index)
                            3'd0: read_data[7:0]   <= byte_rx_data;
                            3'd1: read_data[15:8]  <= byte_rx_data;
                            3'd2: read_data[23:16] <= byte_rx_data;
                            3'd3: read_data[31:24] <= byte_rx_data;
                            3'd4: read_data[39:32] <= byte_rx_data;
                            3'd5: read_data[47:40] <= byte_rx_data;
                            default: ;
                        endcase

                        if ((byte_index + 1'b1) >= op_read_count) begin
                            spi_cs_n  <= 1'b1;
                            gap_count <= {GAP_W{1'b0}};
                            state     <= ST_CS_GAP;
                        end else begin
                            byte_index   <= byte_index + 1'b1;
                            byte_tx_data <= 8'h00;
                            byte_start   <= 1'b1;
                        end
                    end
                end

                ST_CS_GAP: begin
                    spi_cs_n <= 1'b1;

                    if (gap_count == CS_HIGH_CYCLES - 1) begin
                        gap_count <= {GAP_W{1'b0}};
                        busy      <= 1'b0;
                        done      <= 1'b1;
                        state     <= ST_IDLE;
                    end else begin
                        gap_count <= gap_count + 1'b1;
                    end
                end

                default: begin
                    state    <= ST_IDLE;
                    spi_cs_n <= 1'b1;
                    busy     <= 1'b0;
                end
            endcase
        end
    end

endmodule
