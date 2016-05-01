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
    output [9:0] vcount,
    output reg endofframe
    );

	reg [9:0] nextCount;
	reg [9:0] count = 0;
    initial endofframe = 0;

	always @ (*)
		if (count < 524)
			nextCount = count + 1;
		else
			nextCount = 0; // Reset when reach 524 lines
    
    assign next_endofframe = nextCount > 515 ? 1 : 0;
	
	// increment count when increment is 1 (end of horizontal counter in reached)
	always @ (posedge increment) begin
		count <= nextCount;
        endofframe <= next_endofframe;
    end

	// Outputs
	assign vcount = count;

	assign VS = (vcount < 2) ? 1 : 0; // Verical Sync Pulse is high when vcount is 0 or 1.

endmodule
