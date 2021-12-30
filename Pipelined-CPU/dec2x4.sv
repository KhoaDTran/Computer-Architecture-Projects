//Khoa Tran and Melinda Tran
//Lab 1--dec2x4 module
//Dec2x4 module using not and and gates for control of input
//to select the correct output


`timescale 10ps/1fs
module dec2x4(in, enable, out);
	input logic [1:0] in;
	output logic [3:0] out;
	input logic enable;
	
	logic out1, out2, out3, out4;
	logic not1, not2;
	
	not #5 not1_method(not1, in[0]);
	not #5 not2_method(not2, in[1]);
	
	
	and #5 out_method(out[0], not1, not2, enable);
	and #5 out_method1(out[1], in[0], not2, enable);
	and #5 out_method2(out[2], in[1], not1, enable);
	and #5 out_method3(out[3], in[0], in[1], enable);
endmodule

	