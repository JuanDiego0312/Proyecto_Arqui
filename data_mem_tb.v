`timescale 1ns/1ps

/*
 * Módulo: data_mem_tb
 * Objetivo: Validar lectura combinacional y escritura síncrona en memoria de datos (alineada y no alineada).
 * Estímulos: sw, sb, lw y generación del volcado de memoria.
 */
module data_mem_tb;
    reg clk, mem_read, mem_write;
    reg [2:0] funct3;
    reg [31:0] addr, wdata;
    wire [31:0] rdata;

    data_mem dut (.clk(clk), .mem_read(mem_read), .mem_write(mem_write), 
                  .funct3(funct3), .addr(addr), .wdata(wdata), .rdata(rdata));

    always #5 clk = ~clk;

    initial begin
        $display("=== PRUEBA DATA_MEM ===");
        clk = 0; mem_read = 0; mem_write = 0; addr = 0; wdata = 0; funct3 = 0; #12;

        // 1. Store Word (sw) en 0x0
        mem_write = 1; funct3 = 3'b010; addr = 32'h0; wdata = 32'hAABBCCDD; @(posedge clk); #2;
        mem_write = 0;
        
        // Load Word (lw) desde 0x0
        mem_read = 1; addr = 32'h0; #5;
        if (rdata === 32'hAABBCCDD) $display("[PASS] sw y lw coinciden en 0x0"); else $display("[FAIL]");
        mem_read = 0;

        // 2. Store Byte (sb) en dirección no alineada (0xE3) con valor 0x62
        mem_write = 1; funct3 = 3'b000; addr = 32'hE3; wdata = 32'h00000062; @(posedge clk); #2;
        mem_write = 0;

        // Verificamos la palabra completa en 0xE0
        mem_read = 1; addr = 32'hE0; #5;
        if (rdata === 32'h62000000) $display("[PASS] sb en 0xE3 correcto (0xE0 = %h)", rdata); else $display("[FAIL] %h", rdata);
        mem_read = 0;

        // 3. Store Word (sw) en 0xE4
        mem_write = 1; funct3 = 3'b010; addr = 32'hE4; wdata = 32'h0000C7DF; @(posedge clk); #2;
        mem_write = 0;

        // 4. Invocar volcado de memoria
        dut.dump_memory("test_dump.txt");

        $finish;
    end
endmodule