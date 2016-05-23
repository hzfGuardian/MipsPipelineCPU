`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:17:20 04/09/2016
// Design Name:   top
// Module Name:   C:/Users/huangzf/Desktop/Labs/PipelineCPU/test_top.v
// Project Name:  PipelineCPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_top;

	// Inputs
	reg CCLK;
	reg BTN3;
	reg BTN2;
	reg [3:0] SW;

	// Outputs
	wire LED;
	wire LCDE;
	wire LCDRS;
	wire LCDRW;
	wire [3:0] LCDDAT;
	wire [31:0] rpc;
	wire [7:0] rcnt;
	wire [31:0] rinst;
	wire [31:0] rreg;
	wire brh;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.CCLK(CCLK), 
		.BTN3(BTN3), 
		.BTN2(BTN2), 
		.SW(SW), 
		.LED(LED), 
		.LCDE(LCDE), 
		.LCDRS(LCDRS), 
		.LCDRW(LCDRW), 
		.LCDDAT(LCDDAT), 
		.rpc(rpc), 
		.rcnt(rcnt), 
		.rinst(rinst), 
		.rreg(rreg),
		.brh(brh)
	);

	initial begin
		// Initialize Inputs
		CCLK = 0;
		BTN3 = 0;
		BTN2 = 0;
		SW = 0;

		#100 SW = 1;
		#400 SW = 2;
		#100 SW = 4;
		#100 SW = 3;
		#200 SW = 4;
		#200 SW = 2;
		#5000 $finish;
	end
	
	initial	
		forever #5 CCLK = ~CCLK;
	
	initial
		forever #50 BTN3 = ~BTN3;
		
endmodule

