`timescale 1ns/1ps

module RegFile_tb();

    parameter WIDTH = 32;

    // Testbench 变量
    reg clk;
    reg rst;
    reg we;
    reg [4:0] rA, rB, rW;
    reg [WIDTH-1:0] din;
    wire [WIDTH-1:0] r1, r2;

    RegFile #(.WIDTH(WIDTH)) regFile (
        .clk(clk),
        .rst(rst),
        .we(we),
        .rA(rA),
        .rB(rB),
        .rW(rW),
        .din(din),
        .r1(r1),
        .r2(r2)
    );

    always #5 clk = ~clk;  // 每隔5ns翻转时钟，产生一个周期为10ns的时钟

    initial begin
        clk = 0;
        rst = 1;
        we = 0;
        rA = 0;
        rB = 0;
        rW = 0;
        din = 0;

        #10;
        rst = 0;

        // 第一次写入：将数据 32'hDEADBEEF 写入寄存器 5
        #10;
        we = 1;
        rW = 5;
        din = 32'hDEADBEEF;
        #10;
        we = 0;

        // 读取寄存器 5 的值，期望 r1 = 32'hDEADBEEF
        rA = 5;
        #10;

        // 第二次写入：将数据 32'hCAFEBABE 写入寄存器 10
        #10;
        we = 1;
        rW = 10;
        din = 32'hCAFEBABE;
        #10;
        we = 0;

        // 读取寄存器 10 的值，期望 r2 = 32'hCAFEBABE
        rB = 10;
        #10;

        // 结束仿真
        $finish;
    end

endmodule
