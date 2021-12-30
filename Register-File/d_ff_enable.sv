//Khoa Tran and Melinda Tran
//Lab 1--D_ff enable module
//D-flip flop enable module to ensure enabled is on when writing data to
//d_ff using mux2x1 and dff module

module d_ff_enable(q, d, en, clk);
	input logic clk, en, d;
	output logic q;
	
	logic [1:0] in;
	logic muxOut;
	
	assign in[0] = q;
	assign in[1] = d;
	
	//instantiation of mux2x1
	mux2_1 mux1(.out(muxOut), .i0(in[0]), .i1(in[1]), .sel(en)); 
	
	//instantiation of dff
	d_ff dff1(.q(q), .d(muxOut), .reset(1'b0), .clk);
endmodule

	