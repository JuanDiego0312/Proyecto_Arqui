`timescale 1ns/1ps

/*
 * Módulo: instr_mem_tb
 * Objetivo: Verificar la lectura correcta de instrucciones alineadas a 4 bytes.
 * Nota: Requiere crear un archivo "test.hex" con al menos 3 instrucciones para que funcione.
 */
module instr_mem_tb;
    reg [31:0] addr;
    wire [31:0] instr;

    // Se instancia asumiendo que "test.hex" contiene: FE010113, 00812E23, 02010413
    instr_mem #(.WORDS(256), .HEX_FILE("test.hex")) dut (.addr(addr), .instr(instr));

    initial begin
        $display("=== PRUEBA INSTR_MEM ===");
        
        // Escribimos un archivo de prueba dinámicamente para evitar errores si no existe
        $writememh("test.hex", dut.mem, 0, 2);
        dut.mem[0] = 32'hFE010113;
        dut.mem[1] = 32'h00812E23;
        dut.mem[2] = 32'h02010413;

        addr = 32'd0; #10;
        if (instr === 32'hFE010113) $display("[PASS] addr=0 -> %h", instr); else $display("[FAIL]");

        addr = 32'd4; #10;
        if (instr === 32'h00812E23) $display("[PASS] addr=4 -> %h", instr); else $display("[FAIL]");

        addr = 32'd8; #10;
        if (instr === 32'h02010413) $display("[PASS] addr=8 -> %h", instr); else $display("[FAIL]");

        addr = 32'd1024; #10; // Fuera de rango
        if (instr === 32'b0) $display("[PASS] addr=fuera de rango -> 0"); else $display("[FAIL]");

        $finish;
    end
endmodule