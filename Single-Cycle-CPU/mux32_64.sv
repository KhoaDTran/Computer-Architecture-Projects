//Khoa Tran and Melinda Tran
//Lab 1--mux32x64 module
//Mux32x64 module using 64 mux32x1 to control output
//based on input and select


`timescale 1ns/1fs
module mux32_64(out, i, sel);
	parameter INPUTS = 32, SELECTBITS = 5, TEMPOUT1 = 8, TEMPOUT2 = 2;

	output logic [63:0] out;
	input logic [31:0][63:0] i; // 32 Buses that are each 64 bits
	input logic [4:0] sel;
	logic [63:0][31:0] temp;
	int c, d;
	
	//flip index with data bits
	always_comb begin
		for (c = 0; c < 32; c++) begin
			for (d = 0; d < 64; d++) begin
				temp[d][c] = i[c][d];
			end
		end
	end
	
	//generate 64 mux32x1
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin : sub32muxes
			mux32_1 mux32(.out(out[j]), .i(temp[j][31:0]), .sel);	
		end
	endgenerate 
	
endmodule 