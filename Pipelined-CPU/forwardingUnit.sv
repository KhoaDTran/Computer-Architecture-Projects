module forwardingUnit(ExMem_RegWrite, MemWr_RegWrite, EXflag, oldBR, ExMem_Rd, MemWr_Rd, Rn, Rm, forwardA, forwardB, forwardFlag);
	input logic ExMem_RegWrite, MemWr_RegWrite, EXflag, oldBR;
	input logic [4:0] ExMem_Rd, MemWr_Rd, Rn, Rm;
	output logic [1:0] forwardA, forwardB;
	output logic forwardFlag;
	
	always_comb begin 
		
		//forward output data control
		if ((ExMem_RegWrite) & (ExMem_Rd == Rm) & (ExMem_Rd != 5'd31)) begin
			forwardB = 2'b10;
		end else if ((MemWr_RegWrite) & (MemWr_Rd == Rm) & (MemWr_Rd != 5'd31)) begin
			forwardB = 2'b01;
		end else begin
			forwardB = 2'b00;
		end	
		
		//exec hazard 
		if ((ExMem_RegWrite) & (ExMem_Rd == Rn) & (ExMem_Rd != 5'd31))
			forwardA = 2'b10;
		else if ((MemWr_RegWrite) & (MemWr_Rd == Rn) & (MemWr_Rd != 5'd31))
			forwardA = 2'b01;
		else
			forwardA = 2'b00;	
		
		//forward flag
		if (oldBR & ~EXflag) begin
			forwardFlag = 1'b1;
		end else begin
			forwardFlag = 1'b0;
		end
	end

endmodule
