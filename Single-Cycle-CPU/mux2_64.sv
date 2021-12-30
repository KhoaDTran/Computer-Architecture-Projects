/*
* the mux2_64 module is a multiplexor that chooses between 2 inputs of 64 bits.
* inputs: 
*		i = 2D bus. 2 buses of 64 bits that represent bus B and B_not
*		sel = 1 selector bit to choose between the 2 inputs. 
* outputs: 
		out = 64bit array, will be either B or B_not depending on selector bit
*/
module mux2_64(out, i, sel);
	parameter INPUTS = 2, SELECTBITS = 1, SIZE = 64;

	output logic [SIZE-1:0] out;
	input logic [INPUTS-1:0][SIZE-1:0] i; // 2 Buses that are each 64 bits
	input logic sel;
	logic [SIZE-1:0][INPUTS-1:0] temp; // 2D bus, 64 rows of 2 bits 
												  //(1 bit from B and 1 bit from B_not)
	int c, d;
	
	// rearrange the inputted buses into busses of all 
	// 1st digits of the inputs, 2nd digit, etc.
	always_comb begin
		for (c = 0; c < INPUTS; c++) begin
			for (d = 0; d < SIZE; d++) begin
				temp[d][c] = i[c][d];
			end
		end
	end
	
	// fill out bit by bit with the the selected bits from the temp 2D bus
	genvar j;
	generate
		for (j = 0; j < SIZE; j++) begin : sub2muxes
			mux2_1 mux2(.out(out[j]), .i0(temp[j][0]), .i1(temp[j][1]), .sel(sel));	
		end
	endgenerate 
endmodule 