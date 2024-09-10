`timescale 1ns / 1ps


module ROM_tb();
    localparam PATH = "C:/Data/HUST_RISC-V_CPU/FPGA/bin/risc-v-benchmark_ccab.hex";

    reg [31:0] addr;
    wire [31:0] out;
    ROM #(.PATH(PATH)) rom (addr, out);

    integer i;
    initial begin
        addr = 0;

        for (i = 0; i < 32; i = i + 1) begin
            #1 addr = addr + 1;
        end

        $finish;
    end
endmodule