//This module PCadder serves as the purpose of adding bit values to a 64bit PC address.
//The module uses the fullAdder module built in Lab 2 for each bit of the 64 bit result.
`timescale 1ns/10ps
module PCadder (inputA, inputB, result);
	input logic [63:0] inputA, inputB;
	output logic [63:0] result;
	logic [63:0] carryStorage;
	
	fulladder leftMostAdder(.a(inputA[0]), .b(inputB[0]), .ci(1'b0), .co(carryStorage[0]), .out(result[0]));
	
	//Uses a fullAdder for each bit of the result to calculate the summation needed to value A
	genvar i;
	generate
		for (i = 1; i < 64; i++) begin: bitAdders
			fulladder eachBitAdder (.a(inputA[i]), .b(inputB[i]), .ci(carryStorage[i - 1]), .co(carryStorage[i]), .out(result[i]));
		end
	endgenerate
		
endmodule


//Testbench that checks if the summation is working properly
//by giving example 64-bit values to be added.
module PCadderTestbench();
	logic [63:0] inputA, inputB;
	logic [63:0] result;
	
	PCadder dut(.inputA, .inputB, .result);
	
	initial begin
		inputA = 64'd1; inputB = 64'd4; #5;
		end
endmodule

