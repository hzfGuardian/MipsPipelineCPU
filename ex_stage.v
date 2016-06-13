`timescale 1ns / 1ps

module ex_stage (clk,  id_imm, id_inA, id_inB, id_wreg, id_m2reg, id_wmem, id_aluc, id_aluimm,id_shift, id_destR,
	ex_wreg, ex_m2reg, ex_wmem, ex_aluR, ex_inB, ex_destR, 
	ID_ins_type, ID_ins_number, EXE_ins_type, EXE_ins_number);

	input clk;
	input[31:0] id_imm;
	input[31:0] id_inA;
	input[31:0] id_inB;
	input id_wreg;
	input id_m2reg;
	input id_wmem;
	input[3:0] id_aluc;
	input id_aluimm;
	input id_shift;
	//input id_regrt;
	//input[4:0] id_rt;
	//input[4:0] id_rd;
	input [4:0] id_destR;
	
	input[3:0] ID_ins_type;
	input[3:0] ID_ins_number;
	output[3:0] EXE_ins_type;
	output[3:0] EXE_ins_number;
	
	
	
	wire ex_zero;//
	output ex_wreg;
	output ex_m2reg;
	output ex_wmem;
	output[31:0] ex_aluR;
	output[31:0] ex_inB;
	
	output[4:0] ex_destR;
	
	wire [3:0] ealuc;
	wire ealuimm,eshift;
	wire [31:0] sa;
	wire [31:0] edata_a,edata_b,a_in,b_in,odata_imm;
	wire [31:0] ex_aluR;
	wire [4:0] e_destR;
	
	assign a_in = eshift ? sa : edata_a;//
	
	assign b_in = ealuimm ? odata_imm : edata_b;
	assign ex_inB = edata_b;//
	
	assign ex_destR = e_destR;
	
	Reg_ID_EXE	x_Reg_ID_EXE(clk, id_wreg,id_m2reg,id_wmem,id_aluc,id_shift,id_aluimm, id_inA,id_inB,id_imm,id_destR,
					ex_wreg,ex_m2reg,	ex_wmem,ealuc,	eshift, ealuimm, edata_a,edata_b, odata_imm, e_destR,
					ID_ins_type, ID_ins_number, EXE_ins_type, EXE_ins_number);
					
	imm2sa x_imm2sa(odata_imm, sa);
	
	Alu x_Alu(a_in, b_in, ealuc, ex_zero, ex_aluR);
	
endmodule
