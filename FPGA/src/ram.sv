`timescale 1ns / 1ps

module RAM(
    clk, rst, we, 
    mode, addr, din, dout
);
    parameter WIDTH = 32;
    parameter SIZE = 10;

    input clk, rst, we;
    input [2:0] mode;
    input [SIZE+2-1:0] addr;
    input [WIDTH-1:0] din;
    output reg [WIDTH-1:0] dout;

    reg [WIDTH-1:0] data [0:(1<<SIZE)-1];

    // write
    always @(posedge clk) begin
        if (rst) begin
            integer i;
            for (i = 0; i < (1 << SIZE); ++i) data[i] <= 0;
        end
        else if (we) begin
            case (mode[1:0])
                2'b00: case (addr[1:0])
                    3: data[addr>>2][31:24] <= din[7:0];
                    2: data[addr>>2][23:16] <= din[7:0];
                    1: data[addr>>2][15:8] <= din[7:0];
                    default: data[addr>>2][7:0] <= din[7:0];
                endcase
                2'b01: case (addr[1])
                    1: data[addr>>2][31:16] <= din[15:0];
                    default: data[addr>>2][15:0] <= din[15:0];
                endcase
                default: data[addr>>2] <= din[31:0];
            endcase
        end
    end

    // read
    always @(*) begin
        case (mode)
            3'b000: case (addr[1:0])
                3: dout = signed'(data[addr>>2][31:24]);
                2: dout = signed'(data[addr>>2][23:16]);
                1: dout = signed'(data[addr>>2][15:8]);
                default: dout = signed'(data[addr>>2][7:0]);
            endcase
            3'b001: case (addr[1])
                1: dout = signed'(data[addr>>2][31:16]);
                default: dout = signed'(data[addr>>2][15:0]);
            endcase
            3'b100: case (addr[1:0])
                3: dout = data[addr>>2][31:24];
                2: dout = data[addr>>2][23:16];
                1: dout = data[addr>>2][15:8];
                default: dout = data[addr>>2][7:0];
            endcase
            3'b101: case (addr[1])
                1: dout = data[addr>>2][31:16];
                default: dout = data[addr>>2][15:0];
            endcase
            default: dout = data[addr>>2];
        endcase
    end
endmodule