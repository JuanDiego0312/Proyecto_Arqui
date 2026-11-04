`timescale 1ns/1ps

/*
 * Módulo: control_fsm_tb
 * OBJETIVO DE LA PRUEBA: Verificar la secuencia de estados y las salidas tipo Moore 
 *   de la FSM para una instrucción tipo I (addi: S0 -> S1 -> S6 -> S7 -> S0).
 * ESTIMULOS:
 *   1. Aplicación de reset síncrono.
 *   2. Asignación del opcode 7'b0010011 (addi).
 *   3. Avance de ciclos de reloj (posedge clk).
 * RESULTADOS ESPERADOS:
 *   - S0 (FETCH)   : ir_write = 1
 *   - S1 (DECODE)  : alu_src_a = 2'b01
 *   - S6 (EXEC_I)  : alu_op = 2'b11
 *   - S7 (ALU_WB)  : reg_write = 1
 */
module control_fsm_tb;

    // Entradas a la FSM
    reg clk;
    reg reset;
    reg [6:0] opcode;

    // Salidas de la FSM
    wire pc_write;
    wire branch;
    wire pc_src;
    wire ir_write;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire [1:0] alu_src_a;
    wire [1:0] alu_src_b;
    wire [1:0] alu_op;
    wire [1:0] result_src;

    // Instanciación del módulo con mapeo explícito de puertos en Verilog-2001
    control_fsm dut (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .pc_write(pc_write),
        .branch(branch),
        .pc_src(pc_src),
        .ir_write(ir_write),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_op(alu_op),
        .result_src(result_src)
    );

    // Generador de reloj de 10 ns (50 MHz)
    always #5 clk = ~clk;

    initial begin
        $display("=== INICIO DE PRUEBAS CONTROL_FSM ===");

        // Inicialización de señales
        clk = 0;
        reset = 1;
        opcode = 7'b0000000;
        
        // Mantener reset activo por unos ciclos
        #12;
        reset = 0;
        
        // Probar instrucción addi (opcode 0010011)
        opcode = 7'b0010011;

        // --- Estado S0: FETCH ---
        #2;
        if (ir_write === 1'b1 && pc_write === 1'b1)
            $display("[PASS] Estado S0 (FETCH): ir_write=1, pc_write=1");
        else
            $display("[FAIL] Estado S0 (FETCH): ir_write=%b, pc_write=%b", ir_write, pc_write);

        // --- Estado S1: DECODE ---
        @(posedge clk); #2;
        if (alu_src_a === 2'b01 && alu_src_b === 2'b01)
            $display("[PASS] Estado S1 (DECODE): alu_src_a=01, alu_src_b=01");
        else
            $display("[FAIL] Estado S1 (DECODE): alu_src_a=%b", alu_src_a);

        // --- Estado S6: EXEC_I ---
        @(posedge clk); #2;
        if (alu_op === 2'b11 && alu_src_a === 2'b10)
            $display("[PASS] Estado S6 (EXEC_I): alu_op=11, alu_src_a=10");
        else
            $display("[FAIL] Estado S6 (EXEC_I): alu_op=%b", alu_op);

        // --- Estado S7: ALU_WB ---
        @(posedge clk); #2;
        if (reg_write === 1'b1 && result_src === 2'b00)
            $display("[PASS] Estado S7 (ALU_WB): reg_write=1, result_src=00");
        else
            $display("[FAIL] Estado S7 (ALU_WB): reg_write=%b", reg_write);

        // Regreso automático a S0
        @(posedge clk); #2;
        if (ir_write === 1'b1)
            $display("[PASS] Retorno a S0 correcto");
        else
            $display("[FAIL] No retornó a S0");

        $display("=== FIN DE PRUEBAS CONTROL_FSM ===");
        $finish;
    end

endmodule