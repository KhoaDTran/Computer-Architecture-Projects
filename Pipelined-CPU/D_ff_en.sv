module D_ff_en (q, d, en, clk);
	input logic d, en, clk;
	output logic q;
	logic muxOut;
	logic [1:0] in;
	
	assign in[0] = q;
	assign in[1] = d;

	//Create a flip flop from the submodule D_FF
	d_ff d0(.q(q), .d(muxOut), .reset(1'b0), .clk);
	
	//Create a MUX through the submodule mux2_1
	mux2_1 theMux (.i1(in[1]), .i0(in[0]), .sel(en), .out(muxOut));
	
endmodule 