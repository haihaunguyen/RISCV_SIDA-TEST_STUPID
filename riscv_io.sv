`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 05:17:17 PM
// Design Name: 
// Module Name: riscv_io
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


interface yourcpu_io(input bit clk);
    bit reset;
    bit[10239:0] load_ins, load_data_rgf, data_register_file;
    logic[31:0] pc, inst_out;   
    bit[1023:0] dmem;
    clocking cb @(posedge clk);  
        output reset;
        output load_ins, load_data_rgf;
        input data_register_file;
        input pc, inst_out;
    endclocking: cb
    
    clocking cb1 @(posedge clk);  
        output data_register_file;
    endclocking: cb1
    
    modport tb(clocking cb, input clk, output reset, load_ins, load_data_rgf);
    modport dut(input clk, reset, load_ins, load_data_rgf, output pc, inst_out, data_register_file, dmem);
endinterface: yourcpu_io
