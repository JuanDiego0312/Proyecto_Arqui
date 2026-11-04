`timescale 1ns/1ps

/*
 * Módulo: branch_logic
 * Función: Lógica combinacional para evaluar saltos condicionales (bne, bge) y habilitar el PC (pc_en).
 */
module branch_logic (
    input  pc_write,
    input  branch,
    input  [2:0] funct3,
    input  zero,
    input  lt,
    output pc_en
);

    reg cond;

    always @(*) begin
        case (funct3)
            3'b000: cond = zero;     // beq
            3'b001: cond = ~zero;    // bne
            3'b100: cond = lt;       // blt
            3'b101: cond = ~lt;      // bge
            default: cond = 1'b0;
        endcase
    end

    assign pc_en = pc_write | (branch & cond);

endmodule