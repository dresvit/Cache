`timescale 1ns / 1ps

module cache (CLR, RAMAddr, DataIn, DataOut, MDataIn, MDataOut, RD, CMWr, MRd, WrAddrIn, CacheAddr, ENum, BNum, LA);
	input CLR, RD, CMWr;
	input [31:0] RAMAddr, WrAddrIn, DataIn, MDataIn;
	output reg MRd;
	output reg [31:0] DataOut, MDataOut;
	output [17:0] CacheAddr;
	output [13:0] ENum, BNum;
	output [3:0] LA;
	reg [7:0] memory [0:262143];
	reg [14:0] Table [0:16383];
	reg [17:0] WrAddr;
	reg flag;
	integer i;
	
	assign CacheAddr = RAMAddr[17:0];
	assign ENum = RAMAddr[31:18];
	assign BNum = RAMAddr[17:4];
	assign LA = RAMAddr[3:0];
	
	initial begin
		flag = 1;
		
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
		
		for (i = 16; i < 32; i = i + 1) begin
			memory[i] = 0;
		end
		
		for (i = 32; i < 48; i = i + 1) begin
			memory[i] = 8'b0000001;
		end
		
		for (i = 48; i < 64; i = i + 4) begin
			memory[i] = 8'b00001111;
			memory[i+1] = 8'b00001111;
			memory[i+2] = 8'b00000000;
			memory[i+3] = 8'b00000000;
		end
	end
	
	always @(posedge CLR) begin
		for (i = 0; i < 16384; i = i + 1)
			Table[i] = 0;
		Table[0] = 15'b000000000000001;
		Table[1] = 15'b000000001000000;
		Table[2] = 15'b000000000010000;
		Table[3] = 15'b000000000000001;
	end
	
	always @(WrAddrIn) begin
		#0.002;
		if (RD == 0 && WrAddrIn > 0) begin
			WrAddr = WrAddrIn[17:0];
			memory[WrAddr] = MDataIn[7:0];
			memory[WrAddr+1] = MDataIn[15:8];
			memory[WrAddr+2] = MDataIn[23:16];
			memory[WrAddr+3] = MDataIn[31:24];
			if (WrAddr[3:0] == 4'b1100) begin
				MRd = 1;
				Table[BNum][14:1] = ENum;
				Table[BNum][0:0] = 1;
				flag = 1;
				DataOut = {memory[CacheAddr+3], memory[CacheAddr+2], memory[CacheAddr+1], memory[CacheAddr]};
			end
		end
	end
	
	always @(*) begin
		#0.001;
		if (RD == 0) begin
			if (Table[BNum][14:1] == ENum && Table[BNum][0:0] == 1) begin
				DataOut = {memory[CacheAddr+3], memory[CacheAddr+2], memory[CacheAddr+1], memory[CacheAddr]};
			end
			else if (flag == 1) begin
				MRd = 0;
				flag = 0;
			end
		end
		if (CMWr == 1) begin
			if (Table[BNum][14:1] == ENum && Table[BNum][0:0] == 1) begin
				memory[CacheAddr] = DataIn[7:0];
				memory[CacheAddr+1] = DataIn[15:8];
				memory[CacheAddr+2] = DataIn[23:16];
				memory[CacheAddr+3] = DataIn[31:24];
			end
			MDataOut = DataIn;
		end
	end
endmodule
