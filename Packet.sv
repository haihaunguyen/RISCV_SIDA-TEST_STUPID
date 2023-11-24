class Packet;
    rand bit[6:0] opcode;
    rand bit[4:0] rs1, rs2, rd;
    rand bit[11:0] imm;
    rand bit[2:0] funct3;
    rand bit[6:0] funct7;
    string name, content;
    bit[31:0] instruction;
    typedef enum {ADD = 0, SUB , SLL , SLT , SLTU , XOR , SRL , SRA , OR , AND, JALR, LB, LH, LW, LBU, LHU} operand;
    operand op;
    constraint Limit{
        opcode inside{s7'b0110011, 7'b0010011, 7'b1100111, 7'b0000011};
        funct3 inside{0, 3'b001,3'b010,3'b011,3'b100,3'b101,3'b110,3'b111};
        funct7 inside{0, 32};   
        rd inside {[1:31]};
    }  
    
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
        $display(" + R[%0d] = R[%0d] %s %0d \n-------------------------------------------------------", rd, rs1, op.name(), $signed(imm));
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
    
    
endfunction: display


