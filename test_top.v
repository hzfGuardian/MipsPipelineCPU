`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:26:48 06/15/2016
// Design Name:   top
// Module Name:   C:/Users/huangzf/Desktop/MipsPipelineCPU/test_top.v
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
	wire [255:0] strdata;
	//wire [31:0] aa, bb, alr;

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
		.strdata(strdata)
	);

	initial begin
		// Initialize Inputs
		CCLK = 0;
		BTN3 = 0;
		BTN2 = 0;
		SW = 0;
		
		#20 BTN2 = 1;
		#20 BTN2 = 0;
		
		SW = 9;
		// Wait 100 ns for global reset to finish
		#6000 $finish;
        
		// Add stimulus here

	end
	
	initial 
		forever #1 CCLK = ~CCLK;
	
	initial 
		forever #50 BTN3 = ~BTN3;
      
endmodule

