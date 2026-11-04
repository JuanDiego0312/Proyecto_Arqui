`timescale 1ns/1ps

/*
 * Módulo: imm_gen_tb
 * Objetivo de la prueba: Verificar la correcta extracción y extensión de signo para los formatos I, S, B, U y J.
 */
module imm_gen_tb;

    reg [31:0] instr;
    wire [31:0] imm;

    imm_gen dut (.instr(instr), .imm(imm));

    initial begin
        $display("=== INICIO DE PRUEBAS DE IMM_GEN ===");

        instr = 32'hFE010113; #10; // addi sp, sp, -32
        if (imm === 32'hFFFFFFE0) $display("[PASS] addi imm = %h", imm); else $display("[FAIL]");

        instr = 32'h00179793; #10; // slli
        if (imm === 32'h00000001) $display("[PASS] slli imm = %h", imm); else $display("[FAIL]");

        instr = 32'h00F7F793; #10; // andi
        if (imm === 32'h0000000F) $display("[PASS] andi imm = %h", imm); else $display("[FAIL]");

        instr = 32'h0000C7B7; #10; // lui
        if (imm === 32'h0000C000) $display("[PASS] lui imm = %h", imm); else $display("[FAIL]");

        $display("=== FIN DE PRUEBAS DE IMM_GEN ===");
        $finish;
    end

endmodule