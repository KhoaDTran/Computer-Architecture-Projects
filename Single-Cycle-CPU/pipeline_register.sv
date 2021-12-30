/*
* pipeline_register makes SZ amount of flip flops to use 
* in pipelining to transmit data between stages of the pipeline.
* inputs: 
* 		d: 64 bit input into d_ffs that is the data of an instruction
*		reset: reset
*		clk: clk for d_ff
* outputs: 
* 		q: 64 bit output of d_ffs that is the stored data of an instruction
*/
module pipeline_register #(parameter SZ = 64) (q, d, reset, clk);
	input logic [SZ-1:0] d;
	input logic reset, clk;
	
	output logic [SZ-1:0] q;
	
	// generate SZ amount of d_ffs, one for every bit of the instruction
	genvar i;
	generate
		for (i = 0; i < SZ; i++) begin : subd_ffs
			d_ff d_ffy(.q(q[i]), .d(d[i]), .reset(reset), .clk(clk));	
		end
	endgenerate
endmodule 