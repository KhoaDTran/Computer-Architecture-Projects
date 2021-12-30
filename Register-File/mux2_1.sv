//Khoa Tran and Melinda Tran
//Lab 1--mux2x1 module
//Mux2x1 module using not, and, and or gates for control of 
//data output based on input and select


`timescale 1ns/1fs
module mux2_1(out, i0, i1, sel); 
    output logic out;
	 input  logic i0, i1, sel;      
	 logic i1_case, i0_case;
	 logic not_sel;
	 
	 not #50 invert_sel(not_sel, sel);
	 and #50 i1_method(i1_case, i1, sel);
	 and #50 i0_method(i0_case, i0, not_sel);
	 
	 or #50 out_method(out, i1_case, i0_case);
	 // assign out = (i1 & sel) | (i0 & ~sel);  
endmodule    

//mux2x1 testbench to ensure correctness
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