`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:27:29 04/16/2016
// Design Name:   spi_input
// Module Name:   U:/private/ECEG240-project/Verilog-Pong/spi_input_tf.v
// Project Name:  Verilog-Pong
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_input
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spi_input_tf;

	// Inputs
	reg sclk;
	reg miso;

	// Outputs
	wire [39:0] in_bytes;

	// Instantiate the Unit Under Test (UUT)
	spi_input uut (
		.sclk(sclk), 
		.in_bytes(in_bytes), 
		.miso(miso)
	);

	initial begin
		// Initialize Inputs
		sclk = 0;
		miso = 0;
        
        #100;
        
		// Add stimulus here
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 0; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
        #10 sclk = 0; miso = 1; #10 sclk = 1;
	end
      
endmodule

