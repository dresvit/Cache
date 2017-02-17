`timescale 1ns / 1ps

module myCache_test;

	// Inputs
	reg CLK;
	reg CLR;
	reg [31:0] RAMAddr;
	reg RD;
	reg CMWr;
	reg [31:0] DataIn;
	

	// Outputs
	wire [17:0] CacheAddr;
	wire [13:0] ENum;
	wire [13:0] BNum;
	wire [3:0] LA;
	wire [31:0] WrAddrIn;
	wire [31:0] MDataIn;
	wire [31:0] MDataOut;
	wire [31:0] DataOut;
	wire MRd;

	// Instantiate the Unit Under Test (UUT)
	Main uut (
		.CLK(CLK), 
		.CLR(CLR), 
		.RAMAddr(RAMAddr), 
		.DataIn(DataIn), 
		.DataOut(DataOut), 
		.MDataIn(MDataIn), 
		.MDataOut(MDataOut), 
		.RD(RD), 
		.CMWr(CMWr), 
		.MRd(MRd), 
		.WrAddrIn(WrAddrIn), 
		.CacheAddr(CacheAddr), 
		.ENum(ENum), 
		.BNum(BNum), 
		.LA(LA)
	);
	
	initial begin
		// Initialize Inputs
		RD = 1;
		CMWr = 0;
		RAMAddr = 0;
		
		CLR = 1;
		CLK = 0;
		CLK = 1;
		#5;
		CLR = 0;
		#5;
		

		// Wait 100 ns for global reset to finish
		
		#100;   //Cache 有数据（先给Cache初始化数据），直接读取，再送出
		CMWr = 0;
		RD = 1;
		RD = 0;   //读
		RAMAddr = 32'h00000000; //数据地址 区号=14`b00000000000000,块号=14'b00000000000000
		
		#100;   //Cache 无数据，从存储器读取数据，然后写Cache，再送出
		CMWr = 0;
		RD = 1;
		RD = 0;   //读
		RAMAddr = 32'h00000014; //数据地址 区号=14'b00000000000000,块号=14'b00000000000001
		
		#100;   //修改存储器
		RD = 1;
		CMWr = 0;
		CMWr = 1;   //写
		RAMAddr = 32'h00000028; //数据地址 区号=14'b00000000000000,块号=14'b00000000000010
		DataIn = 32'h88888888;    //用这个数据修改存储器单元内容
		
		#100;   //修改Cache和存储器
		RD = 1;
		CMWr = 0;
		CMWr = 1;   //写
		RAMAddr = 32'h0000003C; //数据地址 区号=14`b00000000000000,块号=14'b00000000000011
		DataIn = 32'h33333333;    //用这个数据修改该地址的Cache和存储器单元内容
		
	end
	
	always #5
			CLK = ~CLK;
      
endmodule

