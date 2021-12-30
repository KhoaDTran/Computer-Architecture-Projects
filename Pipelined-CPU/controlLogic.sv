`timescale 1ns/10ps
module controlLogic (instruction, zero, negative, overflow, RegWrite, Reg2Loc, ALUSrc, ALUOp, MemWrite,
                     MemToReg, UncondBr, BrTaken, xfer_size, read_enable, flagReg, extendIn, shiftDir, full_instruct, oldBR);
	parameter DELAY = 0.05;
	input logic [10:0] instruction;
	input logic zero, negative, overflow;
	input logic [31:0] full_instruct;
	output logic RegWrite, Reg2Loc, MemWrite, MemToReg, UncondBr, BrTaken, read_enable, flagReg, extendIn, shiftDir;
	output logic [1:0] ALUSrc;
	output logic [2:0] ALUOp;
	output logic [3:0] xfer_size;
	output logic oldBR;
	
	parameter [10:0] ADDI = 11'b1001000100x, ADDS = 11'b10101011000, B = 11'b000101xxxxx,
						  CBZ = 11'b10110100xxx, LDUR = 11'b11111000010, STUR = 11'b11111000000,
						  SUBS = 11'b11101011000, BLT = 11'b01010100xxx, LSL = 11'b11010011011,
						  LSR = 11'b11010011010, MUL = 11'b10011011000; 
						  
	logic BLTResult;
	xor #DELAY BLTxor (BLTResult, negative, overflow);
	
	always_comb 
		begin
			casex(instruction)
				// In case of ADDI, an Imm_12 signal was added. In the datapath, the DAddr9 SE and Imm_12
				// are put through a mux to decide which signal is needed. For this case, it will be Imm_12.
			B: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b0;
				ALUSrc = 2'bxx;
				ALUOp = 3'bxxx;
				MemWrite = 1'b0;
				MemToReg = 1'bx;
				UncondBr = 1'b1;
				BrTaken = 1'b1;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b1;
				shiftDir = 1'bx;
				extendIn = 1'bx;
				oldBR = 1'b1;
				end
			
			ADDI: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 2'b01;
				ALUOp = 3'b010;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				shiftDir = 1'bx;
				extendIn = 1'b0;
				if (full_instruct == 32'b1001000100_000000000000_11111_11111)
					flagReg = 1'b1;
				else
					flagReg = 1'b0;
				oldBR = 1'b0;
				end
				
			ADDS: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 2'b00;
				ALUOp = 3'b010;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'bx;
				extendIn = 1'bx;
				oldBR = 1'b0;
				end
				
			SUBS: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 2'b00;
				ALUOp = 3'b011;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'bx;
				extendIn = 1'bx;
				oldBR = 1'b0;
				end

			BLT: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b0;
				ALUSrc = 2'bxx;
				ALUOp = 3'bxxx;
				MemWrite = 1'b0;
				MemToReg = 1'bx;
				UncondBr = 1'b0;
				BrTaken = BLTResult;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'bx;
				extendIn = 1'bx;
				oldBR = 1'b1;
				end
				
			CBZ: begin
				Reg2Loc = 1'b0;
				RegWrite = 1'b0;
				ALUSrc = 2'b00;
				ALUOp = 3'b000;
				MemWrite = 1'b0;
				MemToReg = 1'bx;
				UncondBr = 1'b0;
				BrTaken = zero;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'bx;
				extendIn = 1'b1;
				oldBR = 1'b1;
				end
				
			LDUR: begin
				Reg2Loc = 1'bx;
				RegWrite = 1'b1;
				ALUSrc = 2'b01;
				ALUOp = 3'b010;
				MemWrite = 1'b0;
				MemToReg = 1'b1;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b1;
				xfer_size = 4'b1000;
				flagReg = 1'b1;
				shiftDir = 1'bx;
				extendIn = 1'b1;
				oldBR = 1'b0;
				end
				
			STUR: begin
				Reg2Loc = 1'b0;
				RegWrite = 1'b0;
				ALUSrc = 2'b01;
				ALUOp = 3'b010;
				MemWrite = 1'b1;
				MemToReg = 1'bx;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'b1000;
				flagReg = 1'b1;
				shiftDir = 1'bx;
				extendIn = 1'b1;
				oldBR = 1'b0;
				end
				
			LSL: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 2'b10;
				ALUOp = 3'b000;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'b0;
				extendIn = 1'bx;
				oldBR = 1'b0;
				end
				
			LSR: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 2'b10;
				ALUOp = 3'b000;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'b1;
				extendIn = 1'bx;
				oldBR = 1'b0;
				end
				
			MUL: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 2'b11;
				ALUOp = 3'b000;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'bx;
				extendIn = 1'bx;
				oldBR = 1'b0;
				end
			default: begin
				Reg2Loc = 1'b1;
				RegWrite = 1'b1;
				ALUSrc = 2'b00;
				ALUOp = 3'b010;
				MemWrite = 1'b0;
				MemToReg = 1'b0;
				UncondBr = 1'bx;
				BrTaken = 1'b0;
				read_enable = 1'b0;
				xfer_size = 4'bxxxx;
				flagReg = 1'b0;
				shiftDir = 1'bx;
				extendIn = 1'bx;
				oldBR = 1'b0;
				end
		endcase
	end
endmodule

