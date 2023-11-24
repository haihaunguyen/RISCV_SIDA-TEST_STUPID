`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 09:07:39 PM
// Design Name: 
// Module Name: youcpu_test_top
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


module youcpu_test_top();
    parameter cycle = 10;
    reg clk;
    reg[1023:0] x;
    integer i = 0;;
    yourcpu_io io(clk);
    
    datapath dut(.clk(io.dut.clk), .pc(io.dut.pc), .reset(io.dut.reset), 
    .load_ins(io.dut.load_ins), .load_data_rgf(io.dut.load_data_rgf),
     .data_register_file(io.dut.data_register_file), .inst_out(io.dut.inst_out)); 
     
    test test_program(io.tb);
    initial begin
        clk = 0;
        forever #10 begin 
            clk = !clk;        
        end  
             
    end

endmodule
