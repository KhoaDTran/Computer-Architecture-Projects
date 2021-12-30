`timescale 10ps/1fs

module mux256_64 (inThree, inTwo, inOne, inZero, sel, out);
	input logic [63:0] inThree, inTwo, inOne, inZero;
	input logic [1:0] sel;
	output logic [63:0] out;

	genvar i;
	
	generate 
		for (i = 0; i < 64; i++) begin : eachRouteMux
			mux4_1 muxRoute (.i3(inThree[i]), .i2(inTwo[i]), .i1(inOne[i]), .i0(inZero[i]), .sel1(sel[1]), .sel0(sel[0]), .out(out[i]));
		end
	endgenerate 

endmodule