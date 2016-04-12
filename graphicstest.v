`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:11:45 04/07/2016 
// Design Name: 
// Module Name:    graphicstest 
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
module graphicstest(
    input clk50M,
    output [2:0] red,
    output [2:0] green,
    output [1:0] blue,
    output HS,
    output VS
    );

    wire [9:0] paddle_one_x;
    wire [9:0] paddle_one_y;
    wire [9:0] paddle_two_x;
    wire [9:0] paddle_two_y;
	 
	 wire [9:0] ball_x, ball_y;
	 assign paddle_one_x = 10'b0;
	 assign paddle_one_y = 10'b0;
	 assign paddle_two_x = 10'b0;
	 assign paddle_two_y = 10'b0;
	 
	 wire endofframe;
	 wire reset;
	 assign reset = 0;
     
	 graphics graphics_mod(clk50M, reset, ball_x, ball_y, paddle_one_x, paddle_one_y, paddle_two_x, paddle_two_y, 
	     red, green, blue, HS, VS, endofframe);
	
	ball_movement ball_mv(.endofframe( endofframe ), .paddle_one_x( paddle_one_x), 
		.paddle_one_y( paddle_one_y ), .paddle_two_x( paddle_two_x ), 
		.paddle_two_y( paddle_two_y ), .ball_x( ball_x ), .ball_y( ball_y ));
endmodule

