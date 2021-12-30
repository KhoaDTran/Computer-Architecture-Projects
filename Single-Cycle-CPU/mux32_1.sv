//Khoa Tran and Melinda Tran
//Lab 1--mux32x1 module
//Mux32x1 module using eight mux4x1 and 2 mux4x1 as well as
//a 2x1 mux to control output
//based on input and select

`timescale 1ns/1fs
module mux32_1(out, i, sel);
	parameter INPUTS = 32, SELECTBITS = 5, TEMPOUT1 = 8, TEMPOUT2 = 2;

	output logic out;
	input logic [INPUTS-1:0] i;
	input logic [SELECTBITS-1:0] sel;
	logic [TEMPOUT1-1:0] temp_out_s0_s1;
	logic [TEMPOUT2-1:0] temp_out_s2_s3;
	
	genvar j;
	generate
		for (j = 0; j < TEMPOUT1; j++) begin : sub4_1muxes
			mux4_1 mux4(.out(temp_out_s0_s1[j]), .i0(i[j*4]), .i1(i[j*4 + 1]), 
							.i2(i[j*4 + 2]), .i3(i[j*4 + 3]), .sel1(sel[1]), .sel0(sel[0]));
		end
		
		for (j = 0; j < TEMPOUT2; j++) begin : sub4_1muxes2
			mux4_1 mux4_layer2(.out(temp_out_s2_s3[j]), 
									 .i0(temp_out_s0_s1[j*4]), 
									 .i1(temp_out_s0_s1[j*4 + 1]), 
									 .i2(temp_out_s0_s1[j*4 + 2]), 
									 .i3(temp_out_s0_s1[j*4 + 3]), 
									 .sel1(sel[3]), .sel0(sel[2]));
		 end
	endgenerate
	
	mux2_1 mux2(.out(out), .i0(temp_out_s2_s3[0]), .i1(temp_out_s2_s3[1]), .sel(sel[4]));
endmodule 