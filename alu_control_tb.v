`timescale 1ns/1ps

/*
 * Módulo: alu_control_tb
 * Objetivo de la prueba: Verificar todas las combinaciones de alu_op y funct3 para el bloque alu_control.
 */
module alu_control_tb;

    reg [1:0] alu_op;
    reg [2:0] funct3;
    wire [3:0] alu_ctrl;

    alu_control dut (.alu_op(alu_op), .funct3(funct3), .alu_ctrl(alu_ctrl));

    initial begin
        $display("=== INICIO DE PRUEBAS DE ALU_CONTROL ===");

        alu_op = 2'b00; funct3 = 3'b000; #10;
        if (alu_ctrl === 4'b0010) $display("[PASS] alu_op=00 -> ADD"); else $display("[FAIL]");

        alu_op = 2'b01; funct3 = 3'b000; #10;
        if (alu_ctrl === 4'b0110) $display("[PASS] alu_op=01 -> SUB"); else $display("[FAIL]");

        alu_op = 2'b11; funct3 = 3'b000; #10;
        if (alu_ctrl === 4'b0010) $display("[PASS] alu_op=11, funct3=000 (addi) -> ADD"); else $display("[FAIL]");

        alu_op = 2'b11; funct3 = 3'b111; #10;
        if (alu_ctrl === 4'b0000) $display("[PASS] alu_op=11, funct3=111 (andi) -> AND"); else $display("[FAIL]");

        alu_op = 2'b11; funct3 = 3'b001; #10;
        if (alu_ctrl === 4'b0011) $display("[PASS] alu_op=11, funct3=001 (slli) -> SLL"); else $display("[FAIL]");

        $display("=== FIN DE PRUEBAS DE ALU_CONTROL ===");
        $finish;
    end

endmodule