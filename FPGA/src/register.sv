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
    always @(posedge clk) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 32; ++i) begin
                regs[i] <= 0;
            end
        end
        else if (we) begin
            regs[rW] <= din;
        end
    end
endmodule