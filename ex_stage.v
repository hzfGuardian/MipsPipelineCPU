`timescale 1ns / 1ps

module ex_stage (clk,  id_imm, id_inA, id_inB, id_wreg, id_m2reg, id_wmem, id_aluc, id_aluimm,id_shift, id_branch, id_pc4,id_regrt,id_rt,id_rd,
	id_FWA, id_FWB,mem_aluR, wb_dest,//add for forwarding
	ex_wreg, ex_m2reg, ex_wmem, ex_aluR, ex_inB, ex_destR, ex_branch, ex_pc, ex_zero,
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
	input id_regrt;
	input[4:0] id_rt;
	input[4:0] id_rd;
	
	input [1:0]id_FWA, id_FWB;//add for forwarding
	input [31:0] mem_aluR, wb_dest;//add for forwarding
	
	input[3:0] ID_ins_type;
	input[3:0] ID_ins_number;
	output[3:0] EXE_ins_type;
	output[3:0] EXE_ins_number;
	
	input[31:0] id_pc4;
	input id_branch;
	output ex_branch;
	output ex_zero;
	output ex_wreg;
	output ex_m2reg;
	output ex_wmem;
	output[31:0] ex_aluR;
	output[31:0] ex_inB;
	output[31:0] ex_pc;
	output[4:0] ex_destR;
	
	wire [3:0] ealuc;
	wire ealuimm,eshift;
	wire [31:0] sa;
	wire [31:0] edata_a,edata_b,a_in,b_in,odata_imm;
	wire [31:0] ex_aluR;
	wire [31:0] epc4;
	wire e_regrt;
	wire [4:0]e_rt;
	wire [4:0]e_rd;
	
	wire [31:0] a_in_0, b_in_0;//add for forwarding
	
	assign a_in_0 = (id_FWA == 2'b00) ? edata_a : ((id_FWA == 2'b01) ? mem_aluR : wb_dest);
	
	assign a_in = eshift ? sa : a_in_0;
	
	assign b_in_0 = (id_FWB == 2'b00) ? edata_b : ((id_FWB == 2'b01) ? mem_aluR : wb_dest);//add for forwarding
	
	assign b_in = ealuimm ? odata_imm : b_in_0;
	assign ex_inB = b_in_0;//edata_b;
	assign ex_pc = epc4 + {odata_imm[29:0], 2'b0};//
	
	assign ex_destR = e_regrt? e_rt : e_rd;//
	
	Reg_ID_EXE	x_Reg_ID_EXE(clk, id_wreg,id_m2reg,id_wmem,id_aluc,id_shift,id_aluimm, id_inA,id_inB,id_imm,id_branch,id_pc4,id_regrt,id_rt,id_rd,
					ex_wreg,ex_m2reg,	ex_wmem,ealuc,	eshift, ealuimm, edata_a,edata_b, odata_imm, ex_branch, epc4,e_regrt,e_rt,e_rd,
					ID_ins_type, ID_ins_number, EXE_ins_type, EXE_ins_number);
					
	imm2sa x_imm2sa(odata_imm, sa);
	
	Alu x_Alu(a_in, b_in, ealuc, ex_zero, ex_aluR);
	
endmodule
