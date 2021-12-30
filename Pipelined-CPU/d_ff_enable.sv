//Khoa Tran and Melinda Tran
//Lab 1--D_ff enable module
//D-flip flop enable module to ensure enabled is on when writing data to
//d_ff using mux2x1 and dff module

module d_ff_enable #(parameter SZ = 64) (q, d, en, clk);
	input logic clk, en;
	input logic [SZ-1:0] d;
	output logic [SZ-1:0] q;
	
	logic [SZ-1:0] muxOut;
	
	
	genvar i;
	generate
		for (i = 0; i <= SZ-1; i++) begin: eachDFF
			mux2_1 mux1(.out(muxOut[i]), .i0(q[i]), .i1(d[i]), .sel(en)); 
			//instantiation of dff
			d_ff dff1(.q(q[i]), .d(muxOut[i]), .reset(1'b0), .clk);
		end
	endgenerate
endmodule

	