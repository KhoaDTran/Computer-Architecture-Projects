/*
* the check_zero module checks if all the bits in result are 0 or not
* input: result - the resulting 64-bit of the ALu
* output: zero - 1 when all the bits of result are 0, otherwise is 1
*/
module check_zero(result, zero);
	input logic [63:0] result;
	
	output logic zero;
	logic [64:0] found_one; // bus of if result bit is either 1 or has had a 1 at a lower index
	
	// check bit by bit if result bit is either 1 or has had a 1 at a lower index
	genvar i;
	generate 
		for (i=1; i<65; i++) begin: sub_ors
			or check_zero_bit(found_one[i], found_one[i-1], result[i-1]);
		end
	endgenerate
	
	// invert if found_one has found a 1. 
	// ex. If found_one[64] is 1, there has been at least one 1 in result.
	not found_one_not(zero, found_one[64]); 
	assign found_one[0] = 0; // start found_one with having found no ones
endmodule 