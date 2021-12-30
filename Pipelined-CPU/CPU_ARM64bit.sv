`timescale 1ns/10ps
module CPU_ARM64bit(clk, reset);
	input logic clk, reset;
	
	logic [31:0] instruction;
	logic UncondBr, BrTaken;
	logic zero, negative, overflow, carry_out;
	logic Reg2Loc, RegWrite, MemWrite, MemToReg, read_enable, flagReg, extendIn, shiftDir;
	logic [1:0] ALUSrc;
	logic [2:0] ALUOp;
	logic [3:0] xfer_size;
	logic oldBR;
	logic [31:0] instruction_decode; 

	// ******** IFETCH ***********
	/*
	* Varibales that need to be piplined to DECODE:
	* insturction
	*/
	
	// For fetching instruction, handling branches
	instruction instruction_logic(.instruction, .UncondBr, .BrTaken, .clk, .reset, .oldBR, .instruction_decode);
	
	// ********** DECODE (part 1) *******
	
	
	
	pipeline_register #(.SZ(32)) piped_instruction_decode(.q(instruction_decode), .d(instruction), .reset, .clk);
	
	// Logic for control signals
	controlLogic control (.instruction(instruction_decode[31:21]), .Reg2Loc, .RegWrite, .ALUSrc, .ALUOp, .zero, .MemWrite, .MemToReg, .UncondBr, .BrTaken, .oldBR,
								.xfer_size, .negative, .overflow, .read_enable, .flagReg, .extendIn, .shiftDir, .full_instruct(instruction_decode));

	// Datapath logic
	datapath data (.Reg2Loc, .RegWrite, .ALUSrc, .ALUOp, .MemWrite, .MemToReg, .read_enable, .instruction(instruction_decode),
					 .xfer_size, .clk, .reset, .overflow, .negative, .zero, .carry_out, .flagReg, .extendIn, .shiftDir, .oldBR);
					 

endmodule

module CPU_ARM64bit_testbench();
	logic clk, reset;
	integer i;
	
	CPU_ARM64bit dut (.clk, .reset);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=1000; // very long clock cycle is good
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
									@(posedge clk);
		reset <= 1; 			@(posedge clk); // Always reset at start
		reset <= 0; 
		
		for (i=0; i< 5000; i++) begin // each instruction is one clock cycle
			@(posedge clk);
		end
		
		$stop; // End the simulation.
	end
endmodule 