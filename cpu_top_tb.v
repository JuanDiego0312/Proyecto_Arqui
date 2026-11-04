`timescale 1ns/1ps

/*
 * Módulo: cpu_top_tb
 * Objetivo: Prueba integral (Integration Test) del procesador RISC-V RV32I Multiciclo.
 *   Se ejecuta el programa ensamblador completo (primera pasada) provisto por el profesor.
 * 
 * Estímulos: 
 *   - Generación de reloj de 10 ns (50 MHz).
 *   - Secuencia de Reset inicial.
 * 
 * Resultados Esperados:
 *   - Ejecución de las 45 instrucciones (aprox. 185 ciclos).
 *   - Detección automática del final del programa (PC vuelve a 0 luego de saltar).
 *   - Comprobación de direcciones críticas de la Memoria de Datos (0xE0, 0xE4, 0xE8, 0xEC, 0xFC).
 *   - Comprobación de registros sp (x2) y s0 (x8).
 *   - Volcado dinámico de la memoria a "memory_dump.txt".
 */
module cpu_top_tb;

    // --- Señales Globales ---
    reg clk;
    reg reset;
    
    // --- Variables de Control de Simulación ---
    integer cycle_count;
    integer max_cycles;
    reg passed_first_pass;
    integer err_count;

    // --- Instanciación del Top Module ---
    cpu_top dut (
        .clk(clk),
        .reset(reset)
    );

    // --- Generador de Reloj (10 ns -> 100 MHz de simulación) ---
    always #5 clk = ~clk;

    // --- Secuencia Inicial ---
    initial begin
        $display("\n========================================================");
        $display("   INICIO DE SIMULACION: MT-7003 RV32I MULTICICLO");
        $display("========================================================\n");
        
        clk = 0;
        reset = 1;
        cycle_count = 0;
        err_count = 0;
        passed_first_pass = 0;
        max_cycles = 500; // Timeout de seguridad
        
        // Mantenemos reset por unos ciclos
        #25;
        reset = 0;
    end

    // --- Contador de Ciclos Activos ---
    always @(posedge clk) begin
        if (!reset) begin
            cycle_count = cycle_count + 1;
        end
    end

    // --- Lógica de Detección de Fin de Programa ---
    // El programa termina su primera pasada cuando el PC vuelve a la dirección 0x0
    // después de haber avanzado (asegurado por cycle_count > 50).
    always @(posedge clk) begin
        if (!reset && (dut.pc == 32'h0000_0000) && (cycle_count > 50) && !passed_first_pass) begin
            passed_first_pass = 1;
            
            $display("\n[INFO] Primera pasada concluida en el ciclo: %0d", cycle_count);
            $display("[INFO] Generando volcado de memoria...");
            
            // Invocación del volcado de memoria (obligatorio)
            dut.u_dmem.dump_memory("memory_dump.txt");
            
            // Pausa breve para estabilización antes de las aserciones
            #10;
            
            $display("\n========================================================");
            $display("   RESULTADOS ESPERADOS (PASS/FAIL)");
            $display("========================================================");
            
            // --- Comprobación de Memoria ---
            check_mem(32'hE0, 32'h62000000, "a = 'b'");
            check_mem(32'hE4, 32'h0000C7DF, "Variable i");
            check_mem(32'hE8, 32'h00000002, "Variable j");
            check_mem(32'hEC, 32'h00000002, "b = (33<<1)&0xF");
            check_mem(32'hFC, 32'h00000000, "sp guardado");
            
            // --- Comprobación de Registros ---
            check_reg(2, 32'h00000100, "sp (x2)");
            check_reg(8, 32'h00000000, "s0 (x8)");

            $display("--------------------------------------------------------");
            if (err_count == 0) begin
                $display(" [EXITO] SIMULACION FINALIZADA SIN ERRORES.");
            end else begin
                $display(" [ALERTA] SIMULACION FINALIZADA CON %0d ERRORES.", err_count);
            end
            $display("========================================================\n");
            
            $finish;
        end
    end

    // --- Control de Timeout ---
    always @(posedge clk) begin
        if (cycle_count >= max_cycles) begin
            $display("\n[ERROR FATAL] Timeout de simulación superado (%0d ciclos). PC actual: %h", max_cycles, dut.pc);
            $finish;
        end
    end

    // --- Tareas de Asistencia para Verificación (Aserciones) ---
    task check_mem;
        input [31:0] addr;
        input [31:0] expected_val;
        input [8*20:1] description;
        reg [31:0] actual_val;
        begin
            // Lectura directa desde el modelo de memoria del DUT
            actual_val = {dut.u_dmem.mem[addr+3], dut.u_dmem.mem[addr+2], 
                          dut.u_dmem.mem[addr+1], dut.u_dmem.mem[addr+0]};
            if (actual_val === expected_val) begin
                $display(" [PASS] Memoria [0x%02X] = 0x%08X (%s)", addr, actual_val, description);
            end else begin
                $display(" [FAIL] Memoria [0x%02X] = 0x%08X | ESPERADO: 0x%08X (%s)", addr, actual_val, expected_val, description);
                err_count = err_count + 1;
            end
        end
    endtask

    task check_reg;
        input [4:0] reg_idx;
        input [31:0] expected_val;
        input [8*20:1] description;
        reg [31:0] actual_val;
        begin
            actual_val = dut.u_rf.regs[reg_idx];
            if (actual_val === expected_val) begin
                $display(" [PASS] Registro %s = 0x%08X", description, actual_val);
            end else begin
                $display(" [FAIL] Registro %s = 0x%08X | ESPERADO: 0x%08X", description, actual_val, expected_val);
                err_count = err_count + 1;
            end
        end
    endtask

endmodule