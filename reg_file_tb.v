`timescale 1ns/1ps
module reg_file_tb;
    reg clk, reset, we;
    reg [4:0] ra1, ra2, wa;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    reg_file dut (.clk(clk), .reset(reset), .we(we), .ra1(ra1), .ra2(ra2), .wa(wa), .wd(wd), .rd1(rd1), .rd2(rd2));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; we = 0; #12; reset = 0; #5;
        ra1 = 2; #5;
        if (rd1 === 32'h100) $display("[PASS] x2 = 0x100"); else $display("[FAIL]");
        $finish;
    end
endmodule