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
		
		#100;   //Cache �����ݣ��ȸ�Cache��ʼ�����ݣ���ֱ�Ӷ�ȡ�����ͳ�
		CMWr = 0;
		RD = 1;
		RD = 0;   //��
		RAMAddr = 32'h00000000; //���ݵ�ַ ����=14`b00000000000000,���=14'b00000000000000
		
		#100;   //Cache �����ݣ��Ӵ洢����ȡ���ݣ�Ȼ��дCache�����ͳ�
		CMWr = 0;
		RD = 1;
		RD = 0;   //��
		RAMAddr = 32'h00000014; //���ݵ�ַ ����=14'b00000000000000,���=14'b00000000000001
		
		#100;   //�޸Ĵ洢��
		RD = 1;
		CMWr = 0;
		CMWr = 1;   //д
		RAMAddr = 32'h00000028; //���ݵ�ַ ����=14'b00000000000000,���=14'b00000000000010
		DataIn = 32'h88888888;    //����������޸Ĵ洢����Ԫ����
		
		#100;   //�޸�Cache�ʹ洢��
		RD = 1;
		CMWr = 0;
		CMWr = 1;   //д
		RAMAddr = 32'h0000003C; //���ݵ�ַ ����=14`b00000000000000,���=14'b00000000000011
		DataIn = 32'h33333333;    //����������޸ĸõ�ַ��Cache�ʹ洢����Ԫ����
		
	end
	
	always #5
			CLK = ~CLK;
      
endmodule

