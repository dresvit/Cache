`timescale 1ns / 1ps

module RAM (MRd, CMWr, Addr, MDataIn, MDataOut);
	input MRd, CMWr;
	input [31:0] Addr;
	input [31:0] MDataIn;
	output reg [31:0] MDataOut;
	reg [7:0] memory [0:299999];
	integer i;
	
	initial begin
		memory[0] = 8'b11110000;
		memory[1] = 8'b11110000;
		memory[2] = 8'b00000000;
		memory[3] = 8'b00010001;
		
		for (i = 4; i < 16; i = i + 4) begin
			memory[i] = memory[i-4] + 1;
			memory[i+1] = memory[i-3];
			memory[i+2] = memory[i-2];
			memory[i+3] = memory[i-1];
		end
		
		memory[16] = 8'b11111111;
		memory[17] = 8'b11111111;
		memory[18] = 8'b00000000;
		memory[19] = 8'b00000000;
		
		for (i = 20; i < 32; i = i + 4) begin
			memory[i] = memory[i-4] + 1;
			memory[i+1] = memory[i-3];
			memory[i+2] = memory[i-2];
			memory[i+3] = memory[i-1];
		end
		
		for (i = 32; i < 48; i = i + 1) begin
			memory[i] = 0;
		end
		
		for (i = 48; i < 64; i = i + 4) begin
			memory[i] = 8'b00001111;
			memory[i+1] = 8'b00001111;
			memory[i+2] = 8'b00000000;
			memory[i+3] = 8'b00000000;
		end
	end
	
	always @(*) begin
		#0.001;
		if (MRd == 0) begin
			MDataOut = {memory[Addr+3], memory[Addr+2], memory[Addr+1], memory[Addr]};
		end
		if (CMWr == 1) begin
			memory[Addr] = MDataIn[7:0];
			memory[Addr+1] = MDataIn[15:8];
			memory[Addr+2] = MDataIn[23:16];
			memory[Addr+3] = MDataIn[31:24];
		end
	end
endmodule
