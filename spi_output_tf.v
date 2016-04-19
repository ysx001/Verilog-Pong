`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:40:47 04/16/2016
// Design Name:   spi_output
// Module Name:   H:/Users/tww014/Documents/GitHub/Verilog-Pong/spi_output_tf.v
// Project Name:  Verilog-Pong
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_output
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spi_output_tf;

	// Inputs
	reg sclk;
	reg [39:0] out_bytes;

	// Outputs
	wire mosi;

	// Instantiate the Unit Under Test (UUT)
	spi_output uut (
		.sclk(sclk), 
		.out_bytes(out_bytes), 
		.mosi(mosi)
	);
    
    integer i;
    
	initial begin
		// Initialize Inputs
		sclk = 0;
		out_bytes = 40'b1000_1011_1001_1011_1010_1011_1100_1011_1110_1011;
        
		// Add stimulus here
        sclk=1; #1; sclk=0; #1;
        
        for(i=0; i<42; i=i+1) begin
            sclk=1; #1; sclk=0; #1;
        end
	end
      
endmodule

