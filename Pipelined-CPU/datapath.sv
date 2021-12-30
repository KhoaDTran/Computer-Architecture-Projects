`timescale 1ns/10ps
module datapath (Reg2Loc, RegWrite, ALUSrc, ALUOp, MemWrite, MemToReg, read_enable, instruction, oldBR,
					 xfer_size, clk, reset, overflow, negative, zero, carry_out, flagReg, extendIn, shiftDir);
	input logic [31:0] instruction;
	input logic Reg2Loc, RegWrite, MemWrite, MemToReg, read_enable, flagReg, clk, reset, extendIn, shiftDir;
	input logic [1:0] ALUSrc;
	input logic [2:0] ALUOp;
	input logic [3:0] xfer_size;
	logic [4:0] Rd;
	input logic oldBR;
	output logic overflow, negative, zero, carry_out;
	parameter DELAY = 0.05;
	
	logic [1:0] forwardA, forwardB;
	logic forwardFlag;
	logic [4:0] Rd_execute, Rd_mem, Rd_WB;
	logic RegWrite_execute, RegWrite_memory, RegWrite_WB;
	logic [63:0] Dw, Da, Db, DaRF, DbRF, aluBRF;
	logic zeroEn, negativeEn, carry_outEn, overflowEn;
	logic [4:0] Ab;
	logic [63:0] Da_execute, Db_execute, Imm12Extended_execute, DAddr9Extended_execute, Dw_execute, alu_execute, alu_memory;
	logic shiftDir_execute, extendIn_execute, flagReg_execute, MemWrite_execute, read_enable_execute, MemToReg_execute;
	logic [1:0] ALUSrc_execute;
	logic [2:0] ALUOp_execute;
	logic [3:0] xfer_size_execute;
	logic [63:0] DAddr9Extended;
	logic [63:0] Imm12Extended;
	logic [63:0] ALUSrcMuxOut, ALUSrcMuxOutEXEC;
	logic [63:0] multOut, multTemp;
	logic [63:0] shiftResult;
	logic [63:0] ALUOut_memory, Db_memory; 
	logic MemWrite_memory, read_enable_memory, MemToReg_memory; 
	logic [3:0] xfer_size_memory;
	logic [63:0] ALUOut;
	logic negativeFlag, zeroFlag, overflowFlag, carryOutFlag, zeroTemp;
	logic [63:0] extendOut;
	logic [63:0] memoryOut;
	logic [63:0] memory_Dw, memoryOut_wb;
	logic MemToReg_wb;
	

	assign Rd = instruction[4:0];
	
	determineZeroFlag checkZero(.result(DbRF), .zeroFlag(zero));
	
	//Forwarding
	
	forwardingUnit forward(.ExMem_RegWrite(RegWrite_execute), .MemWr_RegWrite(RegWrite_memory), .EXflag(flagReg_execute), .oldBR, .ExMem_Rd(Rd_execute), .MemWr_Rd(Rd_mem), .Rn(instruction[9:5]), .Rm(Ab), .forwardA, .forwardB, .forwardFlag);
	
	//forwarding mux
	mux256_64 Amux (.i3(64'd0), .i2(ALUOut), .i1(Dw), .i0(Da), .sel(forwardA), .out(DaRF));
	mux256_64 Bmux (.i3(64'd0), .i2(ALUOut), .i1(Dw), .i0(Db), .sel(forwardB), .out(aluBRF));
	mux256_64 Outmux (.i3(64'd0), .i2(ALUOut), .i1(Dw), .i0(Db), .sel(forwardB), .out(DbRF));
	
	
	d_ff_enable #(.SZ(1)) zeroDFF(.q(zeroEn), .d(zeroFlag), .en(~flagReg_execute), .clk); //might not be ~
	d_ff_enable #(.SZ(1)) negativeDFF(.q(negativeEn), .d(negativeFlag), .en(~flagReg_execute), .clk);
	d_ff_enable #(.SZ(1)) overflowDFF(.q(carry_outEn), .d(carryOutFlag), .en(~flagReg_execute), .clk);
	d_ff_enable #(.SZ(1)) carryOutDFF(.q(overflowEn), .d(overflowFlag), .en(~flagReg_execute), .clk);
	
	mux2_1 zeroForward (.i1(zeroFlag), .i0(zeroEn), .sel(forwardFlag), .out(zeroTemp));
	mux2_1 negativeForward (.i1(negativeFlag), .i0(negativeEn), .sel(forwardFlag), .out(negative));
	mux2_1 carryoutForward (.i1(overflowFlag), .i0(overflowEn), .sel(forwardFlag), .out(overflow));
	mux2_1 overflowForward (.i1(carryOutFlag), .i0(carry_outEn), .sel(forwardFlag), .out(carry_out));
	
	
	// ************* DECODE (part 2) *************
	
	
	// RegToLoc Mux
	mux10_5 regtoLoc(.i0(Rd), .i1(instruction[20:16]), .sel(Reg2Loc), .out(Ab));
	
	regFile register (.ReadData1(Da), .ReadData2(Db), .WriteData(memory_Dw), .ReadRegister1(instruction[9:5]), .ReadRegister2(Ab), .WriteRegister(Rd_WB), .RegWrite(RegWrite_WB), .clk);

	// Zero extension for Imm12
	
	assign Imm12Extended = {{(64-12){1'b0}}, instruction[21:10]};
	// ********* zeroExtend #(.WIDTH(12)) extendIMM(.in(instruction[21:10]), .out(Imm12Extended));

	// Sign extension for DAddr9
	
	assign DAddr9Extended = {{(64-9){instruction[20]}}, instruction[20:12]};
	// ********** signExtend #(.WIDTH(9)) extendDAddr9(.in(instruction[20:12]), .out(DAddr9Extended));
	
	// ************* EXECUTE *************
	/*
	Variables pipelined from decode to execute:
		-Da : ReadData1 from INSTRUCTION
		-Db : ReadData2 from INSTRUCTION
		-shiftDir: direction shift from INSTRUCTION
		-shamt: how much shift from INSTRUCTION*
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
	
	
		
	d_ff_enable #(.SZ(5)) pipped_Rd_ex(.q(Rd_execute), .d(Rd), .en(1'b1), .clk);
	d_ff_enable #(.SZ(5)) pipped_Rd_mem(.q(Rd_mem), .d(Rd_execute), .en(1'b1), .clk);
	
	d_ff_enable #(.SZ(64)) piped_Da_execute(.q(Da_execute), .d(DaRF), .en(1'b1), .clk);
	d_ff_enable #(.SZ(64)) piped_Db_execute(.q(Db_execute), .d(DbRF), .en(1'b1), .clk);
	d_ff_enable #(.SZ(64)) piped_alu_execute(.q(alu_execute), .d(aluBRF), .en(1'b1), .clk);
	d_ff_enable #(.SZ(64)) piped_alu_mem(.q(alu_memory), .d(alu_execute), .en(1'b1), .clk);
	d_ff_enable #(.SZ(64)) piped_Imm12Extended_execute(.q(Imm12Extended_execute), .d(Imm12Extended), .en(1'b1), .clk);
	d_ff_enable #(.SZ(64)) piped_Daddr9extended_execute(.q(DAddr9Extended_execute), .d(DAddr9Extended), .en(1'b1), .clk);
	
	// pipeline_register #(64) piped_Dw_execute(.q(Dw_execute), .d(Dw), .reset, .clk);
	d_ff_enable #(.SZ(1)) piped_RegWrite_execute(.q(RegWrite_execute), .d(RegWrite), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_RegWrite_memory(.q(RegWrite_memory), .d(RegWrite_execute), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_RegWrite_WB(.q(RegWrite_WB), .d(RegWrite_memory), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_ShiftDir_execute(.q(shiftDir_execute), .d(shiftDir), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_extendedIn_execute(.q(extendIn_execute), .d(extendIn), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_flagReg_execute(.q(flagReg_execute), .d(flagReg), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_MemWrite_execute(.q(MemWrite_execute), .d(MemWrite), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_read_Enable_execute(.q(read_enable_execute), .d(read_enable), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_MemToReg_execute(.q(MemToReg_execute), .d(MemToReg), .en(1'b1), .clk);
	//pipeline_register #(2) piped_ALUSrc_execute(.q(ALUSrc_execute), .d(ALUSrc), .reset, .clk);
	d_ff_enable #(.SZ(3)) piped_ALUOp_execute(.q(ALUOp_execute), .d(ALUOp), .en(1'b1), .clk);
	d_ff_enable #(.SZ(4)) piped_xfer_size_execute(.q(xfer_size_execute), .d(xfer_size), .en(1'b1), .clk);
	
	
	mult multiply(.A(DaRF), .B(DbRF), .doSigned(1'b1), .mult_low(multOut), .mult_high(multTemp));
	
	
	shifter shift(.value(DaRF), .direction(shiftDir), .distance(instruction[15:10]), .result(shiftResult)); //might not need to cache
	
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: eachExtendMux
			mux2_1 extendMux (.out(extendOut[i]), .i0(Imm12Extended[i]), .i1(DAddr9Extended[i]), .sel(extendIn)); //might not need cache
		end
	endgenerate
	
	// ALUSrc MUX
	
	
	genvar k;
	generate 
		for (k = 0; k < 64; k++) begin: eachALUSrcMux
			mux4_1 ALUSrcMuxes (.sel1(ALUSrc[1]), .sel0(ALUSrc[0]), .i3(multOut[k]), .i2(shiftResult[k]), .i1(extendOut[k]), .i0(DbRF[k]), .out(ALUSrcMuxOut[k]));
		end
	endgenerate
	
	// Put information into ALU
	
	d_ff_enable #(.SZ(64)) piped_alu_ex(.q(ALUSrcMuxOutEXEC), .d(ALUSrcMuxOut), .en(1'b1), .clk);
	
	alu math (.A(Da_execute), .B(ALUSrcMuxOutEXEC), .cntrl(ALUOp_execute), .result(ALUOut), .negative(negativeFlag), .zero(zeroFlag), .overflow(overflowFlag), .carry_out(carryOutFlag));
	
//	logic zeroFF;
//	logic updateZeroFlag;
//	and #DELAY (updateZeroFlag, zeroFlag, ~flagReg_execute);
//	assign zero = updateZeroFlag;
//	
//	// Put flag into a flagRegister
//	flagRegs flags (.d({negativeFlag, zeroFlag, overflowFlag, carryOutFlag}), .q({negative, zeroFF, overflow, carry_out}), .en(~flagReg_execute), .reset, .clk);
	
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
	
	
	d_ff_enable #(.SZ(64)) piped_ALUOut_memory(.q(ALUOut_memory), .d(ALUOut), .en(1'b1), .clk);
	d_ff_enable #(.SZ(64)) piped_Db_memory(.q(Db_memory), .d(Db_execute), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_MemWrite_memory(.q(MemWrite_memory), .d(MemWrite_execute), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_read_enable_memory(.q(read_enable_memory), .d(read_enable_execute), .en(1'b1), .clk);
	d_ff_enable #(.SZ(1)) piped_MemToReg_memory(.q(MemToReg_memory), .d(MemToReg_execute), .en(1'b1), .clk);
	d_ff_enable #(.SZ(4)) piped_xfer_size_memory(.q(xfer_size_memory), .d(xfer_size_execute), .en(1'b1), .clk);
	
	// Memory Read/Write
	
	datamem mem (.address(ALUOut_memory), .write_enable(MemWrite_memory), .read_enable(read_enable_memory), .write_data(alu_memory), .clk(clk), .xfer_size(xfer_size_memory), .read_data(memoryOut));
	
	// ************* WRITEBACK *************
	/*
	Varibales pipelined from Memory to Writeback
	 		- ALUOut: output of the ALU math
	 		- memoryOut: output read data
			- MemToReg
	 		- Dw:
	*/
	
	// MemToReg Mux
	//mux128_64 memRegMux (.inZero(ALUOut), .inOne(memoryOut), .sel(MemToReg), .out(Dw));
	
	
	
	//pipeline_register #(64) piped_memoryOut_wb(.q(memoryOut_wb), .d(memoryOut), .reset, .clk);
	//pipeline_register #(64) piped_MemToReg_wb(.q(MemToReg_wb), .d(MemToReg_memory), .reset, .clk);
	
	genvar j;
	generate
		for (j = 0; j < 64; j++) begin: muxess
			mux2_1 muxs(.i0(ALUOut_memory[j]), .i1(memoryOut[j]), .out(Dw[j]), .sel(MemToReg_memory));
		end
	endgenerate
	
	d_ff_enable #(.SZ(64)) piped_dw(.q(memory_Dw), .d(Dw), .en(1'b1), .clk);
	
	d_ff_enable #(.SZ(5)) pipped_Rd_WB(.q(Rd_WB), .d(Rd_mem), .en(1'b1), .clk);
	
endmodule
