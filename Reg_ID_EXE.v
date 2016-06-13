`timescale 1ns / 1ps

module Reg_ID_EXE(clk, 	wreg,	m2reg, wmem, aluc, shift, aluimm,  data_a, data_b, data_imm, id_destR,//inputs
								ewreg,em2reg,	ewmem,ealuc, eshift, ealuimm, odata_a,odata_b, odata_imm, e_destR,
								ID_ins_type, ID_ins_number, EXE_ins_type, EXE_ins_number);	//outputs
	input		clk;
	input 	wreg,	m2reg,	wmem,	shift,	aluimm;
	input [3:0] 	aluc;
	input [31:0]	data_a,	data_b,	data_imm;
	
	input[4:0] id_destR;
	input[3:0] 	ID_ins_type;
	input[3:0]	ID_ins_number;
	

	output 	ewreg,	em2reg,	ewmem,	eshift,	ealuimm;
	output [3:0] 	ealuc;
	output [31:0]	odata_a,odata_b,odata_imm;
	
	output[4:0] e_destR;

	output[3:0] EXE_ins_type;
	output[3:0] EXE_ins_number;
	
	reg[3:0] EXE_ins_type;
	reg[3:0] EXE_ins_number;
	reg 	ewreg,	em2reg,	ewmem,	eshift,	ealuimm;
	reg [3:0] 	ealuc;
	reg [31:0]	odata_a,odata_b,odata_imm;

	reg [4:0] e_destR;
	//reg [4:0]e_rt;
	//reg [4:0]e_rd;
	
	always@(posedge clk) begin
			ewreg <= wreg;
			em2reg <= m2reg;
			ewmem <= wmem;
			eshift <= shift;
			ealuimm <= aluimm;
			ealuc <= aluc;
			odata_a <= data_a;
			odata_b <= data_b;
			odata_imm <= data_imm;
			EXE_ins_type <= ID_ins_type;
			EXE_ins_number <= ID_ins_number;
			e_destR <= id_destR;
	end
endmodule

