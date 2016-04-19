`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:09:04 04/16/2016
// Design Name:   spi_clk
// Module Name:   U:/private/ECEG240-project/Verilog-Pong/spi_clk_tf.v
// Project Name:  Verilog-Pong
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_clk
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spi_clk_tf;

	// Inputs
	reg clk50M;
	reg enable;

	// Outputs
	wire clk;
	wire sck;

	// Instantiate the Unit Under Test (UUT)
	spi_clk uut (
		.clk50M(clk50M), 
		.enable(enable), 
		.clk(clk), 
		.sck(sck)
	);
    
    integer i=0;
    
	initial begin
		// Initialize Inputs
		clk50M = 0;
		enable = 0;
        
		// Add stimulus here
        for(i=0; i<50; i = i+1) begin
            #1 clk50M=1; #1 clk50M=0;
        end
        #1 enable = 1;
        for(i=0; i<60; i = i+1) begin
            #1 clk50M=1; #1 clk50M=0;
        end
        enable = 0;
        for(i=0; i<50; i = i+1) begin
            #1 clk50M=1; #1 clk50M=0;
        end

	end
      
endmodule

