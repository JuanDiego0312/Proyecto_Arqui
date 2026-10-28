`timescale 1ns/1ps

/*
 * Módulo: alu
 * Función: Unidad Aritmético-Lógica combinacional para el procesador RV32I multiciclo.
 * Razón de existencia: Soporta operaciones aritméticas (addi, lw/sw suman), lógicas (andi),
 *   desplazamientos (slli) y comparaciones para saltos (bne, bge mediante resta).
 * 
 * Tabla de ENTRADAS:
 *   - a [31:0]      : Operando A
 *   - b [31:0]      : Operando B
 *   - alu_ctrl [3:0]: Selector de operación de la ALU
 * 
 * Tabla de SALIDAS:
 *   - result [31:0] : Resultado de la operación
 *   - zero          : Bandera de cero (1 si result == 0)
 *   - lt            : Bandera de menor que con signo (1 si a < b firmado)
 * 
 * Comportamiento:
 *   - 4'b0010: ADD (a + b)
 *   - 4'b0110: SUB (a - b)
 *   - 4'b0000: AND (a & b)
 *   - 4'b0011: SLL (a << b[4:0])
 *   - Otro   : result = 0
 */
module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0]  alu_ctrl,
    output reg [31:0] result,
    output        zero,
    output        lt
);

    always @(*) begin
        // Asignación por defecto para evitar latches combinacionales
        result = 32'b0;
        case (alu_ctrl)
            4'b0010: result = a + b;                  // ADD
            4'b0110: result = a - b;                  // SUB
            4'b0000: result = a & b;                  // AND
            4'b0011: result = a << b[4:0];            // SLL (solo 5 bits bajos)
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);
    assign lt   = ($signed(a) < $signed(b));

endmodule