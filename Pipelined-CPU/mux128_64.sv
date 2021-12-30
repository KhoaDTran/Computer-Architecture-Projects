`timescale 10ps/1fs

module mux128_64 (inOne, inZero, sel, out);
	input logic [63:0] inOne, inZero;
	input logic sel;
	output logic [63:0] out;

	genvar i;
	
	generate 
		for (i = 0; i < 64; i++) begin : eachRouteMux
			mux2_1  muxRoute(.i1(inOne[i]), .i0(inZero[i]), .sel(sel), .out(out[i]));
		end
	endgenerate 

endmodule
