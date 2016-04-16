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
	 input point,
	 input lose,
	 output speaker
	 );

reg [16:0] counter;
reg [3:0] win;

always @(posedge clk25)
	if (win == 9) begin
		win <= 0;
		end
	else
		if (point)
			win <= win + 1;
			
always @(posedge clk25)
	counter <= counter + 1;

assign speaker = (point && ~win[2]) ? counter[16]:
			        (lose) ? counter[15]:
					  (win[2] ) ? counter[14]:
						0;

endmodule
