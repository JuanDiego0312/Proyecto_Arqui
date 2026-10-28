`timescale 1ns/1ps

/*
 * Módulo: alu_control
 * Función: Decodificador secundario para generar el código de control de la ALU (alu_ctrl)
 *   basado en alu_op y funct3.
 * Razón de existencia: Instrucciones como addi, andi y slli comparten opcode principal pero
 *   se distinguen por funct3. No se usa el bit 30 para evitar conflictos con el inmediato de tipo I.
 * 
 * Tabla de ENTRADAS:
 *   - alu_op [1:0]   : Selector de tipo de operación proveniente de la FSM
 *   - funct3 [2:0]   : Campo funct3 de la instrucción (IR[14:12])
 * 
 * Tabla de SALIDAS:
 *   - alu_ctrl [3:0] : Código de control para la ALU
 */
module alu_control (
    input  [1:0] alu_op,
    input  [2:0] funct3,
    output reg [3:0] alu_ctrl
);

    always @(*) begin
        alu_ctrl = 4'b0010;
        case (alu_op)
            2'b00: alu_ctrl = 4'b0010; // ADD
            2'b01: alu_ctrl = 4'b0110; // SUB
            2'b10: alu_ctrl = 4'b0010; // Reservado tipo R
            2'b11: begin               // Aritmética tipo I
                case (funct3)
                    3'b000: alu_ctrl = 4'b0010; // addi -> ADD
                    3'b111: alu_ctrl = 4'b0000; // andi -> AND
                    3'b001: alu_ctrl = 4'b0011; // slli -> SLL
                    default: alu_ctrl = 4'b0010;
                endcase
            end
            default: alu_ctrl = 4'b0010;
        endcase
    end

endmodule