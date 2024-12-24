`timescale 1ns / 1ps


module BHB(
    clk, rst,
    PC, EXPC, EXBranchAddr, EXBranch, EXBranchTaken,
    predictJump, jumpAddr
);
    parameter WIDTH = 32;
    parameter SIZE = 8;
    
    input clk, rst;
    input [WIDTH-1:0] PC, EXPC, EXBranchAddr;
    input EXBranch, EXBranchTaken;
    output reg predictJump;
    output reg [WIDTH-1:0] jumpAddr;

    reg valid [0:SIZE-1];
    reg [1:0] predict [0:SIZE-1];
    reg [WIDTH-1:0] tag [0:SIZE-1], timer [0:SIZE-1], addr[0:SIZE-1];
    reg match [0:SIZE-1], load [0:SIZE-1];
    reg write [0:SIZE-1];

    always @(*) begin
        integer i, maxTimer, maxTimerIndex;
        bit found, hit, miss;
        hit = 0;
        for (i = 0; i < SIZE; ++i) begin
            if (valid[i] && EXPC == tag[i]) begin
                match[i] = 1;
                hit = 1;
            end
            else match[i] = 0;
        end
        miss = !hit;
        
        found = 0;
        if (EXBranch && miss) begin
            for (i = SIZE - 1; i >= 0; --i) begin
                if (!found && !valid[i]) begin
                    write[i] = 1;
                    found = 1;
                end
                else write[i] = 0;
            end

            if (!found) begin
                maxTimer = 0;
                maxTimerIndex = -1;
                for (i = 0; i < SIZE; ++i) begin
                    if (timer[i] > maxTimer) begin
                        maxTimer = timer[i];
                        maxTimerIndex = i;
                    end
                end
                write[maxTimerIndex] = 1;
            end
        end
        else begin
            for (i = SIZE - 1; i >= 0; --i) write[i] = 0;
        end
        
        jumpAddr = 0;
        predictJump = 0;
        for (i = 0; i < SIZE; ++i) begin
            if (valid[i] && PC == tag[i]) begin
                load[i] = 1;
                jumpAddr = addr[i];
                predictJump = predict[i][1];
            end
            else load[i] = 0;
        end
    end

    always @(posedge clk) begin
        integer i;
        if (rst) begin
            for (i = 0; i < SIZE; ++i) begin
                valid[i] <= 0;
                tag[i] <= 0;
                timer[i] <= 0;
                predict[i] <= 0;
                addr[i] <= 0;
            end
        end
        else begin
            for (i = 0; i < SIZE; ++i) begin
                if (write[i]) begin
                    valid[i] <= 1;
                    tag[i] <= EXPC;
                    addr[i] <= EXBranchAddr;
                end
                if (write[i] || load[i]) begin
                    timer[i] <= 0;
                end
                else timer[i] <= timer[i] + 1;
                if (match[i] && EXBranch) begin
                    if (EXBranchTaken) begin
                        case (predict[i])
                            2'b00: predict[i] <= 2'b01;
                            2'b01: predict[i] <= 2'b10;
                            2'b10: predict[i] <= 2'b10;
                            2'b11: predict[i] <= 2'b10;
                        endcase
                    end
                    else begin
                        case (predict[i])
                            2'b00: predict[i] <= 2'b00;
                            2'b01: predict[i] <= 2'b00;
                            2'b10: predict[i] <= 2'b11;
                            2'b11: predict[i] <= 2'b00;
                        endcase
                    end
                end
            end
        end
    end

endmodule