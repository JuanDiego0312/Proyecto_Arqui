`timescale 1ns/1ps

/*
 * Módulo: cpu_top
 * Función: Módulo superior del procesador RISC-V RV32I multiciclo.
 * Razón de existencia: Conecta todos los componentes del sistema. Posee EXCLUSIVAMENTE dos entradas: clk y reset.
 */
module cpu_top (
    input clk,
    input reset
);

    wire [31:0] pc, pc_next, ir, old_pc, instr_out;
    wire [31:0] rf_rd1, rf_rd2, a_out, b_out, imm;
    wire [31:0] alu_in_a, alu_in_b, alu_result, alu_out;
    wire [31:0] dmem_rdata, mdr_out, reg_wd;
    wire        zero, lt;
    wire        pc_en, pc_src, ir_write, reg_write, mem_read, mem_write;
    wire [1:0]  alu_src_a, alu_src_b, result_src;
    wire [3:0]  alu_ctrl;

    mux2 #(32)  u_pcmux  (.sel(pc_src), .d0(alu_result), .d1(alu_out), .y(pc_next));
    reg_en #(32,0) u_pc  (.clk(clk), .reset(reset), .en(pc_en), .d(pc_next), .q(pc));
    
    instr_mem    u_imem  (.addr(pc), .instr(instr_out));
    reg_en #(32,0) u_ir  (.clk(clk), .reset(reset), .en(ir_write), .d(instr_out), .q(ir));
    reg_en #(32,0) u_oldpc (.clk(clk), .reset(reset), .en(ir_write), .d(pc), .q(old_pc));
    
    reg_file     u_rf    (.clk(clk), .reset(reset), .we(reg_write), 
                          .ra1(ir[19:15]), .ra2(ir[24:20]), .wa(ir[11:7]), .wd(reg_wd),
                          .rd1(rf_rd1), .rd2(rf_rd2));
                          
    reg_en #(32,0) u_a   (.clk(clk), .reset(reset), .en(1'b1), .d(rf_rd1), .q(a_out));
    reg_en #(32,0) u_b   (.clk(clk), .reset(reset), .en(1'b1), .d(rf_rd2), .q(b_out));
    
    imm_gen      u_imm   (.instr(ir), .imm(imm));
    
    mux3 #(32)   u_srca  (.sel(alu_src_a), .d0(pc), .d1(old_pc), .d2(a_out), .y(alu_in_a));
    mux3 #(32)   u_srcb  (.sel(alu_src_b), .d0(b_out), .d1(imm), .d2(32'd4), .y(alu_in_b));
    
    alu          u_alu   (.a(alu_in_a), .b(alu_in_b), .alu_ctrl(alu_ctrl), 
                          .result(alu_result), .zero(zero), .lt(lt));
                          
    reg_en #(32,0) u_aluout (.clk(clk), .reset(reset), .en(1'b1), .d(alu_result), .q(alu_out));
    
    data_mem     u_dmem  (.clk(clk), .mem_read(mem_read), .mem_write(mem_write), 
                          .funct3(ir[14:12]), .addr(alu_out), .wdata(b_out), .rdata(dmem_rdata));
                          
    reg_en #(32,0) u_mdr (.clk(clk), .reset(reset), .en(1'b1), .d(dmem_rdata), .q(mdr_out));
    
    mux3 #(32)   u_result (.sel(result_src), .d0(alu_out), .d1(mdr_out), .d2(imm), .y(reg_wd));
    
    control_unit u_ctrl  (.clk(clk), .reset(reset), .opcode(ir[6:0]), .funct3(ir[14:12]), 
                          .zero(zero), .lt(lt), .pc_en(pc_en), .pc_src(pc_src), 
                          .ir_write(ir_write), .reg_write(reg_write), .mem_read(mem_read), 
                          .mem_write(mem_write), .alu_src_a(alu_src_a), .alu_src_b(alu_src_b), 
                          .result_src(result_src), .alu_ctrl(alu_ctrl));

endmodule