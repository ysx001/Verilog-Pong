`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:12 04/06/2016 
// Design Name: 
// Module Name:    drawboard 
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
module drawboard(
    input [9:0] xpixel,
    input [9:0] ypixel,
	input [9:0] ball_x,
    input [9:0] ball_y,
    input [9:0] paddle_one_x,
    input [9:0] paddle_one_y,
    input [9:0] paddle_two_x,
    input [9:0] paddle_two_y,
    output [2:0] red,
    output [2:0] green,
    output [1:0] blue
    );
	 
	 assign red = (xpixel > ball_x && xpixel < (ball_x + 10) && 
						ypixel > ball_y && ypixel < (ball_y + 10)) ? 3'b111 :
						xpixel < 50 ? 3'b111 : 3'b001;
	 assign green = (xpixel > ball_x && xpixel < (ball_x + 10) && 
						ypixel > ball_y && ypixel < (ball_y + 10)) ? 3'b111 : 
						xpixel < 100 ? 3'b111 : 3'b100;
	 assign blue = (xpixel > ball_x && xpixel < (ball_x + 10) && 
						ypixel > ball_y && ypixel < (ball_y + 10)) ? 2'b11 : 
						ypixel < 100 ? 2'b11 :
						ypixel < 200 ? 2'b10 :
						ypixel < 300 ? 2'b01 :
						2'b00;

endmodule