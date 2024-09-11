`timescale 1ns / 1ps


module LoadUseGen (
    input [4:0] rs1, input [4:0] rs2,
    input [4:0] EXRd, input [4:0] MEMRd,
    input EXLoad,
    output [1:0] r1Forward, output [1:0] r2Forward,
    output loadUse
);
    logic EXConf1, EXConf2, MEMConf1, MEMConf2;
    assign EXConf1 = rs1 && rs1 == EXRd;
    assign EXConf2 = rs2 && rs2 == EXRd;
    assign MEMConf1 = rs1 && rs1 == MEMRd;
    assign MEMConf2 = rs2 && rs2 == MEMRd;
    assign loadUse = (EXConf1 || EXConf2) && EXLoad;
    assign r1Forward = EXConf1? 2: MEMConf1? 1: 0;
    assign r2Forward = EXConf2? 2: MEMConf2? 1: 0;
endmodule

module PipelineCPU(
    clk, rst, ledData, halt,
    debug
);
    parameter WIDTH = 32;
    parameter PATH = "";
    parameter ROM_SIZE = 10;
    parameter RAM_SIZE = 10;
    parameter BHB_SIZE = 8;

    input clk, rst;
    output reg halt;
    output [31:0] ledData;
    output debug;

    // IF
    wire [WIDTH-1:0] PC, IR;
    reg [WIDTH-1:0] PCNorm, PCPred, PCNext;

    // ID
    Signal signal;
    wire [4:0] rd, rs1, rs2;
    wire [WIDTH-1:0] R1, R2, imm;
    wire [1:0] r1Forward, r2Forward;
    reg [WIDTH-1:0] rDin;

    // EX
    reg [WIDTH-1:0] realR1, realR2;
    wire [WIDTH-1:0] aluResult;
    wire EXBranch, EXHalt;

    // MEM
    wire [WIDTH-1:0] readData;

    // Branch prediction
    wire loadUse, predictJump;
    reg [WIDTH-1:0] branchAddr;
    wire [WIDTH-1:0] jumpAddr;
    reg branchTaken, predictError;


    // Pipeline
    PipelineID ID;
    PipelineReg #($bits(ID)) pipelineRegID(
        .clk(clk), .rst(rst), .clr(predictError), .en(!halt && !loadUse), 
        .din({PC, IR, predictJump}),
        .dout(ID)
    );

    PipelineEX EX;
    PipelineReg #($bits(EX)) pipelineRegEX(
        .clk(clk), .rst(rst), .clr(loadUse || predictError), .en(!halt), 
        .din({ID.PC, ID.IR, signal, rd, R1, R2, imm, r1Forward, r2Forward, ID.predictJump}),
        .dout(EX)
    );

    PipelineMEM MEM;
    PipelineReg #($bits(MEM)) pipelineRegMEM(
        .clk(clk), .rst(rst), .clr(1'b0), .en(!halt), 
        .din({EX.PC, EX.IR, EX.signal, EX.rd, realR1, realR2, EX.imm, aluResult, EXHalt}),
        .dout(MEM)
    );

    PipelineWB WB;
    PipelineReg #($bits(WB)) pipelineRegWB(
        .clk(clk), .rst(rst), .clr(1'b0), .en(!halt), 
        .din({MEM.PC, MEM.IR, MEM.signal, MEM.rd, MEM.R1, MEM.R2, MEM.imm, MEM.aluResult, readData, MEM.halt}),
        .dout(WB)
    );

    
    // IF
    Register #(
        .WIDTH(WIDTH)
    ) regPC (
        .clk(clk), .rst(rst), .en(!halt && !loadUse), .din(PCNext), .dout(PC)
    );
    
    assign debug = PC;
    
    ROM #(
        .WIDTH(WIDTH), .PATH(PATH), .SIZE(ROM_SIZE)
    ) rom (
        .addr(PC[11:2]), .dout(IR)
    );

    assign predictError = EX.predictJump ^ branchTaken;
    // Branch prediction
    assign PCNext = predictError ? PCNorm : PCPred;
    always @(*) begin
        if (EX.signal.branch[0]) begin
            if (EX.signal.branch[1] ^ !aluResult) begin
                PCNorm = EX.PC + (EX.imm << 1);
                branchTaken = 1;
            end
            else begin
                PCNorm = EX.PC + 4;
                branchTaken = 0;
            end
        end
        else if (EX.signal.irOp == IR_JAL) begin
            PCNorm = EX.PC + (EX.imm << 1);
            branchTaken = 1;
        end
        else if (EX.signal.irOp == IR_JALR) begin
            PCNorm = realR1 + EX.imm;
            branchTaken = 1;
        end
        else begin
            PCNorm = PC + 4;
            branchTaken = 0;
        end
    end
    // LoadUse & BHB
    LoadUseGen loadUseGen (
        rs1, rs2, EX.rd, MEM.rd,
        EX.signal.load || EX.signal.irOp == IR_ECALL,
        r1Forward, r2Forward, loadUse
    );
    BHB #(
        .WIDTH(WIDTH), .SIZE(BHB_SIZE)
    ) bhb (
        .clk(clk), .rst(rst),
        .PC(PC), .EXPC(EX.PC), .EXBranchAddr(branchAddr), .EXBranch(EXBranch), .EXBranchTaken(branchTaken),
        .predictJump(predictJump), .jumpAddr(jumpAddr)
    );
    assign PCPred = predictJump ? jumpAddr : (PC+4);
    assign EXBranch = EX.signal.branch[0] || EX.signal.irOp == IR_JAL || EX.signal.irOp == IR_JALR;
    always @(*) begin
        if (EX.signal.branch[0] || EX.signal.irOp == IR_JAL)
            branchAddr = EX.PC + (EX.imm << 1);
        else if (EX.signal.irOp == IR_JALR)
            branchAddr = realR1 + EX.imm;
        else
            branchAddr = PC;
    end

    // ID
    Controller #(
        .WIDTH(WIDTH)
    ) controller (
        .ir(ID.IR), .rs1(rs1), .rs2(rs2), .rd(rd), .imm(imm), .signal(signal)
    );

    RegFile #(
        .WIDTH(WIDTH)
    ) regfile (
        .clk(clk), .rst(rst), .we(WB.signal.regWrite),
        .rW(WB.rd), .rA(rs1), .rB(rs2), .din(rDin),
        .r1(R1), .r2(R2)
    );

    always @(*) begin
        case (WB.signal.rDinSrc)
            1: rDin = WB.aluResult;
            2: rDin = WB.readData;
            3: rDin = WB.PC + 4;
            4: rDin = WB.imm << 12;
            5: rDin = WB.PC + (WB.imm << 12);
            default: rDin = 0;
        endcase
    end

    // EX
    ALU #(
        .WIDTH(WIDTH)
    ) alu (
        .X(realR1), .Y(EX.signal.aluSrcB ? EX.imm : realR2), .S(EX.signal.aluOp),
        .result(aluResult)
    );
    always @(*) begin
        case (EX.r1Forward)
            1: realR1 = rDin;
            2: realR1 = MEM.aluResult;
            default: realR1 = EX.R1;
        endcase
        case (EX.r2Forward)
            1: realR2 = rDin;
            2: realR2 = MEM.aluResult;
            default: realR2 = EX.R2;
        endcase
    end

    PipelineInterrupt #(
        .WIDTH(WIDTH)
    ) interrupt (
        .clk(clk), .rst(rst), .ecall(EX.signal.irOp == IR_ECALL),
        .R1(realR1), .R2(realR2),
        .ledData(ledData), .halt(EXHalt)
    );

    // MEM
    RAM #(
        .WIDTH(WIDTH),
        .SIZE(RAM_SIZE)
    ) ram (
        .clk(clk), .rst(rst), .we(MEM.signal.store),
        .mode(MEM.signal.ramMode), .addr(MEM.aluResult), .din(MEM.R2), .dout(readData)
    );

    // WB
    // always @(posedge clk) begin
    //     if (rst) halt <= 0;
    // end
    always @(posedge WB.halt) begin
        halt <= 1;
    end
    // assign halt = EXHalt;

    // assign PCOut = PC;
endmodule