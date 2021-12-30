/*
* the mux2_1 is a 2 to 1 multiplexor that chooses between two 1-bit inputs
* inputs:
*		i0: 1 bit input chosen if sel is 0
*		i1: 1 bit input chosen if sel is 1
* 		sel: 1 bit selector bit
* outputs:
*		out: 1 bit output chose by the selector but (either i0 or i1)
*/

`timescale 1ps/1fs
module mux2_1(out, i0, i1, sel); 
    output logic out;
	 input  logic i0, i1, sel;      
	 logic i1_case, i0_case;
	 logic not_sel;
	 
	 not #50 invert_sel(not_sel, sel); // not_sel = inverter sel
	 and #50 i1_method(i1_case, i1, sel); // i1_case = i1 & sel
	 and #50 i0_method(i0_case, i0, not_sel); // i0_case = i0 & not_sel
	 
	 or #50 out_method(out, i1_case, i0_case);
	 // out = (i1 & sel) | (i0 & ~sel);  
endmodule    

module mux2_1_testbench();
     logic i0, i1, sel;
	  logic out;

	  mux2_1 dut (.out, .i0, .i1, .sel);

	  initial begin 
			sel=0; i0=0; i1=0; #10;  
			sel=0; i0=0; i1=1; #10;  
			sel=0; i0=1; i1=0; #10;  
			sel=0; i0=1; i1=1; #10;  
			sel=1; i0=0; i1=0; #10;  
			sel=1; i0=0; i1=1; #10;  
			sel=1; i0=1; i1=0; #10;  
			sel=1; i0=1; i1=1; #10;  
		end    
endmodule 