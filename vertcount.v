`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:19:05 04/05/2016 
// Design Name: 
// Module Name:    vertcount 
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
module vertcount(
    input increment,
    output VS,
    output [9:0] vcount
    );

	reg [9:0] nextCount;
	reg [9:0] count = 0;

	always @ (*)
		if (count < 524)
			nextCount = count + 1;
		else
			nextCount = 0;

	always @ (posedge increment)
		count <= nextCount;

	// Outputs
	assign vcount = count;

	assign VS = (vcount < 2) ? 1 : 0;

endmodule
