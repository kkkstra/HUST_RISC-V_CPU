`timescale 1ns / 1ps


module Clock #(
    parameter N = 10_000_000
) (
    clk, clk_N
);
    input clk;      
    output reg clk_N;

    reg [31:0] counter;

    initial begin
        counter = 0;
        clk_N = 0;
    end
    
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter > N / 2) begin
            clk_N <= ~clk_N;
            counter <= 0;
        end
    end
endmodule

module SegDecoder (
    input [3:0] digit,
    output reg [7:0] seg
);
    always @* begin
        case (digit)
            4'b0000 : seg[7:0] = 8'b11000000;
            4'b0001 : seg[7:0] = 8'b11111001;
            4'b0010 : seg[7:0] = 8'b10100100;
            4'b0011 : seg[7:0] = 8'b10110000;
            4'b0100 : seg[7:0] = 8'b10011001;
            4'b0101 : seg[7:0] = 8'b10010010;
            4'b0110 : seg[7:0] = 8'b10000010;
            4'b0111 : seg[7:0] = 8'b11111000;
            4'b1000 : seg[7:0] = 8'b10000000;
            4'b1001 : seg[7:0] = 8'b10011000;
            4'b1010 : seg[7:0] = 8'b10001000;
            4'b1011 : seg[7:0] = 8'b10000011;
            4'b1100 : seg[7:0] = 8'b11000110;
            4'b1101 : seg[7:0] = 8'b10100001;
            4'b1110 : seg[7:0] = 8'b10000110;
            default : seg[7:0] = 8'b10001110;
        endcase
    end
endmodule

module HexDisplay #(
    parameter T = 16
) (
    input rawClk,
    input int num,
    output bit [7:0] an,
    output [7:0] seg
);
    bit clk;
    Clock #(.T(T)) clkDiv (rawClk, clk);
    
    int pos;
    bit [3:0] digit;
    SegDecoder decoder (digit, seg);
    
    always @(posedge clk) begin
        pos <= pos == 7? 0 : pos + 1;
        an <= ~(1 << pos);
        digit <= num >> (pos << 2);
    end
endmodule

module Top(
    input CLK100MHZ,
    input RESETN,
    input [15:0] SW,
    input [4:0] BTN,
    
    inout PS2_CLK,
    inout PS2_DATA,
    
    output [7:0] AN,
    output [7:0] SEG,
    output [15:0] LED
);
    localparam PATH = `"/path/to/program.hex`";

    // LED
    int ledData;
    HexDisplay #(.N(16)) display (CLK100MHZ, ledData, AN, SEG);
    
    // CPU
    wire clk, rst, halt;
    assign rst = !RESETN;
    Clock #(.N(2)) CPUClock (CLK100MHZ, clk);
    SingleCycleCPU #(
        .WIDTH(32), .PATH(PATH), .ROM_SIZE(10), .RAM_SIZE(10)
    ) cpu (
        .clk(clk), .rst(rst), .ledData(ledData), .halt(halt)
    );

    assign LED[0] = halt;
endmodule