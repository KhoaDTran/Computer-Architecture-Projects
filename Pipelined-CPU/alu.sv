/*
* Lab2 EE469
* Melinda Tran & Khoa Tran
* 10/29/2021
*
* ALU - Artihmatic Logic Unit:
* Functinality: Add A and B, Subtract A and B, AND A and B, 
					 OR A and B, XOR A and B, and also output bus B
* The ALU is able to perform the listed funcationality above. 
* inputs:
*		A: 64-bit bus
* 		B: 64-bit bus
* 		cntrl: 3 control bits to select between 6 functions of ALU
*  outputs:
* 		result: 64-bit result of chosen function
*		negative: tells if result is a negative number (1) or not (0)
*		zero: tells if result is all zeros (1) or not (0)
*		overflow: tells what the overflow bit was in addition or subtraction functions (1 or 0)
*		carry_out: tells what the caryy-out but was in addition or subtraction functions (1 or 0)
*/

`timescale 1ps/1fs
module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A;
	input logic [63:0] B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	logic ci;
	logic [63:0] B_not; // ~B
	logic [1:0][63:0] temp2D; // a 2d Array with 2 rows of 64.
	logic [63:0] B_pass; // result of mux2_64, either B or ~B
	logic [7:0][63:0] all_results; // all results: 8 buses of 64 bits, 6 of them are the results of ALU, 
											// the rest don't matter
	
	// ALU functionality
	adder_64 addy_64_01X(.a(A), .b(B_pass), .ci(ci), .co(carry_out), .result(all_results[2]), .overflow(overflow));
	mux2_64 mux2_64_B(.out(B_pass), .i(temp2D), .sel(ci)); // pick between B and B_not depending on ci (cntrl[0])
	
	a_and_b aandb(.a(A), .b(B), .out(all_results[4]));
	a_or_b aorb(.a(A), .b(B), .out(all_results[5]));
	a_xor_b axorb(.a(A), .b(B), .out(all_results[6]));
	check_zero checkzero(.result(result), .zero(zero));
	
	mux8_64 final_result(.cntrl(cntrl), .all_results(all_results), .result(result));
	
	
	assign all_results[3] = all_results[2]; // wire the bus in all_results 2 to 3 
	assign ci = cntrl[0]; // wire cntrl[0] to ci (carry-in), 
								 // this bit determines difference between add and subtract
	assign all_results[0] = B; //wire B to all_Results[0]
	
	// flip the bits of B and put it as B_not
	genvar i;
	generate
		for (i=0; i < 64; i++) begin: sub_nots
			not #50 B_not_assign(B_not[i], B[i]);
		end
	endgenerate
	
	assign temp2D[0] = B; // wire row 0 of temp2D are the bits of B
	assign temp2D[1] = B_not; // wire row 1 of temp2D are the bits of B_not
	assign negative = result[63]; // wire negative to the most significant bit of result
endmodule 