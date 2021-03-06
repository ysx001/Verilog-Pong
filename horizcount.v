`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:09:04 04/05/2016 
// Design Name: 
// Module Name:    horizcount 
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
module horizcount(
    input clk25M,
    output HS,
    output [9:0] hcount,
    output reg termcount
    );

parameter numPixels = 799; // Value of pixels in a horizonal line = 799

reg [9:0] nextCount;
reg [9:0] count = 0;
reg nextTermCount;

always @ (*) begin
	if (count < 799)
		nextCount = count + 1; 
	else
		nextCount = 0; // counter has reached the end of pixel count - reset the counter
	nextTermCount = (nextCount >= 799) ? 1 : 0; // Enable the vertical counter when hcount >= 799
end

always @ (posedge clk25M) begin
	count <= nextCount;
	termcount <= nextTermCount;
end

// Output
assign hcount = count;

assign HS = (count < 96) ? 1 : 0; // Horizontal Sync Pulse is high when count is 0-95

endmodule
