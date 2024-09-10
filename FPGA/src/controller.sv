`timescale 1ns / 1ps

`include "controller.svh"


module Controller(
    ir, rs1, rs2, rd, imm, signal
);
    parameter WIDTH = 32;
    input [WIDTH-1:0] ir;
    output [4:0] rs1, rs2, rd;
    output [WIDTH-1:0] imm;
    output Signal signal;

    assign rs1 = signal.rs1 ? (signal.irOp == IR_ECALL ? 5'h11 : ir[19:15]) : 0;
    assign rs2 = signal.rs2 ? (signal.irOp == IR_ECALL ? 5'h0a : ir[24:20]) : 0;
    assign rd = signal.rDinSrc ? (signal.irOp == IR_ECALL ? 5'h0b : ir[11:7]) : 0;

    assign imm =
        signal.irType == IR_TYPE_I ? signed'(ir[31:20]) :
        signal.irType == IR_TYPE_S ? signed'({ir[31:25], ir[11:7]}) :
        signal.irType == IR_TYPE_B ? signed'({ir[31], ir[7], ir[30:25], ir[11:8]}) :
        signal.irType == IR_TYPE_U ? signed'(ir[31:12]) :
        signal.irType == IR_TYPE_J ? signed'({ir[31], ir[19:12], ir[20], ir[30:21]}) : 0;

    assign signal =
        (ir & `IR_MASK_ADD) == `IR_CODE_ADD ?       `IR_SIGNAL_ADD :
        (ir & `IR_MASK_ADD) == `IR_CODE_ADD ?       `IR_SIGNAL_ADD :
        (ir & `IR_MASK_SUB) == `IR_CODE_SUB ?       `IR_SIGNAL_SUB :
        (ir & `IR_MASK_SLL) == `IR_CODE_SLL ?       `IR_SIGNAL_SLL :
        (ir & `IR_MASK_SLT) == `IR_CODE_SLT ?       `IR_SIGNAL_SLT :
        (ir & `IR_MASK_SLTU) == `IR_CODE_SLTU ?     `IR_SIGNAL_SLTU :
        (ir & `IR_MASK_XOR) == `IR_CODE_XOR ?       `IR_SIGNAL_XOR :
        (ir & `IR_MASK_SRL) == `IR_CODE_SRL ?       `IR_SIGNAL_SRL :
        (ir & `IR_MASK_SRA) == `IR_CODE_SRA ?       `IR_SIGNAL_SRA :
        (ir & `IR_MASK_OR) == `IR_CODE_OR ?         `IR_SIGNAL_OR :
        (ir & `IR_MASK_AND) == `IR_CODE_AND ?       `IR_SIGNAL_AND :
        (ir & `IR_MASK_ADDI) == `IR_CODE_ADDI ?     `IR_SIGNAL_ADDI :
        (ir & `IR_MASK_SLLI) == `IR_CODE_SLLI ?     `IR_SIGNAL_SLLI :
        (ir & `IR_MASK_SLTI) == `IR_CODE_SLTI ?     `IR_SIGNAL_SLTI :
        (ir & `IR_MASK_SLTIU) == `IR_CODE_SLTIU ?   `IR_SIGNAL_SLTIU :
        (ir & `IR_MASK_XORI) == `IR_CODE_XORI ?     `IR_SIGNAL_XORI :
        (ir & `IR_MASK_SRLI) == `IR_CODE_SRLI ?     `IR_SIGNAL_SRLI :
        (ir & `IR_MASK_SRAI) == `IR_CODE_SRAI ?     `IR_SIGNAL_SRAI :
        (ir & `IR_MASK_ORI) == `IR_CODE_ORI ?       `IR_SIGNAL_ORI :
        (ir & `IR_MASK_ANDI) == `IR_CODE_ANDI ?     `IR_SIGNAL_ANDI :
        (ir & `IR_MASK_SB) == `IR_CODE_SB ?         `IR_SIGNAL_SB :
        (ir & `IR_MASK_SH) == `IR_CODE_SH ?         `IR_SIGNAL_SH :
        (ir & `IR_MASK_SW) == `IR_CODE_SW ?         `IR_SIGNAL_SW :
        (ir & `IR_MASK_LB) == `IR_CODE_LB ?         `IR_SIGNAL_LB :
        (ir & `IR_MASK_LH) == `IR_CODE_LH ?         `IR_SIGNAL_LH :
        (ir & `IR_MASK_LW) == `IR_CODE_LW ?         `IR_SIGNAL_LW :
        (ir & `IR_MASK_LBU) == `IR_CODE_LBU ?       `IR_SIGNAL_LBU :
        (ir & `IR_MASK_LHU) == `IR_CODE_LHU ?       `IR_SIGNAL_LHU :
        (ir & `IR_MASK_BEQ) == `IR_CODE_BEQ ?       `IR_SIGNAL_BEQ :
        (ir & `IR_MASK_BNE) == `IR_CODE_BNE ?       `IR_SIGNAL_BNE :
        (ir & `IR_MASK_BLT) == `IR_CODE_BLT ?       `IR_SIGNAL_BLT :
        (ir & `IR_MASK_BGE) == `IR_CODE_BGE ?       `IR_SIGNAL_BGE :
        (ir & `IR_MASK_BLTU) == `IR_CODE_BLTU ?     `IR_SIGNAL_BLTU :
        (ir & `IR_MASK_BGEU) == `IR_CODE_BGEU ?     `IR_SIGNAL_BGEU :
        (ir & `IR_MASK_JAL) == `IR_CODE_JAL ?       `IR_SIGNAL_JAL :
        (ir & `IR_MASK_JALR) == `IR_CODE_JALR ?     `IR_SIGNAL_JALR :
        (ir & `IR_MASK_LUI) == `IR_CODE_LUI ?       `IR_SIGNAL_LUI :
        (ir & `IR_MASK_AUIPC) == `IR_CODE_AUIPC ?   `IR_SIGNAL_AUIPC :
        (ir & `IR_MASK_ECALL) == `IR_CODE_ECALL ?   `IR_SIGNAL_ECALL :
        (ir & `IR_MASK_URET) == `IR_CODE_URET ?     `IR_SIGNAL_URET :
        (ir & `IR_MASK_CSRRSI) == `IR_CODE_CSRRSI ? `IR_SIGNAL_CSRRSI :
        (ir & `IR_MASK_CSRRCI) == `IR_CODE_CSRRCI ? `IR_SIGNAL_CSRRCI :
        `IR_SIGNAL_NOP;

endmodule