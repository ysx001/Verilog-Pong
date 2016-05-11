`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:24:55 04/12/2016 
// Design Name: 
// Module Name:    sound 
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
module sound(
    input clk25,
	 input[1:0] point,
	 input[1:0] lose,
	 output speaker
	 );

reg [16:0] counter;
			
always @(posedge clk25)
	counter <= counter + 1;

assign speaker = (point != 2'b00) ? counter[16]:
			        (lose != 2'b00) ? counter[15]:
						0;
endmodule
