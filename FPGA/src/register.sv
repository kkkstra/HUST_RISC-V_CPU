`timescale 1ns / 1ps


module Register (
    clk, rst, en, din, dout
);
    parameter WIDTH = 32;
    input clk, rst, en;
    input [WIDTH-1:0] din;
    output reg [WIDTH-1:0] dout;
    always @(posedge clk) begin
        if (rst) dout <= 0;
        else if (en) dout <= din;
    end
endmodule

module RegFile(
    clk, rst, we,
    rA, rB, rW, din,
    r1, r2
);
    parameter WIDTH = 32;

    input clk, rst, we;
    input [4:0] rA, rB, rW;
    input [WIDTH-1:0] din;
    output [WIDTH-1:0] r1, r2;

    integer regs [0:31];

    assign r1 = regs[rA];
    assign r2 = regs[rB];

    // TODO: change posedge to negedge
    always @(negedge clk) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 32; ++i) begin
                regs[i] <= 0;
            end
        end
        else if (we) begin
            if (rW) regs[rW] <= din;
        end
    end
endmodule

module PipelineReg (
    clk, rst, clr, en, din, dout
);
    parameter WIDTH;

    input clk, rst, clr, en;
    input [WIDTH-1:0] din;
    output reg [WIDTH-1:0] dout;

    always @(posedge clk) begin
        if (clr || rst) dout <= 0;
        else if (en) dout <= din;
    end
endmodule


typedef struct packed {
    logic [31:0] PC, IR;
    logic predictJump;
} PipelineID;

typedef struct packed {
    logic [31:0] PC, IR;
    Signal signal;
    logic [4:0] rd;
    logic [31:0] R1, R2, imm;
    logic [1:0] r1Forward, r2Forward;
    logic predictJump;
} PipelineEX;

typedef struct packed {
    logic [31:0] PC, IR;
    Signal signal;
    logic [4:0] rd;
    logic [31:0] R1, R2, imm;
    logic [31:0] aluResult;
    logic halt;
} PipelineMEM;

typedef struct packed {
    logic [31:0] PC, IR;
    Signal signal;
    logic [4:0] rd;
    logic [31:0] R1, R2, imm;
    logic [31:0] aluResult;
    logic [31:0] readData;
    logic halt;
} PipelineWB;