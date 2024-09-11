`timescale 1ns / 1ps


module ROM(
    addr, dout
);
    parameter WIDTH = 32;
    parameter PATH = "";
    parameter SIZE = 10;

    input [SIZE-1:0] addr;
    output [WIDTH-1:0] dout;

    reg [WIDTH-1:0] data [0:(1<<SIZE)-1];

    initial begin
        integer i;
        for (i = 0; i < (1 << SIZE); ++i)
            data[i] = 0;
        $readmemh(PATH, data);
    end

    assign dout = data[addr];

endmodule