//Khoa Tran and Melinda Tran
//Lab 1--D_ff module
//D-flip flop module for connecting bits of data acting as registers

module d_ff (q, d, reset, clk);
	output reg q; 
	input d, reset, clk; 
 
	always_ff @(posedge clk) 
		if (reset) 
			q <= 0;  // On reset, set to 0 
		else 
			q <= d; // Otherwise out = d 
endmodule 