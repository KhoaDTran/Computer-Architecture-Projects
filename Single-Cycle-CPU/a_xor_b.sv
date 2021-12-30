/*
* the a_xor_b module does a bitwise AND on buses a and b one bit at a time,
* passing the result in the same bit's place of the output result.
* inputs: 64-bit 'a' and 'b'
* outputs: 64-bit 'out' result of 'a' XOR 'b'
*/

`timescale 1ps/1fs
module a_xor_b(a, b, out);
	parameter DATA_SIZE = 64;
	
	input logic [DATA_SIZE-1:0] a;
	input logic [DATA_SIZE-1:0] b;
	
	output logic [DATA_SIZE-1:0] out;
	
	// XOR the i-th digit of buses 'a' and 'b', and store the
	// result into the i-th digit of 'out'. Do this one bit at a time,
	// where 'i' incrementes through the buses.
	genvar i;
	generate
		for (i=0; i<DATA_SIZE; i++) begin: sub_xors
			xor #50 axorb(out[i], a[i], b[i]); // out[i] = a[i] XOR b[i]
		end
	endgenerate 
endmodule 