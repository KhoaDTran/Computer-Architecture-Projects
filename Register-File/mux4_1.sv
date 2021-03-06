//Khoa Tran and Melinda Tran
//Lab 1--mux4x1 module
//Mux4x1 module using three mux2x1 to control output
//based on input and select 1 and select 0
`timescale 1ns/1fs
module mux4_1(out, i0, i1, i2, i3, sel1, sel0);
	output logic out;
	input logic i0, i1, i2, i3, sel1, sel0;
	
	logic out_i0_i1, out_i2_i3;
	
	//instantiations of mux2x1 module
	mux2_1 muxi0_i1(out_i0_i1, i0, i1, sel0);
	mux2_1 muxi2_i3(out_i2_i3, i2, i3, sel0);
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