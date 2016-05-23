
`include "macro.vh"
module Alu(i_r,i_s,i_aluc,o_zf,o_alu);
	input [31:0] i_r;		//i_r: r input
	input [31:0] i_s;		//i_s: s input
	input [3:0] i_aluc;		//i_aluc: ctrl input
	output o_zf;			//o_zf: zero flag output
	output [31:0] o_alu;		//o_alu: alu result output
	
	reg o_zf;
	reg [31:0] o_alu;
	
	always @(i_aluc or i_r or i_s) begin
		case (i_aluc)
			`ALU_AND: begin
				o_zf = 0;
				o_alu = i_r & i_s;
			end
			`ALU_OR: begin
				o_zf = 0;
				o_alu = i_r | i_s;
			end
			`ALU_ADD: begin
				o_zf = 0;
				o_alu = i_r + i_s;
			end
			`ALU_SUB: begin
				o_alu = i_r - i_s;
				o_zf  = (o_alu == 0);
			end
			`ALU_SLT: begin
				o_zf = 0;
			  if (i_s < i_r)
				  o_alu = 1;
				else
				  o_alu = 0;
			end
			`ALU_NOR: begin
				o_zf = 0;
				o_alu = ~(i_r | i_s);
			end
			default: begin
				o_alu = 0;
				o_zf = 0;
			end
		endcase
	end
endmodule
