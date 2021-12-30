`timescale 1ns/10ps

module determineZeroFlag (result, zeroFlag);
	parameter gateDelay = 0.05;
	input logic [63:0] result;
	output logic zeroFlag;
	
	logic [3:0] tempResults;
	
	//calling nor gates to check results in four chunks
	norGates gateA (result[15:0], tempResults[0]);
	norGates gateB (result[31:16], tempResults[1]);
	norGates gateC (result[47:32], tempResults[2]);
	norGates gateD (result[63:48], tempResults[3]);
	
	and #gateDelay andGate (zeroFlag, tempResults[0], tempResults[1], tempResults[2], tempResults[3]);

endmodule 