`timescale 1ns / 1ps


typedef enum logic [3:0] {
    ALU_SLL,
    ALU_SRA,
    ALU_SRL,
    ALU_MUL,
    ALU_DIV,
    ALU_ADD,
    ALU_SUB,
    ALU_AND,
    ALU_OR,
    ALU_XOR,
    ALU_NOR,
    ALU_SLT,
    ALU_SLTU
} AluOp;

module alu(
    X, Y, S, result, result2, equal, ge, less
);
    input [31:0] X, Y;
    input AluOp [3:0] S;
    output reg [31:0] result, result2;
    output reg equal, ge, less;

    always @(*) begin
        case (S)
            ALU_SLL: result = X << Y;
            ALU_SRA: result = X >>> Y;
            ALU_SRL: result = X >> Y;
            ALU_MUL: result = X * Y;
            ALU_DIV: result = X / Y;
            ALU_ADD: result = X + Y;
            ALU_SUB: result = X - Y;
            ALU_AND: result = X & Y;
            ALU_OR: result = X | Y;
            ALU_XOR: result = X ^ Y;
            ALU_NOR: result = ~ (X | Y);
            ALU_SLT: begin
                less = ($signed(X) < $signed(Y));
                ge = ($signed(X) >= $signed(Y));
            end
            ALU_SLTU: begin
                less = (X < Y);
                ge = (X >= Y);
            end
        endcase
        equal = (X == Y);
    end
endmodule