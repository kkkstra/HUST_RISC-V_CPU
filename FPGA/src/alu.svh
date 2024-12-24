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