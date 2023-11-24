`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: IMEM
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


module IMEM(
    input clk,
    input[31:0] out_m5, out_m2,
    input[1023:0] load_ins,
    input reset,
    output reg[31:0] inst_out
);
reg[1023:0] imem;
    always @(posedge clk) begin
        if (reset) begin
             inst_out <= 0;
             imem[1023:32] <= load_ins;
        end
        else begin
            inst_out <= imem[((8*(out_m5+out_m2))+31)-:32];
        end
    end
endmodule
