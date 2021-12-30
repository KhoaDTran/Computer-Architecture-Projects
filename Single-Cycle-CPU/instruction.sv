`timescale 1ns/10ps
module instruction (instruction, UncondBr, BrTaken, clk, reset);
	input logic BrTaken, UncondBr, clk, reset;
	output logic [31:0] instruction;
	
	logic [63:0] currentPC;
	
	// Fetch instruction from current PC
	instructmem fecthInstruction(.address(currentPC), .instruction, .clk);
	
	logic [63:0] nextPC;
	
	// Add 4 to current instructrion
	//adder_64 adder64 (.a(currentPC), .b(64'd4), .ci(0), .co(), .result(nextPC), .overflow());
	PCadder updatePC(.inputA(currentPC), .inputB(64'd4), .result(nextPC));
	
	// Sign extension
	logic [63:0] condAddrExtended, brAddrExtended;
	assign condAddrExtended = {{(64-19){instruction[23]}}, instruction[23:5]};
	assign brAddrExtended = {{(64-26){instruction[25]}}, instruction[25:0]};
	// Sign Extend condAddr19 and brAddr26
	//****** signExtend #(.WIDTH(19)) condExtend (.in(instruction[23:5]), .out(condAddrExtended));
	//****** signExtend  #(.WIDTH(26)) brExtend (.in(instruction[25:0]), .out(brAddrExtended));
	
	// Put results after sign extension into 2:1 Mux with control signal UncondBr
	logic [63:0] UncondMuxOut;
	genvar i;
	generate 
		for (i = 0; i < 64; i++) begin: eachUncondMux
			mux2_1 firstMux (.sel(UncondBr), .i0(condAddrExtended[i]), .i1(brAddrExtended[i]), .out(UncondMuxOut[i]));
		end
	endgenerate
	
	logic [63:0] shifterOut;
	
	// Shift result from UncondMux
	//shifter shift (.value(UncondMuxOut), .direction(1'b0), .distance(6'b000010), .result(shifterOut));
	assign shifterOut = UncondMuxOut << 2;
	logic [63:0] PCplusBranch;
	// Add the shifted result with current PC
	//adder_64 adder64_2 (.a(currentPC), .b(shifterOut), .ci(0), .co(), .result(PCplusBranch), .overflow());
	PCadder updatePC2(.inputA(currentPC), .inputB(shifterOut), .result(PCplusBranch));
	
	// Mux to choose whether to branch or not
	logic [63:0] BrTakenOut;
	generate 
		for (i = 0; i < 64; i++) begin: eachBrTakenMux
			mux2_1 secondMux (.sel(BrTaken), .i0(nextPC[i]), .i1(PCplusBranch[i]), .out(BrTakenOut[i]));
		end
	endgenerate
	
	// Store next PC to Program COunter
	pc pcUnit (.in(BrTakenOut), .out(currentPC), .clk, .reset);
		
endmodule
