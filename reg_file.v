`timescale 1ns/1ps

/*
 * Módulo: reg_file
 * Función: Banco de registros de 32 bits (32 registros), con lectura combinacional dual y escritura síncrona.
 * Razón de existencia: El registro x0 está permanentemente conectado a cero, y x2 (sp) se inicializa en SP_INIT (0x100).
 * 
 * Tabla de ENTRADAS:
 *   - clk, reset, we   : Reloj, reset síncrono activo en alto, habilitación de escritura
 *   - ra1 [4:0], ra2 [4:0] : Direcciones de lectura
 *   - wa [4:0], wd [31:0]  : Dirección y dato de escritura
 * 
 * Tabla de SALIDAS:
 *   - rd1 [31:0], rd2 [31:0] : Datos leídos
 */
module reg_file #(
    parameter SP_INIT = 32'h00000100
)(
    input  clk,
    input  reset,
    input  we,
    input  [4:0] ra1,
    input  [4:0] ra2,
    input  [4:0] wa,
    input  [31:0] wd,
    output [31:0] rd1,
    output [31:0] rd2
);

    reg [31:0] regs [0:31];
    integer i;

    assign rd1 = (ra1 == 5'b0) ? 32'b0 : regs[ra1];
    assign rd2 = (ra2 == 5'b0) ? 32'b0 : regs[ra2];

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
            regs[2] <= SP_INIT;
        end else if (we && (wa != 5'b0)) begin
            regs[wa] <= wd;
        end
    end

endmodule