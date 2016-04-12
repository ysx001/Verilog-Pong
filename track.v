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
    output reg [3:0] first,
    output reg [3:0] second,
	 output SevenSegValue,
	 output DispSelect
    );

	always @(posedge score, posedge reset)
	if (reset) begin
		first <= 0;
		second <= 0;
	end
	else if(score) begin
		if(first == 4'd9) begin
			first <= 0;
			if(second == 4'd9)
				second <= 0;
			else
				second <= second + 1;
		end
		else
			first <= first + 1;
	end
	
seven_seg myscore(first, second, reset, SevenSegValue, DispSelect);

endmodule

