`timescale 1ns / 1ps

module regfile(
    clk,//clock
	 rst,//reset
    i_adr1,//register index 1
    i_adr2,//register index 2
    i_wreg,//register to write
	 i_wdata,//data to write
    i_wen,//write enable
    o_op1,//read data1, out
    o_op2,//read data2, out
	 i_adr3,//register index 3
    o_op3//read data3, out
);
                             
	 input clk;
	 input rst;                
	 input [4:0] i_adr1; 
	 input [4:0] i_adr2;
	 input [4:0] i_adr3;
	 input [31:0] i_wdata;
	 input i_wen;
	 input [4:0] i_wreg;
	 
	 output [31:0] o_op1;
	 output [31:0] o_op2;
	 output [31:0] o_op3;
	 reg [31:0] mem[31:0];
	 
		assign o_op1 = mem[i_adr1];
		assign o_op2 = mem[i_adr2];
		assign o_op3 = mem[i_adr3];
		
	 always @(negedge clk or posedge rst) begin
		if (rst == 1) begin
			mem[0] <= {32{1'b0}};mem[1] <= {32{1'b0}};mem[2] <= {32{1'b0}};mem[3] <= {32{1'b0}};
			mem[4] <= {32{1'b0}};mem[5] <= {32{1'b0}};mem[6] <= {32{1'b0}};mem[7] <= {32{1'b0}};
			mem[8] <= {32{1'b0}};mem[9] <= {32{1'b0}};mem[10] <= {32{1'b0}};mem[11] <= {32{1'b0}};
			mem[12] <= {32{1'b0}};mem[13] <= {32{1'b0}};mem[14] <= {32{1'b0}};mem[15] <= {32{1'b0}};
			mem[16] <= {32{1'b0}};mem[17] <= {32{1'b0}};mem[18] <= {32{1'b0}};mem[19] <= {32{1'b0}};
			mem[20] <= {32{1'b0}};mem[21] <= {32{1'b0}};mem[22] <= {32{1'b0}};mem[23] <= {32{1'b0}};
			mem[24] <= {32{1'b0}};mem[25] <= {32{1'b0}};mem[26] <= {32{1'b0}};mem[27] <= {32{1'b0}};
			mem[28] <= {32{1'b0}};mem[29] <= {32{1'b0}};mem[30] <= {32{1'b0}};mem[31] <= {32{1'b0}};
		end
		else if (i_wen) begin
			mem[i_wreg] <= (i_wreg == 5'b00000) ? 32'h00000000 : i_wdata;
		end
	 end
endmodule
