/* 
* this mux4_1 takes 4 input bits and uses 2 select bits to choose to output 
* one of those 8 bits.
* inputs: 
*		i0: 1 bit input chosen if selector bits are 00
*		i1: 1 bit input chosen if selector bits are 01
*		i2: 1 bit input chosen if selector bits are 10
*		i3: 1 bit input chosen if selector buts are 11
*		sel1: 1 bit selector bit, most significant place of the 2 selector bits
* 		sel0: 1 bit selector bit, least significant place of the 2 selector bits
* outputs:
*		out: 1 bit that was chosen from the 4 possible input bits 
*/
module mux4_1(out, i0, i1, i2, i3, sel1, sel0);
	output logic out;
	input logic i0, i1, i2, i3, sel1, sel0;
	
	logic out_i0_i1, out_i2_i3;
	
	// use two 2_1 muxes to pick 2 inputs out of 4, 
	mux2_1 muxi0_i1(out_i0_i1, i0, i1, sel0);
	mux2_1 muxi2_i3(out_i2_i3, i2, i3, sel0);
	
	// then one more 2_1 mux to pick 1 between the last two chosen bits.
	mux2_1 final_out(out, out_i0_i1, out_i2_i3, sel1);
endmodule 

module mux4_1_testbench();
     logic i0, i1, i2, i3, sel0, sel1, sel2;
	  logic out;

	  mux4_1 dut (.out, .i0, .i1, .i2, .i3, .sel1, .sel0);

	  initial begin 
			sel1=0; sel0=0; i0=0; i1=0; i2=0; i3=0; #10;
			sel1=0; sel0=0; i0=0; i1=0; i2=0; i3=1; #10;
			sel1=0; sel0=0; i0=0; i1=0; i2=1; i3=0; #10;
			sel1=0; sel0=0; i0=0; i1=0; i2=1; i3=1; #10;
			sel1=0; sel0=0; i0=0; i1=1; i2=0; i3=0; #10;
			sel1=0; sel0=0; i0=0; i1=1; i2=0; i3=1; #10;
			sel1=0; sel0=0; i0=0; i1=1; i2=1; i3=0; #10;
			sel1=0; sel0=0; i0=0; i1=1; i2=1; i3=1; #10;
			sel1=0; sel0=0; i0=1; i1=0; i2=0; i3=0; #10;
			sel1=0; sel0=0; i0=1; i1=0; i2=0; i3=1; #10;
			sel1=0; sel0=0; i0=1; i1=0; i2=1; i3=0; #10;
			sel1=0; sel0=0; i0=1; i1=0; i2=1; i3=1; #10;
			sel1=0; sel0=0; i0=1; i1=1; i2=0; i3=0; #10;
			sel1=0; sel0=0; i0=1; i1=1; i2=0; i3=1; #10;
			sel1=0; sel0=0; i0=1; i1=1; i2=1; i3=0; #10;
			sel1=0; sel0=0; i0=1; i1=1; i2=1; i3=1; #10;
			
			sel1=0; sel0=1; i0=0; i1=0; i2=0; i3=0; #10;
			sel1=0; sel0=1; i0=0; i1=0; i2=0; i3=1; #10;
			sel1=0; sel0=1; i0=0; i1=0; i2=1; i3=0; #10;
			sel1=0; sel0=1; i0=0; i1=0; i2=1; i3=1; #10;
			sel1=0; sel0=1; i0=0; i1=1; i2=0; i3=0; #10;
			sel1=0; sel0=1; i0=0; i1=1; i2=0; i3=1; #10;
			sel1=0; sel0=1; i0=0; i1=1; i2=1; i3=0; #10;
			sel1=0; sel0=1; i0=0; i1=1; i2=1; i3=1; #10;
			sel1=0; sel0=1; i0=1; i1=0; i2=0; i3=0; #10;
			sel1=0; sel0=1; i0=1; i1=0; i2=0; i3=1; #10;
			sel1=0; sel0=1; i0=1; i1=0; i2=1; i3=0; #10;
			sel1=0; sel0=1; i0=1; i1=0; i2=1; i3=1; #10;
			sel1=0; sel0=1; i0=1; i1=1; i2=0; i3=0; #10;
			sel1=0; sel0=1; i0=1; i1=1; i2=0; i3=1; #10;
			sel1=0; sel0=1; i0=1; i1=1; i2=1; i3=0; #10;
			sel1=0; sel0=1; i0=1; i1=1; i2=1; i3=1; #10;
			
			sel1=1; sel0=0; i0=0; i1=0; i2=0; i3=0; #10;
			sel1=1; sel0=0; i0=0; i1=0; i2=0; i3=1; #10;
			sel1=1; sel0=0; i0=0; i1=0; i2=1; i3=0; #10;
			sel1=1; sel0=0; i0=0; i1=0; i2=1; i3=1; #10;
			sel1=1; sel0=0; i0=0; i1=1; i2=0; i3=0; #10;
			sel1=1; sel0=0; i0=0; i1=1; i2=0; i3=1; #10;
			sel1=1; sel0=0; i0=0; i1=1; i2=1; i3=0; #10;
			sel1=1; sel0=0; i0=0; i1=1; i2=1; i3=1; #10;
			sel1=1; sel0=0; i0=1; i1=0; i2=0; i3=0; #10;
			sel1=1; sel0=0; i0=1; i1=0; i2=0; i3=1; #10;
			sel1=1; sel0=0; i0=1; i1=0; i2=1; i3=0; #10;
			sel1=1; sel0=0; i0=1; i1=0; i2=1; i3=1; #10;
			sel1=1; sel0=0; i0=1; i1=1; i2=0; i3=0; #10;
			sel1=1; sel0=0; i0=1; i1=1; i2=0; i3=1; #10;
			sel1=1; sel0=0; i0=1; i1=1; i2=1; i3=0; #10;
			sel1=1; sel0=0; i0=1; i1=1; i2=1; i3=1; #10;
			
			sel1=1; sel0=1; i0=0; i1=0; i2=0; i3=0; #10;
			sel1=1; sel0=1; i0=0; i1=0; i2=0; i3=1; #10;
			sel1=1; sel0=1; i0=0; i1=0; i2=1; i3=0; #10;
			sel1=1; sel0=1; i0=0; i1=0; i2=1; i3=1; #10;
			sel1=1; sel0=1; i0=0; i1=1; i2=0; i3=0; #10;
			sel1=1; sel0=1; i0=0; i1=1; i2=0; i3=1; #10;
			sel1=1; sel0=1; i0=0; i1=1; i2=1; i3=0; #10;
			sel1=1; sel0=1; i0=0; i1=1; i2=1; i3=1; #10;
			sel1=1; sel0=1; i0=1; i1=0; i2=0; i3=0; #10;
			sel1=1; sel0=1; i0=1; i1=0; i2=0; i3=1; #10;
			sel1=1; sel0=1; i0=1; i1=0; i2=1; i3=0; #10;
			sel1=1; sel0=1; i0=1; i1=0; i2=1; i3=1; #10;
			sel1=1; sel0=1; i0=1; i1=1; i2=0; i3=0; #10;
			sel1=1; sel0=1; i0=1; i1=1; i2=0; i3=1; #10;
			sel1=1; sel0=1; i0=1; i1=1; i2=1; i3=0; #10;
			sel1=1; sel0=1; i0=1; i1=1; i2=1; i3=1; #10; 
		end    
endmodule 