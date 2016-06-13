`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:49:40 06/13/2016
// Design Name:   Alu
// Module Name:   C:/Users/huangzf/Desktop/MipsPipelineCPU/test_alu.v
// Project Name:  PipelineCPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_alu;

	// Inputs
	reg [31:0] i_r;
	reg [31:0] i_s;
	reg [3:0] i_aluc;

	// Outputs
	wire o_zf;
	wire [31:0] o_alu;

	// Instantiate the Unit Under Test (UUT)
	Alu uut (
		.i_r(i_r), 
		.i_s(i_s), 
		.i_aluc(i_aluc), 
		.o_zf(o_zf), 
		.o_alu(o_alu)
	);

	initial begin
		// Initialize Inputs
		i_r = 4;
		i_s = 32'hf000_0000;
		i_aluc = 4'b1111;

		// Wait 100 ns for global reset to finish
		#100;
		
		i_r = 4;
		i_s = 32'hff00_0000;
		i_aluc = 4'b1101;

		// Wait 100 ns for global reset to finish
		#100;
      
		i_r = 4;
		i_s = 32'hff00_0000;
		i_aluc = 4'b1100;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		$finish;
	end
      
endmodule

