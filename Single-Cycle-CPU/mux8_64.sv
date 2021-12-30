/*
* the mux8_64 module is a multiplexor that chooses between 8 inputs of 64 bits.
* inputs: 
*		all_results = 2D bus. 8 buses of 64 bits that represent all the possible results of the ALU
*		cntrl = 3 selector bits to choose between the 8 inputs. 
* outputs: 
		result = 64bit array, will be one of the 8 64-bit buses from all_results
*/
module mux8_64(cntrl, all_results, result);
	input [2:0] cntrl;
	input [7:0][63:0] all_results; // 6 buses (all results) that are each 64 bits each
	
	output [63:0] result; //final chosen result
	
	logic [63:0][7:0] temp;
	int c, d;
	
	// rearrange the inputted buses into busses of all 
	// 1st digits of the inputs, 2nd digit, etc.
	always_comb begin
		for (c = 0; c < 8; c++) begin
			for (d = 0; d < 64; d++) begin
				temp[d][c] = all_results[c][d];
			end
		end
	end
	
	// fill final result bit by bit
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin : sub8muxes
			mux8_1 mux8(.sel(cntrl[2:0]), .in(temp[j]), .out(result[j]));	
		end
	endgenerate 
	
endmodule 