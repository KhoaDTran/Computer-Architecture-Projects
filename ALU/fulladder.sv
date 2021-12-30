/*
* the fullAdder module adds 2 bits together along with their carry-in bit
* and outputs the sum as well as the carry-out bit.
*
* inputs: 1 bit 'a' and 'b', 1 carry-in but 'ci'
* outputs: 
*		out: the 1 bit sum of 'a' and 'b'
*		co:  the carry-out bit resulting from the sum of 'a' and b'
*/

`timescale 1ps/1fs
module fulladder(a, b, ci, out, co);
	input logic a, b, ci;
	output logic out, co;
	
	logic abci, ab, aci, bci; // temporary varibales 
	
	and #50 abci_and(abci, a, b, ci); // abci = a & b & ci
	and #50 ab_and(ab, a, b);			 // ab = a & b
	and #50 aci_and(aci, a, ci);		 // aci = a & ci
	and #50 bci_and(bci, b, ci);		 // bci = b & ci
	
	xor #50 out_assign(out, a, b, ci);   // out = a | b | co | abci
	or #50 co_assign(co, ab, aci, bci, abci); // co = ab | aci | bci| abci
	
endmodule 