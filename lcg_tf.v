`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:20:08 04/28/2016
// Design Name:   lcg
// Module Name:   C:/Users/tww014/Documents/GitHub/Verilog-Pong/lcg_tf.v
// Project Name:  Verilog-Pong
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lcg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lcg_tf;

	// Inputs
	reg clk50M;

	// Outputs
	wire [31:0] rand;

	// Instantiate the Unit Under Test (UUT)
	lcg uut (
		.clk50M(clk50M), 
		.rand(rand)
	);

	initial begin
		// Initialize Inputs
		clk50M = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
    
    always
        #1 clk50M = ~clk50M;
endmodule

