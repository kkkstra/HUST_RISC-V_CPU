`timescale 1ns / 1ps


module Interrupt (
    clk, rst, ecall, R1, R2,
    ledData, halt
);
    parameter WIDTH = 32;

    input clk, rst, ecall;
    input integer R1, R2;
    output reg [WIDTH-1:0] ledData;
    output reg halt;

    initial halt <= 0;

    always @(posedge clk) begin
        if (rst) {ledData, halt} <= 0;
        else if (ecall) case (R1)
            'h0a: halt <= 1;
            'h22: ledData <= R2;
        endcase
    end
endmodule

module PipelineInterrupt (
    clk, rst, ecall, R1, R2,
    ledData, halt
);
    parameter WIDTH = 32;

    input clk, rst, ecall;
    input integer R1, R2;
    output reg [WIDTH-1:0] ledData;
    output halt;

    assign halt = ecall && R1 != 'h22;

    always @(posedge clk) begin
        if (rst) ledData <= 0;
        else if (ecall && R1 == 'h22) ledData <= R2;
    end
endmodule