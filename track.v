`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:37:28 04/12/2016 
// Design Name: 
// Module Name:    track 
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
module track(
    input score,
	 input reset,
    input clk25,
    output reg [3:0] first,
    output reg [3:0] second,
	 output [7:0] SevenSegValue,
	 output [3:0] DispSelect,
	 output led

    );
	 

reg clean = 0;
parameter N = 19; // 2^19 / 50M ~ .01s
	reg [N:0] count;
	
	always @ (posedge clk25) begin
		// Run the counter if the current input is different than the 
		// previous one
		count <= (score != clean) ? count + 1 : 0;
		// Update the "clean" output value once the counter reaches the 
		// appropriate number
		clean <= (count[N] == 1) ? score : clean;
		end
assign led = clean;

seven_seg myscore(.clk25(clk25),.first(first), .second(second), .reset(reset), .segments(SevenSegValue), .digitselect(DispSelect));


	always @(posedge clk25)
	if(reset) begin
		first <= 0;
		second <= 0;
	end
	else if(clean) begin
		if(first == 4'd9)begin
			first <= 0;
			if(second == 4'd9)
				second <= 0;
			else
				second <= second + 1;
		end
		else
			first <= first + 1;
	end
endmodule

