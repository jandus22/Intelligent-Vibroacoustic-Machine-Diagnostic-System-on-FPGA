`timescale 1ns / 1ps

module axis_xyz_tlast (
    input  wire        aclk,
    input  wire        aresetn,

    // AXI4-Stream z DMA MM2S
    input  wire [15:0] s_axis_tdata,
    input  wire [1:0]  s_axis_tkeep,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,

    // AXI4-Stream do grayboxa
    output wire [15:0] m_axis_tdata,
    output wire [1:0]  m_axis_tkeep,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready,
    output wire        m_axis_tlast
);

    // 0 = X
    // 1 = Y
    // 2 = Z
    reg [1:0] xyz_position;

    // Dane przechodzą bez zmian
    assign m_axis_tdata  = s_axis_tdata;
    assign m_axis_tkeep  = s_axis_tkeep;
    assign m_axis_tvalid = s_axis_tvalid;

    // Mechanizm wstrzymywania przepływu
    assign s_axis_tready = m_axis_tready;

    // Nowy TLAST: każde trzecie słowo, czyli każde Z
    assign m_axis_tlast =
        s_axis_tvalid && (xyz_position == 2'd2);

    always @(posedge aclk) begin
        if (!aresetn) begin
            xyz_position <= 2'd0;
        end
        else if (s_axis_tvalid && s_axis_tready) begin

            // TLAST z DMA oznacza koniec całego transferu MM2S.
            // Używamy go tylko do ponownej synchronizacji X/Y/Z.
            if (s_axis_tlast) begin
                xyz_position <= 2'd0;
            end
            else begin
                case (xyz_position)
                    2'd0: xyz_position <= 2'd1; // X -> Y
                    2'd1: xyz_position <= 2'd2; // Y -> Z
                    2'd2: xyz_position <= 2'd0; // Z -> X
                    default: xyz_position <= 2'd0;
                endcase
            end

        end
    end

endmodule