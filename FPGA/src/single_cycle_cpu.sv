`timescale 1ns / 1ps

`include "controller.svh"


module SingleCycleCPU(
    clk, rst, ledData, halt
);
    parameter WIDTH = 32;
    parameter PATH = "";
    parameter ROM_SIZE = 10;
    parameter RAM_SIZE = 10;

    input clk, rst;
    output [WIDTH-1:0] ledData;
    output halt;

    wire [WIDTH-1:0] PC, IR;
    reg [WIDTH-1:0] PCNext;
    wire [4:0] rs1, rs2, rd;
    wire [WIDTH-1:0] imm;
    reg [WIDTH-1:0] rDin;
    wire [WIDTH-1:0] aluResult, memData;
    wire aluEqual, aluGe, aluLess;
    Signal signal;

    Register #(
        .WIDTH(WIDTH)
    ) regPC (
        .clk(clk), .rst(rst), .en(~halt), .din(PCNext), .dout(PC)
    );
    always @(*) begin
        if (signal.branch[0] && (signal.branch[1] ^ !aluResult)) PCNext = PC + (imm << 1);
        else if (signal.irOp == IR_JAL) PCNext = PC + (imm << 1);
        else if (signal.irOp == IR_JALR) PCNext = R1 + (imm);
        else PCNext = PC + 4;
    end

    ROM #(
        .WIDTH(WIDTH), .PATH(PATH), .SIZE(ROM_SIZE)
    ) rom (
        .addr(PC[11:2]), .dout(IR)
    );

    Controller #(
        .WIDTH(WIDTH)
    ) controller (
        .ir(IR), .rs1(rs1), .rs2(rs2), .rd(rd), .imm(imm), .signal(signal)
    );

    Regfile #(
        .WIDTH(WIDTH)
    ) regfile (
        .clk(clk), .rst(rst), .we(1'b1),
        .rW(rd), .rA(rs1), .rB(rs2), .din(rDin),
        .r1(R1), .r2(R2)
    );
    always @* begin
        case (sig.rDinSrc)
            1: rDin = aluResult;
            2: rDin = memData;
            3: rDin = PC + 4;
            4: rDin = imm << 12;
            5: rDin = PC + (imm << 12);
            default: rDin = 0;
        endcase
    end

    ALU #(
        .WIDTH(WIDTH)
    ) alu (
        .X(R1), .Y(sig.aluSrcB ? imm : R2), .S(sig.aluOp),
        .result(aluResult), .equal(aluEqual), .ge(aluGe), .less(aluLess)
    );

    RAM #(
        .WIDTH(WIDTH),
        .SIZE(RAM_SIZE)
    ) ram (
        .clk(clk), .rst(rst), .we(signal.store),
        .mode(signal.ramMode), .addr(aluResult), .din(R2), .dout(memData)
    );

    Interrupt #(
        .WIDTH(WIDTH)
    ) interrupt (
        .clk(clk), .rst(rst), .ecall(signal.irOp == IR_ECALL),
        .R1(R1), .R2(R2),
        .ledData(ledData), .halt(halt)
    );

endmodule