`timescale 1ns / 1ps
`include"Packet.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 09:13:49 PM
// Design Name: 
// Module Name: test
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


program automatic test(yourcpu_io.tb t);
parameter cycle = 10;
int ii = 0;
int num_of_ins = 5;
int f;
bit[31:0] inst_arr[$];
    initial begin
        f = $fopen("./REGISTER_STATUS.txt", "w");
        gen();
        driver();
       
    end
    task gen();  
    Packet a;
    for (int i = 0; i<num_of_ins; i++) begin
        $display("\nINS[%0d]:", i);
        a = new("CODE_FOR_LAB_5");
        a.randomize();
        a.declare_operand();
        a.generated();
        inst_arr.push_back(a.instruction);
        
        a.display("TEST_RISCV_SIDA");
    end
    $display("\n\nHEX CODE:");
    foreach (inst_arr[x]) begin
        $display("  INS[%0d]: %h", x, inst_arr[x]);
    end
    endtask: gen;
    
    task driver(); 
              
         foreach (inst_arr[x]) begin
         t.load_ins[(x*32)+31-:32] = inst_arr[x]; 
         end
         t.load_data_rgf = 1024'h000000290000002800000027000000260000002500000024000000230000002200000021000000200000001f0000001e0000001d0000001c0000001b0000001a000000190000001800000017000000160000001500000014000000130000001200000011000000100000000f0000000e0000000d0000000c0000000b0000000a;   //initial value for register
         #(cycle/2) t.reset = 1;
         #(cycle) t.reset = 0;
         forever #20 begin   
            $fdisplay(f,"Data Register File at %0d instruction:", ii);
            for (int j = 0; j < 32; j++) $fwrite(f,"Reg[%0d]:%0d ", j, $signed(io.dut.data_register_file[((j*32)+31)-:32]));
            $fdisplay(f,"\nPC: %0d", io.dut.pc-4);
            ii = ii + 1;
            $fdisplay(f,"\n");
            if (ii == num_of_ins+2) begin
                 $fclose(f);
                 $stop;
            end
        end
       
    endtask: driver;
endprogram
