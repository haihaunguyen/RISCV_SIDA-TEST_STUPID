`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: DMEM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DMEM(
    input clk, reset, 
    input[1:0] rwe,
    input[31:0] Data_in,
    input[6:0] Addr,
    output reg[31:0] Data_out
    );
    reg[1023:0] dmem;
    always @(*) begin
        if (reset == 1) begin 
            dmem[((8*0)+31)-:32] <= 5; 
            dmem[((8*4)+31)-:32] <= 16; 
            dmem[((8*8)+31)-:32] <= 7;
            dmem[((8*12)+31)-:32] <= 1;
            dmem[((8*16)+31)-:32] <= 1;
            dmem[((8*20)+31)-:32] <= 13;
            dmem[((8*24)+31)-:32] <= 2;
            dmem[((8*28)+31)-:32] <= 8;
            dmem[((8*32)+31)-:32] <= 10;
            
            dmem[((8*40)+31)-:32] <= 4; 
            dmem[((8*44)+31)-:32] <= 15; 
            dmem[((8*48)+31)-:32] <= 8;
            dmem[((8*52)+31)-:32] <= 0;
            dmem[((8*56)+31)-:32] <= 2;
            dmem[((8*60)+31)-:32] <= 12;
            dmem[((8*64)+31)-:32] <= 3;
            dmem[((8*68)+31)-:32] <= 7;
            dmem[((8*72)+31)-:32] <= 11;
            
        end
        else begin
            if (rwe == 0) begin //read
                Data_out <= dmem[((8*Addr)+31)-:32];
            end else
            if (rwe == 1) begin //SW
                dmem[((8*Addr)+31)-:32] <= Data_in;
            end else
            if (rwe == 2) begin // SH
                dmem[((8*Addr)+15)-:16] <= Data_in[15:0];
            end else
            if (rwe == 3) begin //SB
                dmem[((8*Addr)+7)-:8] <= Data_in[7:0];
            end
        end
    end
    
endmodule
