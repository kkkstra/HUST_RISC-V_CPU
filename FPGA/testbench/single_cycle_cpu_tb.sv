`timescale 1ns / 1ps


module SingleCycleCPU_tb();
    localparam PATH = "C:/Data/HUST_RISC-V_CPU/FPGA/bin/risc-v-benchmark_ccab.hex";
    reg clk, rst;
    wire [31:0] ledData, PC;
    SingleCycleCPU #(.PATH(PATH)) cpu (.clk(clk), .rst(rst), .ledData(ledData), .PCOut(PC));
    initial begin
        {rst, clk} = 'b11;
        #0.6 rst = 0;
    end
    always #0.5 clk = ~clk;
endmodule