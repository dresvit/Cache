`timescale 1ns / 1ps

module PC (CLK, CLR, MRd, CMWr, AddrIn, AddrOut);
	input CLK, CLR, MRd, CMWr;
	input [31:0] AddrIn;
	output reg [31:0] AddrOut;
	reg [31:0] NextPC;
	always @(MRd) begin
		if (MRd == 0)
			NextPC = {AddrIn[31:4], 4'b0000};
	end
	always @(posedge CLK) begin
		if (CLR == 1)
			AddrOut = 0;
		if (CLR == 0 && MRd == 0) begin
			AddrOut = NextPC;
			if (AddrOut[3:0] != 4'b1100) NextPC = NextPC + 4;
		end
		if (CLR == 0 && CMWr == 1) begin
			AddrOut = AddrIn;
		end
	end
endmodule
