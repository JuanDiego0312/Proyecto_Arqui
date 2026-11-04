`timescale 1ns/1ps

/*
 * Módulo: control_unit
 * Función: Envoltorio que integra la FSM principal, alu_control y branch_logic.
 */
module control_unit (
    input  clk,
    input  reset,
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  zero,
    input  lt,
    output pc_en,
    output pc_src,
    output ir_write,
    output reg_write,
    output mem_read,
    output mem_write,
    output [1:0] alu_src_a,
    output [1:0] alu_src_b,
    output [1:0] result_src,
    output [3:0] alu_ctrl
);

    wire pc_write_sig, branch_sig;
    wire [1:0] alu_op_sig;

    control_fsm u_fsm (.clk(clk), .reset(reset), .opcode(opcode), .pc_write(pc_write_sig), 
                       .branch(branch_sig), .pc_src(pc_src), .ir_write(ir_write), .reg_write(reg_write), 
                       .mem_read(mem_read), .mem_write(mem_write), .alu_src_a(alu_src_a), 
                       .alu_src_b(alu_src_b), .alu_op(alu_op_sig), .result_src(result_src));

    alu_control u_aluctl (.alu_op(alu_op_sig), .funct3(funct3), .alu_ctrl(alu_ctrl));

    branch_logic u_br (.pc_write(pc_write_sig), .branch(branch_sig), .funct3(funct3), 
                       .zero(zero), .lt(lt), .pc_en(pc_en));

endmodule