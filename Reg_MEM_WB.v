`timescale 1ns / 1ps

module Reg_MEM_WB(clk,	mwreg,mm2reg,data_out,maluout,mrdrt,	//inputs
								wwreg,wm2reg,wdata_out,waluout,wrdrt, //outputs
								MEM_ins_type, MEM_ins_number, WB_ins_type, WB_ins_number);	
	input clk,	mwreg,mm2reg;
	input [31:0]	data_out,maluout;
	input [4:0]		mrdrt;
	
	input[3:0] MEM_ins_type;
	input[3:0]	MEM_ins_number;
	output[3:0] WB_ins_type;
	output[3:0] WB_ins_number;
	
	output wwreg,wm2reg;
	output [31:0]	wdata_out,waluout;
	output [4:0]		wrdrt;	

	reg wwreg,wm2reg;
	reg [31:0]	wdata_out,waluout;
	reg [4:0]		wrdrt;	
	reg[3:0] WB_ins_type;
	reg[3:0] WB_ins_number;
	
	always@(posedge clk)	begin
		wwreg <= mwreg;
		wm2reg <= mm2reg;
		wdata_out <= data_out;
		waluout <= maluout;
		wrdrt <= mrdrt;
		WB_ins_type <= MEM_ins_type;
		WB_ins_number <= MEM_ins_number;
	end
endmodule



