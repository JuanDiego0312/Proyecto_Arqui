`timescale 1ns/1ps

module branch_logic_tb;
    reg pc_write, branch, zero, lt;
    reg [2:0] funct3;
    wire pc_en;

    branch_logic dut (.pc_write(pc_write), .branch(branch), .funct3(funct3), .zero(zero), .lt(lt), .pc_en(pc_en));

    initial begin
        $display("=== PRUEBA BRANCH_LOGIC ===");
        
        // pc_write dominante
        pc_write = 1; branch = 0; funct3 = 0; zero = 0; lt = 0; #10;
        if (pc_en === 1) $display("[PASS] pc_write=1 fuerza pc_en=1"); else $display("[FAIL]");

        // bne (funct3=001) con zero=0 (A != B -> Salta)
        pc_write = 0; branch = 1; funct3 = 3'b001; zero = 0; #10;
        if (pc_en === 1) $display("[PASS] bne con zero=0 -> pc_en=1"); else $display("[FAIL]");

        // bge (funct3=101) con lt=1 (A < B -> No salta)
        pc_write = 0; branch = 1; funct3 = 3'b101; lt = 1; #10;
        if (pc_en === 0) $display("[PASS] bge con lt=1 -> pc_en=0"); else $display("[FAIL]");

        $finish;
    end
endmodule