`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:30:23 04/09/2016 
// Design Name: 
// Module Name:    imm2sa 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module imm2sa(odata_imm,sa);
	input[31:0] odata_imm;
	output[31:0] sa;
	
	assign sa = {27'b0,odata_imm[10:6]};
	
endmodule
