
`include "macro.vh"

module ctrl_unit(clk, rst, if_instr, instr, id_rsrtequ,
	cu_branch, cu_wreg, cu_m2reg, cu_wmem, cu_aluc, cu_shift, cu_aluimm, cu_sext,cu_regrt, cu_wpcir, cu_fwda, cu_fwdb,
	cu_jump);
	
	input clk;
	input rst;
	input [31:0] instr;
	input [31:0] if_instr;
	
	input id_rsrtequ;
	
	output cu_branch;
	output cu_wreg;
	output cu_m2reg;
	output cu_wmem;
	output [3:0] cu_aluc;
	output cu_shift;
	output cu_aluimm;
	output cu_sext;
	output cu_regrt;
	
	output cu_wpcir;//add for stall
	//these for forwarding
	output wire [1:0] cu_fwda, cu_fwdb;
	
	//add for control logic
	output cu_jump;
	
	wire [5:0] func;
	wire [5:0] opcode;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	
	wire [5:0] if_func;
	wire [5:0] if_opcode;
	wire [4:0] if_rs;
	wire [4:0] if_rt;
	wire [4:0] if_rd; 
	
	wire [4:0] ex_rs;
	wire [4:0] ex_rt;
	wire [4:0] ex_rd;
	wire [4:0] mem_rt;
	wire [4:0] mem_rd;
	wire [4:0] wb_rd;
	wire [4:0] wb_rt;
	wire [5:0] ex_op;
	wire [5:0] mem_op;
	wire [5:0] wb_op;

	reg [31:0] ex_instr;
	reg [31:0] mem_instr;
	reg [31:0] wb_instr;
	reg [3:0] cu_aluc;
	
	//these for stall
	wire AfromEx, BfromEx, AfromMem, BfromMem, AfromExLW, BfromExLW, AfromMemLW, BfromMemLW;
	
	//output wire control_stall;
	wire	load_stall;
	
	assign opcode[5:0] =instr[31:26];////////////fetch new instr
	assign rs[4:0] = instr[25:21];
	assign rt[4:0] = instr[20:16];
	assign rd[4:0] = instr[15:11];
	assign func[5:0] = instr[5:0];
	
	assign if_opcode[5:0] =if_instr[31:26];
	assign if_rs[4:0] = if_instr[25:21];
	assign if_rt[4:0] = if_instr[20:16];
	assign if_rd[4:0] = if_instr[15:11];
	assign if_func[5:0] = if_instr[5:0];
	
	assign ex_rs[4:0] = ex_instr[25:21];
	assign ex_rt[4:0] = ex_instr[20:16];
	assign ex_rd[4:0] = ex_instr[15:11];
	assign mem_rt[4:0] = mem_instr[20:16];
	assign mem_rd[4:0] = mem_instr[15:11];
	assign wb_rd[4:0] = wb_instr[15:11];
	assign wb_rt[4:0] = wb_instr[20:16];
	assign ex_op[5:0] = ex_instr[31:26];
	assign mem_op[5:0] = mem_instr[31:26];
	assign wb_op[5:0] = wb_instr[31:26];
	
	assign cu_branch = ((opcode == `OP_BEQ) & id_rsrtequ) | ((opcode == `OP_BNE) & (~id_rsrtequ)) | cu_jump; //modified for branch control logic
	assign cu_regrt = ~(opcode == `OP_ALUOp); //if instr type = R type then 0 else 1;
	assign cu_sext = (opcode == `OP_BEQ)|(opcode == `OP_BNE)|(opcode == `OP_LW)|(opcode == `OP_SW)|(opcode==`OP_ADDI);//when need to sign extend?
	
	assign cu_wreg = (opcode==`OP_ALUOp)|(opcode==`OP_LW)|(opcode==`OP_ORI)|(opcode==`OP_ADDI)|(opcode==`OP_ANDI);//when need to write reg?
	assign cu_m2reg = (opcode == `OP_LW);//when need to write mem to reg??
	assign cu_wmem = (opcode == `OP_SW);//when need to enable write mem?
	assign cu_shift = ((opcode == `OP_ALUOp) && (func[5:2] == 4'b0))? 1 : 0;
	assign cu_aluimm = cu_regrt & ~cu_branch;
	
	//add for stall
	assign AfromEx = (ex_rs == mem_rd) & (ex_rs != 0) & (mem_op == `OP_ALUOp);
	assign BfromEx = (ex_rt == mem_rd) & (ex_rt != 0) & (mem_op == `OP_ALUOp);
	assign AfromMem = ((ex_rs == wb_rd) & (ex_rs != 0) & (wb_op == `OP_ALUOp))
						| ((ex_rs == wb_rt) & (ex_rs != 0) & (wb_op == `OP_LW));
	assign BfromMem = ((ex_rt == wb_rd) & (ex_rt != 0) & (wb_op == `OP_ALUOp))
						| ((ex_rt == wb_rt) & (ex_rt != 0) & (wb_op == `OP_LW));
	assign AfromExLW = (if_rs == rt) & (if_rs != 0) & (opcode == `OP_LW);
	assign BfromExLW = (if_rt == rt) & (if_rt != 0) & (opcode == `OP_LW);
	
	
	//assign control_stall = load_stall;//(opcode == `OP_BEQ) | (opcode == `OP_BNE)// | (ex_op == `OP_BEQ) | (ex_op == `OP_BNE)
			//| (opcode == `OP_JMP);// | (ex_op == `OP_JMP);
	assign load_stall = ((rt == if_rs) & (if_rs != 0) & (opcode == `OP_LW))
								| ((rt == if_rt) & (if_rt != 0) & (opcode == `OP_LW));
	
	
	assign cu_wpcir = load_stall;// | cu_branch;//modified

	
	assign cu_fwda[1:0] = (mem_op == `OP_LW && mem_rt == rs && rs != 0) ? 2'b11 : (
			(ex_op == `OP_ALUOp && ex_rd == rs && rs != 0) ? 2'b01 : (
				(mem_op == `OP_ALUOp && mem_rd == rs && rs != 0) ? 2'b10 : 2'b00
			)
		);
	
	assign cu_fwdb[1:0] = (mem_op == `OP_LW && mem_rt == rt && rt != 0) ? 2'b11 : (
			(ex_op == `OP_ALUOp && ex_rd == rt && rt != 0) ? 2'b01 : (
				(mem_op == `OP_ALUOp && mem_rd == rt && rt != 0) ? 2'b10 : 2'b00
			)
		);
	
	assign cu_jump = (opcode == `OP_JMP);
	
	always @ (posedge clk or posedge rst)
		if(rst == 1)
		begin
			wb_instr[31:0] <= 0;
			mem_instr[31:0] <= 0;
			ex_instr[31:0] <= 0;
		end
		else
		begin
			wb_instr[31:0] <= mem_instr[31:0];
			mem_instr[31:0] <= ex_instr[31:0];
			ex_instr[31:0] <= instr[31:0];
		end
	
	always @(opcode) begin
			case(opcode)
				`OP_BEQ: begin
					cu_aluc <= `ALU_SUB;////////////////////
				end
				`OP_ADDI: begin
					cu_aluc <= `ALU_ADD;
				end
				`OP_ANDI: begin
					cu_aluc <= `ALU_AND;
				end
				`OP_ORI: begin
					cu_aluc <= `ALU_OR;
				end
				`OP_ALUOp: begin
					case(func)
						`FUNC_ADD: begin
							cu_aluc <= `ALU_ADD;
						end
						`FUNC_SUB: begin
							cu_aluc <= `ALU_SUB;
						end
						`FUNC_AND: begin
							cu_aluc <= `ALU_AND;
						end
						`FUNC_OR: begin
							cu_aluc <= `ALU_OR;
						end
						`FUNC_NOR: begin
							cu_aluc <= `ALU_NOR;
						end
						`FUNC_SLT: begin
							cu_aluc <= `ALU_SLT;
						end
						`FUNC_SLL: begin
							cu_aluc <= `ALU_SLL;
						end
						`FUNC_SRL: begin
							cu_aluc <= `ALU_SRL;
						end
						`FUNC_SRA: begin
							cu_aluc <= `ALU_SRA;
						end
					endcase
				end
				default: begin
					cu_aluc <= `ALU_ADD;
				end
			endcase
		end
endmodule
