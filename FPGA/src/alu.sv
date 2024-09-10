`timescale 1ns / 1ps

`include "alu.svh"


module ALU(
    X, Y, S, result, result2, equal, ge, less
);
    parameter WIDTH = 32;
    
    input [31:0] X, Y;
    input AluOp S;
    output reg [31:0] result, result2;
    output reg equal, ge, less;

    always @(*) begin
        case (S)
            ALU_SLL: result = X << Y[4:0];
            ALU_SRA: result = $signed(X) >>> Y[4:0];
            ALU_SRL: result = X >> Y[4:0];
            ALU_MUL: {result2, result} = X * Y;
            ALU_DIV: {result2, result} = {X % Y, X / Y};
            ALU_ADD: result = X + Y;
            ALU_SUB: result = X - Y;
            ALU_AND: result = X & Y;
            ALU_OR:  result = X | Y;
            ALU_XOR: result = X ^ Y;
            ALU_NOR: result = ~ (X | Y);
            ALU_SLT: begin
                result = ($signed(X) < $signed(Y));
                less = ($signed(X) < $signed(Y));
                ge = ~less;
            end
            ALU_SLTU: begin
                result = (X < Y);
                less = (X < Y);
                ge = ~less;
            end
        endcase
        equal = (X == Y);
    end
endmodule