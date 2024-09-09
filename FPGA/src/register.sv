`timescale 1ns / 1ps


module Register (
    clk, rst, en, din, dout
);
    parameter WIDTH = 32;
    input clk, rst, en;
    input [WIDTH-1:0] din;
    output reg dout;
    always @(posedge clk) begin
        if (rst) dout <= 0;
        else if (en) dout <= din;
    end
endmodule

module RegiFile(
    clk, we, rA, rB, rW, din,
    r1, r2
);
    parameter WIDTH = 32;

    input clk, we;
    input [4:0] rA, rB, rW;
    input [WIDTH-1:0] din;
    output [WIDTH-1:0] r1, r2;

    integer regs [0:31];

    assign r1 = regs[rA];
    assign r2 = regs[rB];

    always @(posedge clk) begin
        if (we) regs[rW] <= din;
    end
endmodule