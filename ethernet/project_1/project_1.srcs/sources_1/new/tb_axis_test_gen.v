`timescale 1ns/1ps

module tb_axis_test_gen;

    reg clk = 0;
    reg rstn = 0;

    wire [31:0] tdata;
    wire tvalid;
    wire tlast;
    reg tready = 1;

    // DUT
    axis_test_gen uut (
        .clk(clk),
        .rstn(rstn),
        .m_axis_tdata(tdata),
        .m_axis_tvalid(tvalid),
        .m_axis_tready(tready),
        .m_axis_tlast(tlast)
    );

    // clock 100 MHz
    always #5 clk = ~clk;

    initial begin
    rstn = 0;
    tready = 1;
    #100;
    rstn = 1;

    // normalna praca
    #3000;

    // odbiornik niegotowy
    tready = 0;
    #2000;

    // znowu gotowy
    tready = 1;
    #12000;

    $finish;
end

endmodule