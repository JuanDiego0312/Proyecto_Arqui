`timescale 1ns/1ps

/*
 * Módulo: alu_tb
 * Objetivo de la prueba: Verificar todas las operaciones de la ALU (ADD, SUB, AND, SLL, por defecto)
 *   y las banderas de salida (zero y lt con signo).
 * Estímulos: Se aplican diversos vectores de prueba para a, b y alu_ctrl de forma secuencial.
 * Resultados esperados: Se comparan los resultados reales con los valores esperados y se emite PASS/FAIL.
 */
module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0]  alu_ctrl;
    wire [31:0] result;
    wire        zero;
    wire        lt;

    alu dut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero),
        .lt(lt)
    );

    initial begin
        $display("=== INICIO DE PRUEBAS DE ALU ===");

        // Caso 1: ADD (5 + 3 = 8)
        a = 32'd5; b = 32'd3; alu_ctrl = 4'b0010;
        #10;
        if (result === 32'd8 && zero === 1'b0 && lt === 1'b0)
            $display("[PASS] ADD 5 + 3 = %0d", result);
        else
            $display("[FAIL] ADD 5 + 3 = %0d (Esperado: 8)", result);

        // Caso 2: ADD con desbordamiento a cero (0xFFFFFFFF + 1 = 0, zero=1)
        a = 32'hFFFFFFFF; b = 32'd1; alu_ctrl = 4'b0010;
        #10;
        if (result === 32'h00000000 && zero === 1'b1)
            $display("[PASS] ADD desbordamiento a cero, zero=1");
        else
            $display("[FAIL] ADD desbordamiento a cero, result=%h, zero=%b", result, zero);

        // Caso 3: SUB (7 - 7 = 0, zero=1)
        a = 32'd7; b = 32'd7; alu_ctrl = 4'b0110;
        #10;
        if (result === 32'd0 && zero === 1'b1)
            $display("[PASS] SUB 7 - 7 = 0, zero=1");
        else
            $display("[FAIL] SUB 7 - 7 = %0d, zero=%b", result, zero);

        // Caso 4: AND (0x7DF & 0xF = 0xF)
        a = 32'h000007DF; b = 32'h0000000F; alu_ctrl = 4'b0000;
        #10;
        if (result === 32'h0000000F)
            $display("[PASS] AND 0x7DF & 0xF = %h", result);
        else
            $display("[FAIL] AND 0x7DF & 0xF = %h", result);

        // Caso 5: SLL (33 << 1 = 66)
        a = 32'd33; b = 32'd1; alu_ctrl = 4'b0011;
        #10;
        if (result === 32'd66)
            $display("[PASS] SLL 33 << 1 = %0d", result);
        else
            $display("[FAIL] SLL 33 << 1 = %0d", result);

        // Caso 6: Menor con signo (-1 < 1 -> lt=1)
        a = 32'hFFFFFFFF; b = 32'd1; alu_ctrl = 4'b0110;
        #10;
        if (lt === 1'b1)
            $display("[PASS] Menor con signo (-1 < 1) -> lt=1");
        else
            $display("[FAIL] Menor con signo (-1 < 1) -> lt=%b", lt);

        // Caso 7: Opción inválida -> result = 0
        a = 32'd10; b = 32'd5; alu_ctrl = 4'b1111;
        #10;
        if (result === 32'b0)
            $display("[PASS] Opción inválida -> result = 0");
        else
            $display("[FAIL] Opción inválida -> result = %h", result);

        $display("=== FIN DE PRUEBAS DE ALU ===");
        $finish;
    end

endmodule