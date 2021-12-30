/*
* this mux8_1 takes 8 input bits and uses 3 select bits to choose to output 
* one of those 8 bits. 
* inputs: 
*		sel: 3 bits of selector bits
*		in:  8 bits of possible outputs
* outputs:
*		out: 1 bit that was chosen from the 8 possible in bits
*/
module mux8_1(sel, in, out);
	input logic [2:0] sel;
	input logic [7:0] in; // 8 bits
	
	output logic out;
	
	logic mux4_1A_out, mux4_1B_out; // bits chosen by the 4 to 1 muxes on line 20-23
	
	// two 4 to 1 muxes with 2 select bits choose one bit 
	// from 4 to move onto the next layer
	mux4_1 mux4A(.out(mux4_1A_out), .i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), 
					 .sel1(sel[1]), .sel0(sel[0]));
	mux4_1 mux4B(.out(mux4_1B_out), .i0(in[4]), .i1(in[5]), .i2(in[6]), .i3(in[7]), 
					 .sel1(sel[1]), .sel0(sel[0]));
	
	// one 2 to 1 mux with one select bit chooses between the 
	// 2 bits given by the previous two 4 to 1 muxes
	mux2_1 mux2_final(.out(out), .i0(mux4_1A_out), .i1(mux4_1B_out), .sel(sel[2])); 
endmodule 