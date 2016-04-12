`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:51:40 03/29/2016 
// Design Name: 
// Module Name:    debouncer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: none
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module debouncer(
    input raw,
    input clk,
    output reg clean = 0
    );
	
	parameter N = 19; // 2^19 / 50M ~ .01s
	reg [N:0] count;
	
	always @ (posedge clk) begin
		// Run the counter if the current input is different than the 
		// previous one
		count <= (raw != clean) ? count + 1 : 0;
		// Update the "clean" output value once the counter reaches the 
		// appropriate number
		clean <= (count[N] == 1) ? raw : clean;
	end

endmodule
