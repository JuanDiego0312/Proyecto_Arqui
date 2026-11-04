`timescale 1ns/1ps

/*
 * Módulo: mux2_tb
 * Objetivo: Verificar la correcta selección entre dos entradas de 32 bits.
 * Estímulos: Variación de la señal 'sel' (0 y 1).
 * Resultados esperados: Salida igual a d0 cuando sel=0, y d1 cuando sel=1.
 */
module mux2_tb;
    reg sel;
    reg [31:0] d0, d1;
    wire [31:0] y;

    mux2 #(.WIDTH(32)) dut (.sel(sel), .d0(d0), .d1(d1), .y(y));

    initial begin
        $display("=== PRUEBA MUX2 ===");
        d0 = 32'hAAAA_AAAA; d1 = 32'hBBBB_BBBB;
        
        sel = 0; #10;
        if (y === 32'hAAAA_AAAA) $display("[PASS] sel=0 -> d0"); else $display("[FAIL]");
        
        sel = 1; #10;
        if (y === 32'hBBBB_BBBB) $display("[PASS] sel=1 -> d1"); else $display("[FAIL]");
        
        $finish;
    end
endmodule