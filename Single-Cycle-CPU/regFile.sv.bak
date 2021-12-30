//Khoa Tran and Melinda Tran
//Lab 1--regFile module
//regFile module takes two register to read from, data to write to 
//a given register, and a regWrite as an enable to write the data to the register.
//Module usings no RTL as decoder and mux are created through logic gates
//with final dec5x32 and mux32x64

`timescale 1ns/1fs
module regFile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input logic [4:0] WriteRegister, ReadRegister1, ReadRegister2;
	input logic RegWrite, clk;
	input logic [63:0] WriteData;
	output logic [63:0] ReadData1, ReadData2;
	
	logic [3:0] outTemp;
	logic [31:0] decRegisters;
		
	
	logic [31:0][63:0] muxOut;
	
	dec5x32 mainDecoder(.WriteRegister, .decoded(decRegisters[31:0]), .RegWrite);
	
	mux32_64 mux1(.out(ReadData1[63:0]), .i(muxOut), .sel(ReadRegister1[4:0]));
	mux32_64 mux2(.out(ReadData2[63:0]), .i(muxOut), .sel(ReadRegister2[4:0]));
	
	genvar i, j;
	
	generate
		for(i=0; i<31; i++) begin : eachReg 
			for(j=0; j<64; j++) begin : eachDff 
				d_ff_enable regCreate(.q(muxOut[i][j]), .d(WriteData[j]), .en(decRegisters[i]), .clk);
		   end
		end
	endgenerate 

	integer k;
	
	always_comb begin
		for(k=0; k<64; k++) 
			muxOut[31][k] = 1'b0;
	end

endmodule


