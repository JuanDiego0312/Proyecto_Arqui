`timescale 1ns/1ps
module reg_en_tb;
    reg clk, reset, en;
    reg [31:0] d;
    wire [31:0] q;

    reg_en dut (.clk(clk), .reset(reset), .en(en), .d(d), .q(q));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; en = 0; d = 0; #12; reset = 0; #5;
        en = 1; d = 32'hDEADBEEF; @(posedge clk); #2;
        if (q === 32'hDEADBEEF) $display("[PASS] reg_en carga correcta"); else $display("[FAIL]");
        $finish;
    end
endmodule