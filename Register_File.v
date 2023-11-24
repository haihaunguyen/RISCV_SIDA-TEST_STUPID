`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 11:33:40 PM
// Design Name: 
// Module Name: Register_File
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


module Register_File(
    input clk, reset,
    input[2:0] rwe,
    input[31:0] Data_D, 
    input[4:0] Addr_D, Addr_A, Addr_B,
    output reg[31:0] Data_A, Data_B,
    input[1023:0] load_data_rgf,
    output wire[1023:0] data_register_file
    );
    reg[31:0] r[0:31];
    assign data_register_file[((0*32)+31)-:32] = r[0];
    assign data_register_file[((1*32)+31)-:32] = r[1];
    assign data_register_file[((2*32)+31)-:32] = r[2];
    assign data_register_file[((3*32)+31)-:32] = r[3];
    assign data_register_file[((4*32)+31)-:32] = r[4];
    assign data_register_file[((5*32)+31)-:32] = r[5];
    assign data_register_file[((6*32)+31)-:32] = r[6];
    assign data_register_file[((7*32)+31)-:32] = r[7];
    assign data_register_file[((8*32)+31)-:32] = r[8];
    assign data_register_file[((9*32)+31)-:32] = r[9];
    assign data_register_file[((10*32)+31)-:32] = r[10];
    assign data_register_file[((11*32)+31)-:32] = r[11];
    assign data_register_file[((12*32)+31)-:32] = r[12];
    assign data_register_file[((13*32)+31)-:32] = r[13];
    assign data_register_file[((14*32)+31)-:32] = r[14];
    assign data_register_file[((15*32)+31)-:32] = r[15];
    assign data_register_file[((16*32)+31)-:32] = r[16];
    assign data_register_file[((17*32)+31)-:32] = r[17];
    assign data_register_file[((18*32)+31)-:32] = r[18];
    assign data_register_file[((19*32)+31)-:32] = r[19];
    assign data_register_file[((20*32)+31)-:32] = r[20];
    assign data_register_file[((21*32)+31)-:32] = r[21];
    assign data_register_file[((22*32)+31)-:32] = r[22];
    assign data_register_file[((23*32)+31)-:32] = r[23];
    assign data_register_file[((24*32)+31)-:32] = r[24];
    assign data_register_file[((25*32)+31)-:32] = r[25];
    assign data_register_file[((26*32)+31)-:32] = r[26];
    assign data_register_file[((27*32)+31)-:32] = r[27];
    assign data_register_file[((28*32)+31)-:32] = r[28];
    assign data_register_file[((29*32)+31)-:32] = r[29];
    assign data_register_file[((30*32)+31)-:32] = r[30];
    assign data_register_file[((31*32)+31)-:32] = r[31];
    
    always @(clk) begin
        if (reset == 1) begin
        r[0] <= 0;
        r[1] <= load_data_rgf[((1*32)+31)-:32];
        r[2] <= load_data_rgf[((2*32)+31)-:32];
        r[3] <= load_data_rgf[((3*32)+31)-:32];
        r[4] <= load_data_rgf[((4*32)+31)-:32];
        r[5] <= load_data_rgf[((5*32)+31)-:32];
        r[6] <= load_data_rgf[((6*32)+31)-:32];
        r[7] <= load_data_rgf[((7*32)+31)-:32];
        r[8] <= load_data_rgf[((8*32)+31)-:32];
        r[9]  <= load_data_rgf[((9*0)+31)-:32];
        r[10] <= load_data_rgf[((10*32)+31)-:32];
        r[11] <= load_data_rgf[((11*32)+31)-:32];
        r[12] <= load_data_rgf[((12*32)+31)-:32];
        r[13] <= load_data_rgf[((13*32)+31)-:32];
        r[14] <= load_data_rgf[((14*32)+31)-:32];
        r[15] <= load_data_rgf[((15*32)+31)-:32];
        r[16] <= load_data_rgf[((16*32)+31)-:32];
        r[17] <= load_data_rgf[((17*32)+31)-:32];
        r[18] <= load_data_rgf[((18*32)+31)-:32];
        r[19] <= load_data_rgf[((19*32)+31)-:32];
        r[20] <= load_data_rgf[((20*32)+31)-:32];
        r[21] <= load_data_rgf[((21*32)+31)-:32];
        r[22] <= load_data_rgf[((22*32)+31)-:32];
        r[23] <= load_data_rgf[((23*32)+31)-:32];
        r[24] <= load_data_rgf[((24*32)+31)-:32];
        r[25] <= load_data_rgf[((25*32)+31)-:32];
        r[26] <= load_data_rgf[((26*32)+31)-:32];
        r[27] <= load_data_rgf[((27*32)+31)-:32];
        r[28] <= load_data_rgf[((28*32)+31)-:32];
        r[29] <= load_data_rgf[((29*32)+31)-:32];
        r[30] <= load_data_rgf[((30*32)+31)-:32];     
        r[31] <= load_data_rgf[((31*32)+31)-:32]; 
        end else if (reset == 0)
        begin
             //read
            Data_A <= r[Addr_A];
            Data_B <= r[Addr_B];
     
            if (rwe == 1) begin //write
                r[Addr_D] <= Data_D;
            end else
            if (rwe == 2) begin //lh
                r[Addr_D][15:0] <= Data_D[15:0];
            end else
            if (rwe == 3) begin //lb
                r[Addr_D][7:0] <= Data_D[7:0];
            end else
            if (rwe == 4) begin //lhu
                r[Addr_D][31:16] <= 0;
                r[Addr_D][15:0] <= Data_D[15:0];
            end else
            if (rwe == 5) begin //lbu
                r[Addr_D][31:8] <= 0;
                r[Addr_D][7:0] <= Data_D[7:0];
            end
        end
    end  
endmodule
