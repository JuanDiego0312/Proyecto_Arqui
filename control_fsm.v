`timescale 1ns/1ps

/*
 * Módulo: control_fsm
 * Función: Máquina de estados (FSM) de 12 estados (S0 a S11) con salidas tipo Moore para el procesador multiciclo.
 */
module control_fsm (
    input  clk,
    input  reset,
    input  [6:0] opcode,
    output reg pc_write,
    output reg branch,
    output reg pc_src,
    output reg ir_write,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] alu_src_a,
    output reg [1:0] alu_src_b,
    output reg [1:0] alu_op,
    output reg [1:0] result_src
);

    localparam [3:0]
        S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8, S9=9, S10=10, S11=11;

    reg [3:0] current_state, next_state;

    always @(posedge clk) begin
        if (reset) current_state <= S0;
        else current_state <= next_state;
    end

    always @(*) begin
        next_state = S0;
        case (current_state)
            S0: next_state = S1;
            S1: begin
                case (opcode)
                    7'b0010011: next_state = S6;
                    7'b0000011: next_state = S2;
                    7'b0100011: next_state = S2;
                    7'b1100011: next_state = S8;
                    7'b1101111: next_state = S10;
                    7'b1100111: next_state = S9;
                    7'b0110111: next_state = S11;
                    default:    next_state = S0;
                endcase
            end
            S2:  next_state = (opcode == 7'b0000011) ? S3 : S5;
            S3:  next_state = S4;
            S4:  next_state = S0;
            S5:  next_state = S0;
            S6:  next_state = S7;
            S7:  next_state = S0;
            S8:  next_state = S0;
            S9:  next_state = S10;
            S10: next_state = S7;
            S11: next_state = S0;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        pc_write = 0; branch = 0; pc_src = 0; ir_write = 0; reg_write = 0;
        mem_read = 0; mem_write = 0; alu_src_a = 0; alu_src_b = 0; alu_op = 0; result_src = 0;

        case (current_state)
            S0:  begin pc_write=1; ir_write=1; alu_src_a=2'b00; alu_src_b=2'b10; alu_op=2'b00; end
            S1:  begin alu_src_a=2'b01; alu_src_b=2'b01; alu_op=2'b00; end
            S2:  begin alu_src_a=2'b10; alu_src_b=2'b01; alu_op=2'b00; end
            S3:  begin mem_read=1; end
            S4:  begin reg_write=1; result_src=2'b01; end
            S5:  begin mem_write=1; end
            S6:  begin alu_src_a=2'b10; alu_src_b=2'b01; alu_op=2'b11; end
            S7:  begin reg_write=1; result_src=2'b00; end
            S8:  begin branch=1; pc_src=1; alu_src_a=2'b10; alu_src_b=2'b00; alu_op=2'b01; end
            S9:  begin alu_src_a=2'b10; alu_src_b=2'b01; alu_op=2'b00; end
            S10: begin pc_write=1; pc_src=1; alu_src_a=2'b01; alu_src_b=2'b10; alu_op=2'b00; end
            S11: begin reg_write=1; result_src=2'b10; end
            default: ;
        endcase
    end

endmodule