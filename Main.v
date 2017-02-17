`timescale 1ns / 1ps

module Main (CLK, CLR, RAMAddr, DataIn, DataOut, MDataIn, MDataOut, RD, CMWr, MRd, WrAddrIn, CacheAddr, ENum, BNum, LA);
	input CLK, CLR, RD, CMWr;
	input [31:0] RAMAddr, DataIn;
	output MRd;
	output [31:0] MDataIn, MDataOut, WrAddrIn, DataOut;
	output [17:0] CacheAddr;
	output [13:0] ENum, BNum;
	output [3:0] LA;
	
	RAM my_RAM (
    .MRd(MRd), 
    .CMWr(CMWr), 
    .Addr(WrAddrIn), 
	 .MDataIn(MDataIn), 
    .MDataOut(MDataOut)
    );
	 
	 cache my_cache (
    .CLR(CLR), 
    .RAMAddr(RAMAddr), 
    .DataIn(DataIn), 
	 .DataOut(DataOut), 
    .MDataIn(MDataOut), 
	 .MDataOut(MDataIn), 
    .RD(RD), 
    .CMWr(CMWr), 
    .MRd(MRd), 
    .WrAddrIn(WrAddrIn), 
    .CacheAddr(CacheAddr), 
    .ENum(ENum), 
    .BNum(BNum), 
    .LA(LA)
    );
	 
	 PC my_PC (
    .CLK(CLK), 
    .CLR(CLR), 
    .MRd(MRd), 
	 .CMWr(CMWr), 
    .AddrIn(RAMAddr), 
    .AddrOut(WrAddrIn)
    );
endmodule
