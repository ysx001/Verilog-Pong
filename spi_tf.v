`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:47:36 04/21/2016
// Design Name:   spi
// Module Name:   H:/Users/tww014/Documents/GitHub/Verilog-Pong/spi_tf.v
// Project Name:  Verilog-Pong
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module spi_tf;

	// Inputs
	reg clk;
	reg trigger;
	reg [39:0] out_bytes;
	reg miso;

	// Outputs
	wire [39:0] in_bytes;
	wire cs;
	wire mosi;
	wire sck;
    
    // Trigger counter
    reg [8:0] trig_cnt = 10'b100_000_000;

	// Instantiate the Unit Under Test (UUT)
	spi uut (
		.clk(clk), 
		.trigger(trigger), 
		.out_bytes(out_bytes), 
		.in_bytes(in_bytes), 
		.cs(cs), 
		.mosi(mosi), 
		.miso(miso), 
		.sck(sck)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		trigger = 0;
		out_bytes = 0;
		miso = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	end
	
	always begin
        clk = 1; #1; clk = 0; #1;
    end
    
    always @ (negedge sck)
        miso <= ~miso;
    
    always @ (negedge clk)
        if (trig_cnt[8] == 1) begin
            trig_cnt <= 0;
            trigger <= 0;
        end else begin
            trig_cnt <= trig_cnt + 1;
            trigger <= (trig_cnt < 3'b101) ? 1 : 0;
        end
endmodule

