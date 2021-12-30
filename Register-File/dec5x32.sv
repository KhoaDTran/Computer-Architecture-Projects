//Khoa Tran and Melinda Tran
//Lab 1--dec5x32 module
//dec5x32 module using a dec2x4 and four dec3x8 to combine and create
//a 5x32 decoder for outputing the data at the writeRegister when
//regWrite is enabled

`timescale 10ps/1fs
module dec5x32 (WriteRegister, decoded, RegWrite);
	//Define inputs, outputs and constant
	input logic [4:0] WriteRegister;
	input logic RegWrite;
	output logic [31:0] decoded;
	
	// 2 MSB to 2-to-4 decoder to select which 3-to-8 decoder to produce output
	logic [3:0] select3to8;     
	dec2x4 decoder2to4 (.in(WriteRegister[4:3]), .out(select3to8[3:0]), .enable(RegWrite));
	
	// 3 LSB to 3-to-8 decoder to produce decoded output
	dec3x8 dec3_8_1 (.in(WriteRegister[2:0]), .out(decoded[7:0]),   .enable(select3to8[0]));
	dec3x8 dec3_8_2 (.in(WriteRegister[2:0]), .out(decoded[15:8]),  .enable(select3to8[1]));
	dec3x8 dec3_8_3 (.in(WriteRegister[2:0]), .out(decoded[23:16]), .enable(select3to8[2]));
	dec3x8 dec3_8_4 (.in(WriteRegister[2:0]), .out(decoded[31:24]), .enable(select3to8[3]));

endmodule