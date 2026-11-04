`timescale 1ns/1ps

/*
 * Módulo: instr_mem
 * Función: Memoria de instrucciones de sólo lectura con lectura combinacional.
 * Razón de existencia: Almacena el programa compilado (.hex). Es el único componente que cambia en la evaluación.
 */
module instr_mem #(
    parameter WORDS = 256,
    parameter HEX_FILE = "programa.hex"
)(
    input  [31:0] addr,
    output [31:0] instr
);

    reg [31:0] mem [0:WORDS-1];
    integer i;

    initial begin
        for (i = 0; i < WORDS; i = i + 1) mem[i] = 32'b0;
        $readmemh(HEX_FILE, mem);
    end

    wire [31:0] word_addr = addr >> 2;
    assign instr = (word_addr < WORDS) ? mem[word_addr[31:0]] : 32'b0;

endmodule