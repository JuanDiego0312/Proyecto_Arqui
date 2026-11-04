`timescale 1ns/1ps

/*
 * Módulo: data_mem
 * Función: Memoria de datos de lectura combinacional y escritura síncrona por byte/palabra.
 * Razón de existencia: Soporta lw, sw y sb (bytes no alineados). Incluye el task obligatorio dump_memory.
 */
module data_mem #(
    parameter ADDR_BITS = 8
)(
    input  clk,
    input  mem_read,
    input  mem_write,
    input  [2:0] funct3,
    input  [31:0] addr,
    input  [31:0] wdata,
    output [31:0] rdata
);

    reg [7:0] mem [0:(1<<ADDR_BITS)-1];
    integer i;

    initial begin
        for (i = 0; i < (1<<ADDR_BITS); i = i + 1) mem[i] = 8'b0;
    end

    wire [ADDR_BITS-1:0] index = addr[ADDR_BITS-1:0];
    wire [ADDR_BITS-1:0] aligned_index = {index[ADDR_BITS-1:2], 2'b00};

    assign rdata = mem_read ? {mem[aligned_index+3], mem[aligned_index+2], mem[aligned_index+1], mem[aligned_index]} : 32'b0;

    always @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b000: mem[index] <= wdata[7:0]; // sb
                3'b010: begin                     // sw
                    mem[aligned_index]   <= wdata[7:0];
                    mem[aligned_index+1] <= wdata[15:8];
                    mem[aligned_index+2] <= wdata[23:16];
                    mem[aligned_index+3] <= wdata[31:24];
                end
                default: ;
            endcase
        end
    end

    task dump_memory;
        input [8*40-1:0] filename;
        integer file_id;
        integer addr_idx;
        begin
            file_id = $fopen(filename, "w");
            if (file_id) begin
                $fwrite(file_id, "Direccion de Memoria    Valor en hexadecimal\n");
                for (addr_idx = 0; addr_idx < (1<<ADDR_BITS); addr_idx = addr_idx + 4) begin
                    $fwrite(file_id, "0x%02X                   0x%02X%02X%02X%02X\n", 
                        addr_idx, mem[addr_idx+3], mem[addr_idx+2], mem[addr_idx+1], mem[addr_idx+0]);
                end
                $fclose(file_id);
                $display("[INFO] Volcado de memoria completado en: %s", filename);
            end
        end
    endtask

endmodule