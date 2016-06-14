`timescale 1ns / 1ps


module top(input wire CCLK, BTN3, BTN2, input wire [3:0]SW, 
	output wire LED, LCDE, LCDRS, LCDRW, output wire [3:0]LCDDAT);

	wire [31:0] if_npc;
	wire [31:0] if_pc4;
	wire [31:0] if_inst;
	
	//wire [31:0] id_pc4;	
	wire [31:0] id_inA;
	wire [31:0] id_inB;
	wire [31:0] id_imm;
	wire [4:0] id_destR;
	wire id_regrt;//modified
	wire [4:0] id_rt;
	wire [4:0] id_rd;
	wire id_branch; 
	wire id_wreg;
	wire id_m2reg;
	wire id_wmem;
	wire [3:0] id_aluc;
	wire id_shift;
	wire id_aluimm;
	
	wire ex_wreg;
	wire ex_m2reg;
	wire ex_wmem;
	wire[31:0] ex_aluR;
	wire[31:0] ex_inB;
	wire[4:0] ex_destR;

	wire[31:0]ex_pc;
	
	wire mem_wreg;
	wire mem_m2reg;
	wire[31:0] mem_mdata;
	wire[31:0] mem_aluR;
	wire[4:0] mem_destR;
	//wire mem_branch;
	wire[31:0] mem_pc;
	
	wire wb_wreg;
	wire[4:0] wb_destR;
	wire[31:0] wb_dest;
	
	wire [3:0] IF_ins_type; 
	wire [3:0] IF_ins_number;
	wire [3:0] ID_ins_type;
	wire [3:0] ID_ins_number;
	wire [3:0] EX_ins_type; 
	wire [3:0] EX_ins_number;
	wire [3:0] MEM_ins_type; 
	wire [3:0] MEM_ins_number;
	wire [3:0] WB_ins_type; 
	wire [3:0] WB_ins_number;
	wire [3:0] OUT_ins_type; 
	wire [3:0] OUT_ins_number;
	
	wire [31:0] pc;
	wire [31:0] reg_content;
	wire [3:0] which_reg;
	
	reg [255:0] strdata;
	reg [3:0] SW_old;
	reg [7:0] clk_cnt;
	reg cls;

	wire [3:0] lcdd;
	wire rslcd, rwlcd, elcd;
	wire clk_1ms;
	
	wire btn_out2, btn_out3;
	
	wire id_wpcir; //add for stall
	
	wire [1:0] id_FWA, id_FWB;//add for forwarding
	
	wire [31:0] id_jpc;
	
	assign LCDDAT[3]=lcdd[3];
	assign LCDDAT[2]=lcdd[2];
	assign LCDDAT[1]=lcdd[1];
	assign LCDDAT[0]=lcdd[0];
	
	assign LCDRS=rslcd;
	assign LCDRW=rwlcd;
	assign LCDE=elcd;
	
	assign LED=BTN3;
	assign which_reg[3:0] = SW[3:0];

	initial begin
		strdata <= "01234567 00 0123f01d01e01m01w01 ";
		SW_old = 4'b0;
		clk_cnt <= 8'b0;
		cls <= 1'b0;
	end
	
	display M0 (CCLK, cls, strdata, rslcd, rwlcd, elcd, lcdd);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
	
	function [7:0] ByteToChar;
		input [3:0] hex_byte;
		begin 
			if (hex_byte >= 0 && hex_byte <= 9)
				ByteToChar = 8'h30 + hex_byte[3:0];
			else
				ByteToChar = 8'h41 + hex_byte[3:0] - 10;
		end 
	endfunction

	always @(posedge CCLK) begin
		if ((btn_out3 == 1'b1) || (btn_out2 == 1'b1)) begin
			//first line 8 4-bit Instrution
			strdata[255:248] <= ByteToChar(if_inst[31:28]);
			strdata[247:240] <= ByteToChar(if_inst[27:24]);
			strdata[239:232] <= ByteToChar(if_inst[23:20]);
			strdata[231:224] <= ByteToChar(if_inst[19:16]);
			strdata[223:216] <= ByteToChar(if_inst[15:12]);
			strdata[215:208] <= ByteToChar(if_inst[11:8]);
			strdata[207:200] <= ByteToChar(if_inst[7:4]);
			strdata[199:192] <= ByteToChar(if_inst[3:0]);
			//space
			//strdata[191:184] = " ";
			//2 4-bit CLK
			strdata[183:176] <= ByteToChar(clk_cnt[7:4]);
			strdata[175:168] <= ByteToChar(clk_cnt[3:0]);
			//space
			//strdata[167:160] = " ";

			//second line
			//strdata[127:120] = "f";
			strdata[119:112] <= ByteToChar(ex_aluR[7:4]);
			strdata[111:104] <= ByteToChar(ex_aluR[3:0]);
			//strdata[103:96] = "d";
			strdata[95:88] <= ByteToChar({3'b0, wb_destR[4]});
			strdata[87:80] <= ByteToChar(wb_destR[3:0]);
			//strdata[79:72] = "e";
			strdata[71:64] <= ByteToChar(mem_mdata[7:4]);
			strdata[63:56] <= ByteToChar(mem_mdata[3:0]);
			//strdata[55:48] = "m";
			strdata[47:40] <= ByteToChar(id_inA[7:4]);
			strdata[39:32] <= ByteToChar(id_inA[3:0]);
			//strdata[31:24] = "w";
			strdata[23:16] <= ByteToChar(id_inB[7:4]);//
			strdata[15:8] <= ByteToChar(id_inB[3:0]);
		end
		if((btn_out3 == 1'b1) || (btn_out2 == 1'b1)||(SW_old != SW)) begin
			//first line after CLK and space
			strdata[159:152] <= ByteToChar(reg_content[15:12]);
			strdata[151:144] <= ByteToChar(reg_content[11:8]);
			strdata[143:136] <= ByteToChar(reg_content[7:4]);
			strdata[135:128] <= ByteToChar(reg_content[3:0]);
			SW_old <= SW;
			cls <= 1;
		end
		else
			cls <= 0;
	end
	
	always @(posedge btn_out3 or posedge btn_out2) begin
		if (btn_out2 == 1'b1) begin
			clk_cnt = 0;
		end
		else begin
			clk_cnt = clk_cnt + 1;
		end
	end

	assign pc [31:0] = if_npc[31:0];

	if_stage x_if_stage(btn_out3, btn_out2, pc, id_jpc, id_branch, id_wpcir, 
	  if_npc, if_pc4, if_inst, IF_ins_type, IF_ins_number,ID_ins_type,ID_ins_number);

	id_stage x_id_stage(btn_out3, btn_out2, if_inst, if_pc4, wb_destR, wb_dest,wb_wreg, 
		ex_aluR, mem_aluR, mem_mdata, //add for branch
		id_wpcir, //add for stall
		id_jpc, //add for branch
		id_wreg, id_m2reg, id_wmem, id_aluc, id_shift, id_aluimm, id_branch, id_inA, id_inB, id_imm, id_destR, 
		ID_ins_type, ID_ins_number, EX_ins_type, EX_ins_number, {1'b1,which_reg}, reg_content);
		
	ex_stage x_ex_stage(btn_out3, id_imm, id_inA, id_inB, id_wreg, id_m2reg, id_wmem, id_aluc, id_aluimm,id_shift,  
		id_destR,
		ex_wreg, ex_m2reg, ex_wmem, ex_aluR, ex_inB, ex_destR, 
		EX_ins_type, EX_ins_number, MEM_ins_type, MEM_ins_number);
	  
	mem_stage x_mem_stage(btn_out3, ex_destR, ex_inB, ex_aluR, ex_wreg, ex_m2reg, ex_wmem,   
	  mem_wreg, mem_m2reg, mem_mdata, mem_aluR, mem_destR,  
	  MEM_ins_type, MEM_ins_number, WB_ins_type, WB_ins_number);

	wb_stage x_wb_stage(btn_out3, mem_destR, mem_aluR, mem_mdata, mem_wreg, mem_m2reg, 
	  wb_wreg, wb_dest, wb_destR, WB_ins_type, WB_ins_number,OUT_ins_type, OUT_ins_number);
	
	pbdebounce pb0(CCLK, BTN2, btn_out2);
	pbdebounce pb1(CCLK, BTN3, btn_out3);
	
	
endmodule
