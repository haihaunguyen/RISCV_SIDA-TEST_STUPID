class Packet;
    int now;
    rand bit[6:0] opcode;
    rand bit[4:0] rs1, rs2, rd;
    rand bit[31:0] imm;
    rand bit[2:0] funct3;
    rand bit[6:0] funct7;
    string name, content;
    bit[31:0] instruction;
    typedef enum {ADD = 0, SUB , SLL , SLT , SLTU , XOR , SRL , SRA , OR , AND, JALR, LB, LH, LW, LBU, LHU, SB, SH,SW, AUIPC, LUI, JAL, BEQ, BNE, BLT, BGE, BLTU, BGEU, ERROR} operand;
    operand op = ERROR;

    constraint Integer_Instruction{
        opcode inside{7'b0110011, 7'b0010011};
        funct3 inside{0, 3'b001,3'b010,3'b011,3'b100,3'b101,3'b110,3'b111};
        funct7 inside{0, 32};  
        rd inside {[1:31]};
    }
    
    constraint Load_Store_Instruction{
        opcode inside {7'b0100011, 7'b0110111, 7'b0000011};
        if (opcode inside {7'b0100011}) funct3 inside{0, 3'b001,3'b010};   //store
        else if (opcode inside {7'b0000011, 7'b0110111}) funct3 inside {0, 1, 2, 4, 5};  //load
        rd inside {[1:31]};
        imm inside {[0:128]};
    }

    constraint Jump_Branch_Instruction{
        opcode inside {7'b0010111, 7'b1101111, 7'b1100111, 7'b1100011}; // auipc jal jalr branch
        if (opcode inside {7'b1100111}){
            rs1 inside {0, 5,6,7};
        }
        rd inside {[1:31]};
        if (opcode inside {7'b1100011}) {
            funct3 inside {0, 1, 4, 5, 6, 7};
            imm inside {24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 124};
             
        }
       // rs1 inside {30};
        rs2 inside {31, 30, 1, 2};

    }
    // constraint All_Instruction{
    //     opcode inside {7'b0110011, 7'b0010011, 7'b0100011, 7'b0110111, 7'b0000011, 7'b0010111, 7'b1101111, 7'b1100011, 7'b1100111};
    //     if (opcode inside {7'b0110011, 7'b0010011}) {                         //integer
    //         funct3 inside{0, 3'b001,3'b010,3'b011,3'b100,3'b101,3'b110,3'b111};
    //         funct7 inside{0, 32};  
    //         rd inside {[1:31]};
    //     }
    //     else if (opcode inside {7'b0100011, 7'b0110111, 7'b0000011}) {
    //         if (opcode inside {7'b0100011}) funct3 inside{0, 3'b001,3'b010};   //store
    //         else if (opcode inside {7'b0000011, 7'b0110111}) funct3 inside {0, 1, 2, 4, 5};  //load
    //         rd inside {[1:31]};
    //     }
    //     else if (opcode inside {7'b0010111, 7'b1101111, 7'b1100111, 7'b1100011}) {   //jump_branch , 
    //         rd inside {[1:31]};
    //         if (opcode inside {7'b1100011}) funct3 inside {0, 1, 4, 5, 6, 7};
    //         imm inside {4};
    //         rs1 inside {0};
    //     }
    // }

    constraint All_Instruction{
        opcode inside {7'b0110011, 7'b0010011, 7'b0100011, 7'b0110111, 7'b0000011, 7'b0010111, 7'b1101111, 7'b1100111, 7'b1100011};
        if (opcode inside {7'b0110011, 7'b0010011}) {                         //integer
            funct3 inside{0, 3'b001,3'b010,3'b011,3'b100,3'b101,3'b110,3'b111};
            funct7 inside{0, 32};  
            rd inside {[1:31]};
        }
        else if (opcode inside {7'b0100011, 7'b0110111, 7'b0000011}) {
            if (opcode inside {7'b0100011}) funct3 inside{0, 3'b001,3'b010};   //store
            else if (opcode inside {7'b0000011, 7'b0110111}){
                 rs1 == 0;
                 funct3 inside {0, 1, 2, 4, 5};  //load
            }
            rd inside {[1:31]};
            imm inside {0, 4, 8, 12, 16, 20, 24, 28, 32, 40, 44, 48, 52, 56, 60, 64, 68, 72};
        }
        else if (opcode inside {7'b0010111, 7'b1101111, 7'b1100111, 7'b1100011}) {   //jump_branch , 
            rd inside {[1:31]};
            if (opcode inside {7'b1100011}) {
                funct3 inside {0, 1, 4, 5, 6, 7};
                imm == 8;
            }
            rs1 == 0;
            if (opcode == 7'b1101111  ) imm == 8;
            if (opcode == 7'b1100111)imm == (now+1+10) * 4;
        }

    
        //imm inside {0, 4, 8, 12, 16, 20, 24, 28, 32, 40, 44, 48, 52, 56, 60, 64, 68, 72};
      
    }




    task mode_test(int c);
        if (c == 0) begin
            Integer_Instruction.constraint_mode(1);
            Load_Store_Instruction.constraint_mode(0);
            Jump_Branch_Instruction.constraint_mode(0);
            All_Instruction.constraint_mode(0);
        end  
        else if (c == 1) begin
            Integer_Instruction.constraint_mode(0);
            Load_Store_Instruction.constraint_mode(1);
            Jump_Branch_Instruction.constraint_mode(0);
            All_Instruction.constraint_mode(0);
        end
        else if (c == 2) begin
            Integer_Instruction.constraint_mode(0);
            Load_Store_Instruction.constraint_mode(0);
            Jump_Branch_Instruction.constraint_mode(1);
            All_Instruction.constraint_mode(0);
        end   
        else if (c == 3) begin 
            Integer_Instruction.constraint_mode(0);
            Load_Store_Instruction.constraint_mode(0);
            Jump_Branch_Instruction.constraint_mode(0);
            All_Instruction.constraint_mode(1);
        end
    endtask: mode_test;
    function declare_operand();
        if (opcode == 7'b0010011) begin
            if (funct3 == 0 && funct7 == 0) op = operand'(0); //add
            else if (funct3 == 3'b001 && funct7 == 0)  op = operand'(2); //sll
            else if (funct3 == 2 ) op = operand'(3); //slt
            else if (funct3 == 3'b011 ) op = operand'(4); //sltu
            else if (funct3 == 3'b100 ) op = operand'(5); //xor
            else if (funct3 == 3'b101 && funct7 == 0)  op = operand'(6); //srl
            else if (funct3 == 3'b101 && funct7 == 32)  op = operand'(7); //sra
            else if (funct3 == 3'b110 )  op = operand'(8); //or
            else if (funct3 == 3'b111 ) op = operand'(9); //and 
        end else if (opcode == 7'b0110011)
        begin
            
            if (funct3 == 0 && funct7 == 0)  op = operand'(0); //add
            else if (funct3 == 0 && funct7 == 32)  op = operand'(1); //sub
            else if (funct3 == 3'b001 && funct7 == 0)  op = operand'(2); //sll
            else if (funct3 == 3'b010 && funct7 == 0)  op = operand'(3); //slt
            else if (funct3 == 3'b011 && funct7 == 0)  op = operand'(4); //sltu
            else if (funct3 == 3'b100 && funct7 == 0)  op = operand'(5); //xor
            else if (funct3 == 3'b101 && funct7 == 0)  op = operand'(6); //srl
            else if (funct3 == 3'b101 && funct7 == 32) op = operand'(7); //sra
            else if (funct3 == 3'b110 && funct7 == 0)  op = operand'(8); //or
            else if (funct3 == 3'b111 && funct7 == 0)  op = operand'(9); //and
        end
        else if (opcode == 7'b1100111)
        begin
            op = operand'(10);
        end
        else if (opcode == 7'b0000011)
        begin
            if (funct3 == 0)  op = operand'(11); 
            else if (funct3 == 3'b001 )  op = operand'(12); 
            else if (funct3 == 3'b010 )  op = operand'(13); 
            else if (funct3 == 3'b100 )  op = operand'(14); 
            else if (funct3 == 3'b101 )  op = operand'(15); 
        end
        else if (opcode == 7'b0100011) // store type
        begin
            if (funct3 == 0)  op = operand'(16); //sb
            else if (funct3 == 3'b001 )  op = operand'(17); //sh
            else if (funct3 == 3'b010 )  op = operand'(18); //sw
        end
        else if (opcode == 7'b0010111) //auipc
        begin
            op = operand'(19); //auipc
        end
        else if (opcode == 7'b0110111) //lui
        begin
            op = operand'(20); //lui
        end
        else if (opcode ==  7'b1101111) //jal
        begin
            op = operand'(21); //jal
        end
        else if (opcode == 7'b1100011) begin
            if (funct3 == 0) op = operand'(22);
            else if (funct3 == 1) op = operand'(23);
            else if (funct3 == 4) op = operand'(24);
            else if (funct3 == 5) op = operand'(25);
            else if (funct3 == 6) op = operand'(26);
            else if (funct3 == 7) op = operand'(27);
        end
    endfunction: declare_operand;
    extern function new (string name = "Packet");
    extern function generated();
    extern function void display(string prefix = "NOTE");
endclass: Packet

function Packet::new(string name);
    this.name = name;
endfunction:new

function Packet::generated();
    if (this.opcode == 7'b0110011) begin //R
        instruction[6:0] = 7'b0110011; //opcode
        instruction[11:7] = rd;
        instruction[14:12] = funct3;
        instruction[19:15] = rs1;
        instruction[24:20] = rs2;
        instruction[31:25] = funct7;
    
    end 
    else if (this.opcode == 7'b0010011) begin //I
        instruction[6:0] = 7'b0010011; //opcode
        instruction[11:7] = rd;
        instruction[14:12] = funct3;
        instruction[19:15] = rs1;
        if (funct3 == 3'b001 || funct3 == 3'b101) begin
            instruction[31:25] = funct7;
            instruction[24:20] = imm[4:0];
        end 
        else instruction[31:20] = imm;
    end  
    else if (this.opcode == 7'b1100111) begin //JALR
        instruction[6:0] = 7'b1100111; //opcode
        instruction[11:7] = rd;
        instruction[14:12] = 0;
        instruction[19:15] = rs1;
        instruction[31:20] = imm[11:0];
    end
    else if (this.opcode == 7'b0000011) begin //LOAD
        instruction[6:0] = 7'b0000011; //opcode
        instruction[11:7] = rd;
        instruction[14:12] = funct3;
        instruction[19:15] = rs1;
        instruction[31:20] = imm[11:0];
    end
    else if (this.opcode == 7'b0100011) begin //STORE
        instruction[6:0] = 7'b0100011; //opcode
        instruction[11:7] = imm[4:0];
        instruction[14:12] = funct3;
        instruction[19:15] = rs1;
        instruction[24:20] = rs2;
        instruction[31:25] = imm[11:5];
    end
    else if (this.opcode == 7'b0010111 || this.opcode == 7'b0110111) begin //auipc_lui
        instruction[6:0] = opcode; //opcode
        instruction[11:7] = rd;
        instruction[31:12] = imm[31:12];
    end
    else if (this.opcode == 7'b1101111) begin //JAL
        instruction[6:0] = 7'b1101111; //JAL
        instruction[11:7] = rd;
        instruction[31:12] = {imm[20],imm[10:1],imm[11],imm[19:12]};
    end
    else if (this.opcode == 7'b1100011) begin //BRANCH
        instruction[6:0] = 7'b1100011;
        instruction[11:7] = {imm[4:1],imm[11]};
        instruction[14:12] = funct3;
        instruction[19:15] = rs1;
        instruction[24:20] = rs2;
        instruction[31:25] = {imm[12],imm[10:5]};
    end

endfunction: generated

function void Packet::display(string prefix = "NOTE");
    content = prefix;
    $display("-------------------------------------------------------\nInstruction for %s", content);
    $display(" + INS NAME: %s", name);
    if (opcode == 7'b0110011)  begin
        $display(" + INS TYPE: R-TYPE");
        $display(" + funct3: %0d", funct3 );
        $display(" + R[%0d] = R[%0d] %s R[%0d] \n-------------------------------------------------------", rd, rs1, op.name(), rs2);
    end
    else if (opcode == 7'b0010011) begin
        $display(" + INS TYPE: I-TYPE");
        $display(" + funct3: %0d", funct3 );
        if (funct3 == 1 || funct3 == 5) $display(" + R[%0d] = R[%0d] %s %0d \n-------------------------------------------------------", rd, rs1, op.name(), $unsigned(imm[4:0]));
        else $display(" + R[%0d] = R[%0d] %s %0d \n-------------------------------------------------------", rd, rs1, op.name(), $signed(imm[11:0]));
    end
    else if (opcode == 7'b1100111) begin
        $display(" + INS TYPE: I-TYPE");
        $display(" + PC = R[%0d] + %0d", rs1, imm);
        $display(" + R[%0d] = PC + 4 \n-------------------------------------------------------", rd);
    end
    else if (opcode == 7'b0000011) begin
        $display(" + INS TYPE: I-TYPE");
        $display(" + funct3: %0d", funct3 );
        $display(" + R[%0d] = %s AT R[%0d] + %0d \n-------------------------------------------------------", rd, op.name(), rs1, $signed(imm));
        if (funct3 == 3 || funct3 == 7 || funct3 == 6) $display(" + ERROR TYPE!");
    end
    else if (opcode == 7'b0100011) begin
        $display(" + INS TYPE: STORE-TYPE");
        $display(" + funct3: %0d", funct3 );
        $display(" + %s DMEM AT R[%0d] + %0d = R[%0d]\n-------------------------------------------------------", op.name(), rs1, $signed(imm), rs2);
    end
    else if (opcode == 7'b0010111) begin
        $display(" + INS TYPE: AUIPC-TYPE");
        $display(" + R[%0d] = PC + %0d << 12 \n-------------------------------------------------------", rd, $signed(imm>>12<<12));
    end
    else if (opcode == 7'b0110111) begin
        $display(" + INS TYPE: LUI-TYPE");
        $display(" + R[%0d] = %0d << 12 \n-------------------------------------------------------", rd, $signed(imm>>12<<12));
    end
    else if (opcode == 7'b1101111) begin
        $display(" + INS TYPE: JAL-TYPE");
        $display(" + R[%0d] = PC + 4", rd);
        $display(" + PC = PC + %0d \n-------------------------------------------------------", $signed(imm));
    end
    else if (opcode == 7'b1100011) begin 
        $display(" + INS TYPE: BRANCH-TYPE");
        $display(" + IF R[%0d] %s R[%0d] -> PC = PC + %0d", rs1, op.name(), rs2, $unsigned(imm));
    end
    $display("++++++++++++++++++++\n+HEX CODE: %h+\n++++++++++++++++++++", instruction);
endfunction: display


