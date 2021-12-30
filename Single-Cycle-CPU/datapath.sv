`timescale 1ns/10ps
module datapath (Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite, MemToReg, read_enable, instruction,
					 xfer_size, clk, reset, overflow, negative, zero, carry_out, flagReg, extendIn, shiftDir);
	input logic [31:0] instruction;
	input logic Reg2Loc, RegWrite, MemWrite, MemToReg, read_enable, flagReg, clk, reset, extendIn, shiftDir;
	input logic [1:0] ALUSrc;
	input logic [2:0] ALUOp;
	input logic [3:0] xfer_size;
	output logic overflow, negative, zero, carry_out;
	parameter DELAY = 0.05;
	
	// ************* DECODE (part 2) *************
	
	logic [4:0] Ab;
	// RegToLoc Mux
	mux10_5  regtoLoc(.i0(instruction[4:0]), .i1(instruction[20:16]), .sel(Reg2Loc), .out(Ab));
	
	logic [63:0] Dw, Da, Db;
	regFile register (.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(instruction[9:5]), .ReadRegister2(Ab), .WriteRegister(instruction[4:0]), .RegWrite, .clk);

	// Zero extension for Imm12
	logic [63:0] Imm12Extended;
	assign Imm12Extended = {{(64-12){1'b0}}, instruction[21:10]};
	// ********* zeroExtend #(.WIDTH(12)) extendIMM(.in(instruction[21:10]), .out(Imm12Extended));

	// Sign extension for DAddr9
	logic [63:0] DAddr9Extended;
	assign DAddr9Extended = {{(64-9){instruction[20]}}, instruction[20:12]};
	// ********** signExtend #(.WIDTH(9)) extendDAddr9(.in(instruction[20:12]), .out(DAddr9Extended));
	
	// ************* EXECUTE *************
	/*
	Variables pipelined from decode to execute:
		-Da : ReadData1 from INSTRUCTION
		-Db : ReadData2 from INSTRUCTION
		-shiftDir: direction shift from INSTRUCTION
		-/*shamt: how much shift from INSTRUCTION*
		-Imm12Extended: zero extension for Imm12 from INSTRUCTION
		-DAddr9extended:
		-extendIn: 
		-ALUSrc:
		-ALUOp:
		-flagReg: (for enable?)
		
		-MemWrite: (pipeline for MEMORY)
		-read_Enable: (pipeline for MEMORY)
		-xfer_size: (pipeline for MEMORY)
		
		-MemToReg: (pipline for WRITEBACK)
		-Dw: (pipeline for WRITEBACK)
	*/
	logic [63:0] Da_execute, Db_execute, Imm12Extended_execute, Daddr9extended_execute, Dw_execute;
	logic shiftDir_execute, extendIn_execute, flagReg_execute, MemWrite_execute, read_Enable_execute, MemToReg_execute;
	logic [1:0] ALUSrc_execute;
	logic [2:0] ALUOp_execute;
	logic [3:0] xfer_size_execute; 
	
	pipeline_register #(64) piped_Da_execute(.q(Da_execute), .d(Da), .reset, .clk);
	pipeline_register #(64) piped_Db_execute(.q(Db_execute), .d(Db), .reset, .clk);
	pipeline_register #(64) piped_Imm12Extended_execute(.q(Imm12Extended_execute), .d(Imm12Extended), .reset, .clk);
	pipeline_register #(64) piped_Daddr9extended_execute(.q(Daddr9extended_execute), .d(Daddr9extended), .reset, .clk);
	// pipeline_register #(64) piped_Dw_execute(.q(Dw_execute), .d(Dw), .reset, .clk);
	pipeline_register #(64) piped_ShiftDir_execute(.q(shiftDir_execute), .d(shiftDir), .reset, .clk);
	pipeline_register #(64) piped_extendedIn_execute(.q(extendIn_execute), .d(extendedIn), .reset, .clk);
	pipeline_register #(64) piped_flagReg_execute(.q(flagReg_execute), .d(flagReg), .reset, .clk);
	pipeline_register #(64) piped_MemWrite_execute(.q(MemWrite_execute), .d(MemWrite), .reset, .clk);
	pipeline_register #(64) piped_read_Enable_execute(.q(read_Enable_execute), .d(read_Enable), .reset, .clk);
	pipeline_register #(64) piped_MemToReg_execute(.q(MemToReg_execute), .d(MemToReg), .reset, .clk);
	pipeline_register #(64) piped_ALUSrc_execute(.q(ALUSrc_execute), .d(ALUSrc), .reset, .clk);
	pipeline_register #(64) piped_ALUOp_execute(.q(ALUOp_execute), .d(ALUOp), .reset, .clk);
	pipeline_register #(64) piped_xfer_size_execute(.q(xfer_size_execute), .d(xfer_size), .reset, .clk);
	
	logic [63:0] multOut, multTemp;
	mult multiply(.A(Da_execute), .B(Db_execute), .doSigned(1'b1), .mult_low(multOut), .mult_high(multTemp));
	
	logic [63:0] shiftResult;
	shifter shift(.value(Da_execute), .direction(shiftDir_execute), .distance(instruction[15:10]), .result(shiftResult));
	
	logic [63:0] extendOut;
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: eachExtendMux
			mux2_1 extendMux (.out(extendOut[i]), .i0(Imm12Extended_execute[i]), .i1(DAddr9Extended_execute[i]), .sel(extendIn_execute));
		end
	endgenerate
	
	// ALUSrc MUX
	logic [63:0] ALUSrcMuxOut;
	
	genvar k;
	generate 
		for (k = 0; k < 64; k++) begin: eachALUSrcMux
			mux4_1 ALUSrcMuxes (.sel1(ALUSrc_execute[1]), .sel0(ALUSrc_execute[0]), .i3(multOut[k]), .i2(shiftResult[k]), .i1(extendOut[k]), .i0(Db_execute[k]), .out(ALUSrcMuxOut[k]));
		end
	endgenerate
	
	// Put information into ALU
	logic [63:0] ALUOut;
	logic negativeFlag, zeroFlag, overflowFlag, carryOutFlag;
	alu math (.A(Da_execute), .B(ALUSrcMuxOut), .cntrl(ALUOp_execute), .result(ALUOut), .negative(negativeFlag), .zero(zeroFlag), .overflow(overflowFlag), .carry_out(carryOutFlag));
	
	logic zeroFF;
	logic updateZeroFlag;
	and #DELAY (updateZeroFlag, zeroFlag, ~flagReg_execute);
	assign zero = updateZeroFlag;
	
	// Put flag into a flagRegister
	flagRegs flags (.d({negativeFlag, zeroFlag, overflowFlag, carryOutFlag}), .q({negative, zeroFF, overflow, carry_out}), .en(~flagReg_execute), .reset, .clk);
	
	// ************* MEMORY *************
	/*
	* Variables piplined from ALUSrc Muz and Memory
	*  	- ALUOut: output of the ALU math
	* 		- Db: ReadData2
	* 		- MemWrite: 
	* 		- read_enable: 
	* 		- xfer_size: 
	*
	*		- MemToReg: (pipline for WRITEBACK)
	*/
	
	logic [63:0] ALUOut_memory, Db_memory; 
	logic MemWrite_memory, read_enable_memory, MemToReg_memory; 
	logic [3:0] xfer_size_memory;
	
	pipeline_register #(64) piped_ALUOut_memory(.q(ALUOut_memory), .d(ALUOut_execute), .reset, .clk);
	pipeline_register #(64) piped_Db_memory(.q(Db_memory), .d(Db_execute), .reset, .clk);
	pipeline_register #(64) piped_MemWrite_memory(.q(MemWrite_memory), .d(MemWrite_execute), .reset, .clk);
	pipeline_register #(64) piped_read_enable_memory(.q(read_enable_memory), .d(read_enable_execute), .reset, .clk);
	pipeline_register #(64) piped_MemToReg_memory(.q(MemToReg_memory), .d(MemToReg_execute), .reset, .clk);
	pipeline_register #(64) piped_xfer_size_memory(.q(xfer_size_memory), .d(xfer_size_execute), .reset, .clk);
	
	// Memory Read/Write
	logic [63:0] memoryOut;
	datamem mem (.address(ALUOut), .write_enable(MemWrite), .read_enable, .write_data(Db), .clk, .xfer_size, .read_data(memoryOut));
	
	// ************* WRITEBACK *************
	/*
	* Varibales pipelined from Memory to Writeback
	* 		- ALUOut: output of the ALU math
	* 		- memoryOut: output read data
	*		- MemToReg
	* 		- /*Dw:*/
	*/
	
	// MemToReg Mux
	//mux128_64 memRegMux (.inZero(ALUOut), .inOne(memoryOut), .sel(MemToReg), .out(Dw));
	
	logic [63:0] ALUOut_wb, memoryOut_wb;
	logic MemToReg_wb;
	
	pipeline_register #(64) piped_ALUOut_wb(.q(ALUOut_wb), .d(ALUOut_memory), .reset, .clk);
	pipeline_register #(64) piped_memoryOut_wb(.q(memoryOut_wb), .d(memoryOut), .reset, .clk);
	pipeline_register #(64) piped_MemToReg_wb(.q(MemToReg_wb), .d(MemToReg_memory), .reset, .clk);
	
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin: muxess
			mux2_1 muxs(.i0(ALUOut_wb[j]), .i1(memoryOut_wb[j]), .out(Dw[j]), .sel(MemToReg_wb));
		end
	endgenerate
	
	
endmodule
