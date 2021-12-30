/*
* the adder_64 module adds 2 64-bit buses and outputs the sum
* as well as whether or no there was overflow. the module does this by
* adding one bit at a time and saving the result into a result bus 
* as well as a bus for carry_bits for the next 2 bit's addition. Uses the 
* fullAdder module to perform each individual 2 bit's addition.
*
* inputs: 64 bit bus a and b, ci initial carry-in bit (zero)
* outputs: result of addition of a and b, overflow whether or not there 
*			  is overflow when doing the addition of a and b
* note: the adder may be used for subtraction by adding a + (-b) + 1
*/

`timescale 1ps/1fs
module adder_64(a, b, ci, co, result, overflow);
	parameter DATA_SIZE = 64;
	
	input logic [DATA_SIZE-1:0] a;
	input logic [DATA_SIZE-1:0] b;
	input logic ci;
	
	output logic [DATA_SIZE-1:0] result;
	output logic co, overflow;
	
	logic [DATA_SIZE:0] carry_bits;
	
	/*
	* fill the results bus by adding 1 bit from a and b one at a time
	* the carry out bit from the previous operation becomes the carry in 
	* bit to the next. The first carry in bit is 0. The carries are but into 
	* the carry_bits bus.
	*/
	genvar i;
	generate
		for (i = 0; i < DATA_SIZE; i++) begin: subfulladders
			fulladder subfulladder(.a(a[i]), .b(b[i]), .ci(carry_bits[i]), 
										  .out(result[i]), .co(carry_bits[i+1]));
		end
	endgenerate
	
	// assign overflow based on if the last & 2nd to last bit of the carry_bits
	// are matching or not.
	xor #50 overflow_assign(overflow, carry_bits[DATA_SIZE], carry_bits[DATA_SIZE-1]);
	assign co = carry_bits[DATA_SIZE]; // wire out to last bit carry-bits
	assign carry_bits[0] = ci;
endmodule
