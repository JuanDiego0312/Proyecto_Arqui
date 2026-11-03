`timescale 1ns/1ps

/*
 * Módulo: reg_en
 * Función: Registro genérico parametrizable con habilitación de carga (en).
 * Razón de existencia: Se utiliza para almacenar estado entre ciclos (PC, IR, OldPC, A, B, ALUOut, MDR).
 */
module reg_en #(
    parameter WIDTH = 32,
    parameter RESET_VAL = 0
)(
    input  clk,
    input  reset,
    input  en,
    input  [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else if (en)
            q <= d;
    end

endmodule