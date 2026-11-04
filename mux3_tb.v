`timescale 1ns/1ps

/*
 * Módulo: mux3_tb
 * Objetivo: Verificar la correcta selección entre tres entradas de 32 bits y el valor por defecto.
 */
module mux3_tb;
    reg [1:0] sel;
    reg [31:0] d0, d1, d2;
    wire [31:0] y;

    mux3 #(.WIDTH(32)) dut (.sel(sel), .d0(d0), .d1(d1), .d2(d2), .y(y));

    initial begin
        $display("=== PRUEBA MUX3 ===");
        d0 = 32'h1111_1111; d1 = 32'h2222_2222; d2 = 32'h3333_3333;
        
        sel = 2'b00; #10;
        if (y === 32'h1111_1111) $display("[PASS] sel=00 -> d0"); else $display("[FAIL]");
        
        sel = 2'b01; #10;
        if (y === 32'h2222_2222) $display("[PASS] sel=01 -> d1"); else $display("[FAIL]");
        
        sel = 2'b10; #10;
        if (y === 32'h3333_3333) $display("[PASS] sel=10 -> d2"); else $display("[FAIL]");
        
        sel = 2'b11; #10;
        if (y === 32'h0000_0000) $display("[PASS] sel=11 -> 0"); else $display("[FAIL]");
        
        $finish;
    end
endmodule