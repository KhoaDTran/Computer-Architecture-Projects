`timescale 10ps/1fs

module mux10_5 (i1, i0, sel, out);
	input logic [4:0] i1, i0;
	input logic sel;
	output logic [4:0] out;

	genvar i;
	
	generate 
		for (i = 0; i < 5; i++) begin : eachRouteMux
			mux2_1 routeMux1 (.i1(i1[i]), .i0(i0[i]), .sel(sel), .out(out[i]));
		end
	endgenerate 

endmodule
