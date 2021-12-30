`timescale 1ns/10ps

module norGates (subResult, zeroFlag);
	parameter gateDelay = 0.05;
	input logic [15:0] subResult;
	output logic zeroFlag;
	
	logic [3:0] tempResults;
	
	//gate logic to check if zeroFlag should be true
	or #gateDelay gateA (tempResults[0], subResult[3], subResult[2], subResult[1], subResult[0]);
	or #gateDelay gateB (tempResults[1], subResult[7], subResult[6], subResult[5], subResult[4]);
	or #gateDelay gateC (tempResults[2], subResult[11], subResult[10], subResult[9], subResult[8]);
	or #gateDelay gateD (tempResults[3], subResult[15], subResult[14], subResult[13], subResult[12]);
	
	nor #gateDelay norGate (zeroFlag, tempResults[0], tempResults[1], tempResults[2], tempResults[3]);
	
	
endmodule
