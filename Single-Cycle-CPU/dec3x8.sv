//Khoa Tran and Melinda Tran
//Lab 1--dec3x8 module
//dec3x8 module using not and and gates for control of input
//to select the correct output

`timescale 10ps/1fs
module dec3x8(in, enable, out);
	input logic [2:0] in;
	input logic enable;
	output logic [7:0] out;
	
	logic out0, out1, out2, out3, out4, out5, out6, out7;
	logic not0, not1, not2;
	
	not #5 not1_method(not0, in[0]);
	not #5 not2_method(not1, in[1]);
	not #5 not3_method(not2, in[2]);
	
	and #5 and1(out0, not2, not1, not0);
	and #5 and2(out1, not2, not1, in[0]);
	and #5 and3(out2, not2, in[1], not0);
	and #5 and4(out3, not2, in[1], in[0]);
	and #5 and5(out4, in[2], not1, not0);
	and #5 and6(out5, in[2], not1, in[0]);
	and #5 and7(out6, in[2], in[1], not0);
	and #5 and8(out7, in[2], in[1], in[0]);
	
	and #5 out_method(out[0], out0, enable);
	and #5 out_method1(out[1], out1, enable);
	and #5 out_method2(out[2], out2, enable);
	and #5 out_method3(out[3], out3, enable);
	and #5 out_method4(out[4], out4, enable);
	and #5 out_method5(out[5], out5, enable);
	and #5 out_method6(out[6], out6, enable);
	and #5 out_method7(out[7], out7, enable);

endmodule
