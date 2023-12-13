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
class gen;  
    Packet pkt2send;
    bit[31:0] inst_arr[$];
    int pkts_generated = 500;
    shortreal result_cov = 0;
    shortreal result_cov_int = 0;
    shortreal result_cov_load = 0;
    shortreal result_cov_store = 0;
    shortreal result_cov_branch = 0;
    bit jal_yet = 0;
    bit jalr_yet = 0;
    bit lui_yet = 0;
    bit auipc_yet = 0;
    bit[6:0] funct7, opcode;
    bit[2:0] funct3;
    bit ll = 0;
    int f;
    string l;
    
    covergroup Cov() ;
        coverpoint opcode {
            bins op = {7'b0110011}; 
            bins op1 = {7'b0010011}; 
            bins op2 = {7'b0100011}; 
            bins op3 = {7'b0110111}; 
            bins op4 = {7'b0000011}; 
            bins op5 = {7'b0010111}; 
            bins op6 = {7'b1101111}; 
            bins op7 = {7'b1100111};             
        }  
        coverpoint funct7 { 
            bins f7 = {0}; 
            bins f72 = {32};
        }
        coverpoint funct3 { 
           bins f3 = {0};
           bins f31 = {1};
           bins f32 = {2};
           bins f33 = {3};
           bins f34 = {4};
           bins f35 = {5};
           bins f36 = {6};
           bins f37 = {7};
         }
        
    endgroup: Cov;
    /////////////////////////////////////////////////////////////////////////
    covergroup Integer_coverage();
        coverpoint opcode {
            bins op_int0 = {7'b0110011};
            bins op_int1 = {7'b0010011};
        }
        coverpoint funct3 {
            bins f3_int0 = {0};
            bins f3_int1 = {1};
            bins f3_int2 = {2};
            bins f3_int3 = {3};
            bins f3_int4 = {4};
            bins f3_int5 = {5};
            bins f3_int6 = {6};
            bins f3_int7 = {7};
        }
        coverpoint funct7 {
            bins f7_int0 = {0};
            bins f7_int1 = {32};
        }
    endgroup: Integer_coverage;
    ////////////////////////////////////////////////////////////////////////////
    covergroup Branch_coverage();
        coverpoint opcode {
            bins op_j0 = {7'b1100011};
        }

        coverpoint funct3{
            bins f3_j0 = {0};
            bins f3_j1 = {1};
            bins f3_j2 = {4};
            bins f3_j3 = {5};
            bins f3_j4 = {6};
            bins f3_j5 = {7};
        }
    endgroup: Branch_coverage;
    ////////////////////////////////////////////////////////////////////////////
    covergroup Load_coverage(); /// except LUI
        coverpoint opcode {
            bins op_l0 = {7'b0000011};
        }
        coverpoint funct3 {        
            bins f3_l0 = {0};
            bins f3_l1 = {1};
            bins f3_l2 = {2};
            bins f3_l3 = {4};
            bins f3_l4 = {5};
        }
    endgroup: Load_coverage;
    ////////////////////////////////////////////////////////////////////////////
    covergroup Store_coverage();
        coverpoint opcode {
            bins op_s0 = {7'b0100011};
        }
        coverpoint funct3 {
            bins f3_s0 = {0};
            bins f3_s1 = {1};
            bins f3_s2 = {2};
        }
    endgroup: Store_coverage;
    //////////////////////////////////////////////////////////////////////////////
    function new ();
        Cov = new;
        Integer_coverage = new;
        Branch_coverage = new ;
        Load_coverage = new;
        Store_coverage = new;
    endfunction 
    task check();
            funct7 = pkt2send.funct7;
            funct3 = pkt2send.funct3;
            opcode = pkt2send.opcode;         
    endtask: check;
    
    task gen_integer();
    for (int i = 0; i<pkts_generated; i++) begin       
        $display("\nINS[%0d]:", i);
        l.itoa(i);
        pkt2send = new(l);
        pkt2send.mode_test(0);
        pkt2send.randomize();
        assert(pkt2send.randomize()) else 
        begin
            $display("GENERATE ERROR");
            $stop;
        end
        pkt2send.declare_operand();
        pkt2send.generated();
        check();
        Integer_coverage.sample();        
        inst_arr.push_back(pkt2send.instruction); 
        pkt2send.display("TEST_RISCV_SIDA_INTEGER_TYPE");
        ll = 0;
        result_cov_int = Integer_coverage.get_coverage();
        $display("Current Coverage of Integer type: %f", result_cov_int);
    end
    endtask: gen_integer;

    task gen_store_load();
    for (int i = 0; i<pkts_generated; i++) begin
        $display("\nINS[%0d]:", i);
        l.itoa(i);
        pkt2send = new(l);
        pkt2send.mode_test(1);
        pkt2send.randomize();
        assert(pkt2send.randomize()) else 
        begin
            $display("GENERATE ERROR");
            $stop;
        end
        pkt2send.declare_operand();
        pkt2send.generated();
        check();
        if (pkt2send.opcode == 7'b0110111) lui_yet = 1;
        if (pkt2send.opcode == 3) Load_coverage.sample(); 
        else if (pkt2send.opcode == 7'b0100011) Store_coverage.sample();
        inst_arr.push_back(pkt2send.instruction); 
        pkt2send.display("TEST_RISCV_SIDA_STORE_LOAD_TYPE");
        result_cov_load = Load_coverage.get_coverage();
        $display("Current Coverage of Load type: %f", result_cov_load);
        result_cov_store = Store_coverage.get_coverage();
        $display("Current Coverage of Store type: %f", result_cov_store);
    end
    endtask: gen_store_load;

    task gen_jump_branch();
    for (int i = 0; i<pkts_generated; i++) begin
        $display("\nINS[%0d]:", i);
        l.itoa(i);
        pkt2send = new(l);
        pkt2send.mode_test(2);
        pkt2send.randomize();
        assert(pkt2send.randomize()) else 
        begin
            $display("GENERATE ERROR");
            $stop;
        end
        pkt2send.declare_operand();
        pkt2send.generated();
        check();
        if (pkt2send.opcode == 7'b1101111) jal_yet = 1;
        if (pkt2send.opcode == 7'b1100111) jalr_yet = 1;
        if (pkt2send.opcode == 7'b0010111) auipc_yet = 1;
        if (pkt2send.opcode == 7'b1100011) Branch_coverage.sample(); 
        inst_arr.push_back(pkt2send.instruction); 
        pkt2send.display("TEST_RISCV_SIDA_JUMP_AND_BRANCH_TYPE");
        result_cov_branch = Branch_coverage.get_coverage();
        $display("Current Coverage of Branch type: %f", result_cov_branch);
    end
    endtask: gen_jump_branch;


    task gen_all();
    for (int i = 0; i<pkts_generated; i++) begin
        $display("\nINS[%0d]:", i);
        l.itoa(i);
        pkt2send = new(l);
        pkt2send.now = i;
        pkt2send.mode_test(3);
        pkt2send.randomize();
        assert(pkt2send.randomize()) else 
        begin
            $display("GENERATE ERROR");
            $stop;
        end
        pkt2send.declare_operand();
        pkt2send.generated();
        check();
        if (pkt2send.opcode == 7'b1101111) jal_yet = 1;
        if (pkt2send.opcode == 7'b1100111) jalr_yet = 1;
        if (pkt2send.opcode == 7'b0010111) auipc_yet = 1;
        if (pkt2send.opcode == 7'b1100011) Branch_coverage.sample(); 
        if (pkt2send.opcode == 7'b0110111) lui_yet = 1;
        if (pkt2send.opcode == 3) Load_coverage.sample(); 
        if (pkt2send.opcode == 7'b0100011) Store_coverage.sample();
        if (pkt2send.opcode == 7'b0110011 || pkt2send.opcode == 7'b0010011) Integer_coverage.sample();    
        inst_arr.push_back(pkt2send.instruction); 
        pkt2send.display("TEST_RISCV_SIDA_ALL_TYPE");
        result_cov_int = Integer_coverage.get_coverage();
        $display("Current Coverage of Integer type: %f", result_cov_int);

        result_cov_load = Load_coverage.get_coverage();
        $display("Current Coverage of Load type: %f", result_cov_load);
        result_cov_store = Store_coverage.get_coverage();
        $display("Current Coverage of Store type: %f", result_cov_store);

        result_cov_branch = Branch_coverage.get_coverage();
        $display("Current Coverage of Branch type: %f", result_cov_branch);


    end
    endtask: gen_all;
    
    task show_hex();
        f = $fopen("./HEX_CODE.txt", "w");
        $fdisplay(f,"HEX CODE:");
        foreach (inst_arr[x]) begin
            $fdisplay(f,"  INS[%0d]: %h", x, inst_arr[x]);
        end
        $fclose(f);
    endtask: show_hex;
endclass: gen;
//#######################################################################################################################################################
class driver;   
     bit[10239:0] load_ins;
     bit[1023:0] load_data_rgf;
     bit[31:0] inst_arr[$];
     int num_of_ins;
     virtual yourcpu_io.tb x;
     function new(virtual yourcpu_io.tb t);
        x = t;
     endfunction: new;
     task get_infor(bit[31:0] inst_arr[$], int num);
        this.inst_arr = inst_arr;
        num_of_ins = num;
     endtask: get_infor;  
      
     task drive();
     foreach (inst_arr[x]) begin
     load_ins[(x*32)+31-:32] = inst_arr[x]; 
     end
     load_data_rgf = 1024'h0000000000000004000000080000000c0000001000000014000000180000001c0000002000000024000000280000002c0000003000000034000000380000003c0000004000000044000000480000004c0000005000000054000000580000005c0000006000000064000000680000006c0000007000000078000000740000007c;   //initial value for register  
     endtask: drive;
  
    task exe();
         x.load_ins[223:0] = 224'h010002ef401101b3018002ef000214630001a233402081b306302023; //code for ABS
         x.load_ins[10239:224] = load_ins[10239:0];
         x.load_ins[(10176 + 32 - 1 ) -:32] = 64'h00000667;
         x.load_data_rgf = load_data_rgf;
    endtask
endclass: driver;
//#######################################################################################################################################################
program automatic test(yourcpu_io.tb t);
parameter cycle = 10;
int ii = 0;
gen a;
driver d;
int f,ff;


    initial begin
        f = $fopen("./REGISTER_STATUS.txt", "w");
        ff = $fopen("./DMEM_STATUS.txt", "w");
        a = new();
        d = new(t);
        //#######CHOOSE TEST MODE############
        a.gen_all();
       // a.gen_integer();
      //  a.gen_store_load();
      //  a.gen_jump_branch();
        a.show_hex();
        d.get_infor(a.inst_arr, a.pkts_generated);
        d.drive();
        d.exe();
        run();
        
    end
    
    task run();
       // t.load_ins[543:0] = 544'h00100f93fe0b02e300022b3340218233fc0a1ee3000a0a630040809300450533015a0a33000b1c6300022b33403102330280a1830000a10300000513fff00a9300a00a13; //code for SAD


        /////////////////////////////////////////////////////////// FOR BRANCH TEST///////////////////////////////////////////////
//        t.load_ins = 160'hfea04ae3fea85ee3000294630000846300000093;
//         .L0:
//         	beq x1, x0, .L2;
//         .L1:
//         	bne x5, x0, .L4;
//         .L2:
//         	bge x16, x10, .L1;
//         .L4: 
//         	blt x0, x10, .L0;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
      //  t.load_data_rgf = 0 ;
        #(cycle/2) t.reset = 1;
        #(cycle) t.reset = 0;
        forever #20 begin   
            $fdisplay(f,"Data Register File at %0d instruction:", ii);
            for (int j = 0; j < 32; j++) begin
                $fwrite(f,"Reg[%0d]:%0d ", j, $signed(io.dut.data_register_file[((j*32)+31)-:32]));
                $fwrite(ff,"DMEM[%0d]:%0d ", j, $signed(io.dut.dmem[((j*32)+31)-:32]));
                if ((j+1)%8 == 0) begin
                    $fdisplay(f,"");
                    $fdisplay(ff,"");
                end
            end
            $fdisplay(f,"PC: %0d", io.dut.pc);
            $fdisplay(f,"CODE RUN: %h", io.dut.inst_out);
            $fdisplay(ff,"PC: %0d", io.dut.pc);
            $fdisplay(ff,"CODE RUN: %h", io.dut.inst_out);
            ii = ii + 1;
        
            $fdisplay(f,"\n");
            $fdisplay(ff,"\n");
            if (ii == a.pkts_generated+240) begin
                 $fclose(f);
                 $fclose(ff);
                 $display("Coverage Integer type: %f", a.result_cov_int);
                 $display("Coverage Load type: %f", a.result_cov_load);
                 $display("Coverage Store type: %f", a.result_cov_store);
                 $display("Coverage Branch type: %f", a.result_cov_branch);
                 $display("Coverage JAL: %0d", a.jal_yet);
                 $display("Coverage JALR: %0d", a.jalr_yet);
                 $display("Coverage LUI: %0d", a.lui_yet);
                 $display("Coverage AUIPC: %0d", a.auipc_yet);
                 $display("Coverage All type: %f",0.25*(a.result_cov_branch+a.result_cov_int+a.result_cov_load+a.result_cov_store));
                 $stop;
            end
         end 
    endtask: run;
endprogram
