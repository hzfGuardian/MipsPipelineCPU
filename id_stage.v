`timescale 1ns / 1ps

`include "macro.vh"
module id_stage (clk, rst, if_inst, if_pc4, wb_destR, wb_dest,wb_wreg, 
	ex_aluR, mem_aluR, mem_mdata,//add for branch
	cu_wpcir,//add for stall
	ID_new_pc, //add for control
	cu_wreg, cu_m2reg, cu_wmem, cu_aluc, cu_shift, cu_aluimm, cu_branch, id_inA, id_inB, id_imm, id_destR, 
	IF_ins_type, IF_ins_number, ID_ins_type, ID_ins_number, which_reg, reg_content);
	
	input clk;
	input rst;
	input [31:0] if_inst;
	input [31:0] if_pc4;
	
	input [4:0] wb_destR;
	input [31:0] wb_dest;
	input wb_wreg;
	
	input[3:0] IF_ins_type;
	input[3:0]	IF_ins_number;
	
	input [4:0] which_reg;
	output [31:0] reg_content;
	
	output cu_branch;
	output cu_wreg;
	output cu_m2reg;
	output cu_wmem;
	output [3:0] cu_aluc;
	output cu_shift;
	output cu_aluimm;

	output [31:0] id_inA;
	output [31:0] id_inB;
	output [31:0] id_imm;
	//output cu_regrt;
	//output [4:0] rd;
	//output [4:0] rt;
	
	output[3:0] ID_ins_type;
	output[3:0] ID_ins_number;
	
	
	output cu_wpcir;//add for stall, it means load stall !
	
	wire [1:0] cu_fwda, cu_fwdb;//add for forwarding---------------------------------
	
	wire cu_jump;//add for branch

	wire cu_jr;//add for 31 mips
	
	wire stall;
	
	input [31:0] ex_aluR, mem_aluR, mem_mdata;//add for branch
	output [31:0] ID_new_pc;
	
	wire cu_sext;
	wire cu_regrt;
	wire cu_branch;
	
	reg [31:0] reg_inst;
	reg [31:0] pc4;
	
	wire [31:0] rdata_A;
	wire [31:0] rdata_B;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [15:0] imm;
	wire [31:0] id_imm;
	
	reg[3:0] ID_ins_type;
	reg[3:0] ID_ins_number;
	
	output [4:0] id_destR;
	
	//add for branch
	wire [31:0] jmp_in_0, jmp_in_1;
	
	wire id_rsrtequ;
	
	wire control_stall;
	
	wire cu_jal;
	
	//add for 31 mips
	wire [31:0] id_inA_0, id_inA_1, id_inB_0, id_inB_1;
	wire [31:0] jpc_0;
	
	//add for JAL hazard
	wire cu_fwdja, cu_fwdjb;
	
	assign jmp_in_0 = pc4 + {(imm[15] ? {14'b1, imm} : {14'b0, imm}), 2'b00};
	assign jmp_in_1 = {pc4[31:28], reg_inst[25:0], 2'b00};
	assign jpc_0 = (cu_jump | cu_jal) ? jmp_in_1 : jmp_in_0;
	
	assign id_rsrtequ = (id_inA_0 == id_inB_0) ? 1 : 0;
	
	assign imm = reg_inst[15:0];
	assign rt= reg_inst[20:16];
	assign rd = reg_inst[15:11];
	assign id_imm = cu_sext?( imm[15]?{16'b1,imm}:{16'b0,imm}):{16'b0,imm};
	
	//add for 31 mips
	assign ID_new_pc = cu_jr ? id_inA_0 : jpc_0;
	
	always @ (posedge clk or posedge rst)
		if (rst==1)
		begin
			reg_inst <= 0;
			pc4 <= 0;
			ID_ins_type <= 0;
			ID_ins_number <= 0;
			
		end
		
		else if (cu_wpcir == 1 || cu_branch == 1) // load stall or branch stall
		begin
			reg_inst <= 0;
			pc4 <= pc4;
			ID_ins_type <= `INST_TYPE_NONE;
			ID_ins_number <= ID_ins_number;
		end
		
		else
		begin
			reg_inst <= if_inst;
			pc4 <= if_pc4; //
			
			ID_ins_type <= IF_ins_type;
			ID_ins_number <= IF_ins_number;			
			
		end
	
	regfile x_regfile(clk, rst, reg_inst[25:21], reg_inst[20:16], wb_destR, wb_dest, wb_wreg, rdata_A, rdata_B,
		which_reg, reg_content);
		
	ctrl_unit x_ctrl_unit(clk, rst, if_inst[31:0], reg_inst[31:0], id_rsrtequ, 
		cu_branch, cu_wreg, cu_m2reg, cu_wmem, cu_aluc, cu_shift, cu_aluimm, cu_sext,cu_regrt, cu_wpcir, cu_fwda, cu_fwdb, 
		cu_jump, cu_jr, cu_jal, cu_fwdja, cu_fwdjb
	);
	
	//add for jal
	assign id_inA = (cu_fwdja) ? ex_aluR : (cu_jal ? pc4 : id_inA_0);
	assign id_inB = (cu_fwdjb) ? ex_aluR : (cu_jal ? 0 : id_inB_0);
	
	assign id_destR = cu_jal ? 5'b11111 : (cu_regrt ? rd : rt);

	mux4_1 mua(rdata_A, ex_aluR, mem_aluR, mem_mdata, cu_fwda, id_inA_0);
	mux4_1 mub(rdata_B, ex_aluR, mem_aluR, mem_mdata, cu_fwdb, id_inB_0);
	
	
endmodule


