`timescale 10ps/1fs

module mux256_64 (i3, i2, i1, i0, sel, out);
	input logic [63:0] i3, i2, i1, i0;
	input logic [1:0] sel;
	output logic [63:0] out;

	genvar i;
	
	generate 
		for (i = 0; i < 64; i++) begin : eachRouteMux
			mux4_1 muxRoute (.i3(i3[i]), .i2(i2[i]), .i1(i1[i]), .i0(i0[i]), .sel1(sel[1]), .sel0(sel[0]), .out(out[i]));
		end
	endgenerate 

endmodule
