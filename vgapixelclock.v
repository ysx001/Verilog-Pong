`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:44 04/05/2016 
// Design Name: 
// Module Name:    vgapixelclock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Divide the 50MHz clock to 25MHz for the VGA pixel clock
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vgapixelclock(
    input clk50M, reset
    output reg clk25M
    );

initial clk25M = 0;

wire nextClk;

assign nextClk = ~clk25M;

always @ (posedge clk50M, posedge reset)
	if (reset)
	  begin
		clk25M <= 0;
	  end
	else
	  begin
		clk25M <= nextClk;
	  end

endmodule
