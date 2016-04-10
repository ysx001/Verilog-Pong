`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:27:02 04/05/2016 
// Design Name: 
// Module Name:    graphics 
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
module graphics(
    input clk50M,
	 input [9:0] ball_x,
    input [9:0] ball_y,
    input [9:0] paddle_one_x,
    input [9:0] paddle_one_y,
    input [9:0] paddle_two_x,
    input [9:0] paddle_two_y,
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [1:0] blue,
    output HS,
    output VS
    );

	/*************************** Timing ***********************************/
	wire clk25M;
	wire termcount;

	wire [9:0] horizcount;
	wire [9:0] vertcount;
	
	vgapixelclock pixclk( .clk50M( clk50M ), .clk25M( clk25M ) );
	horizcount hcount( .clk25M( clk25M ), .HS( HS ), .hcount( horizcount ), .termcount( termcount ));
	vertcount vcount( .increment( termcount ), .VS( VS ), .vcount( vertcount ));

	/*************************** Drawing Code *************************************/
   wire [9:0] xpixel, ypixel;
	assign xpixel = horizcount - 144;
	assign ypixel = vertcount - 35;
	wire [2:0] draw_red;
	wire [2:0] draw_green;
	wire [1:0] draw_blue;
	
	drawboard drawing( .xpixel( xpixel ), .ypixel( ypixel ), .ball_x( ball_x ), .ball_y( ball_y ), 
		.paddle_one_x( paddle_one_x ), .paddle_one_y( paddle_one_y ), .paddle_two_x( paddle_two_x ), 
		.paddle_two_y( paddle_two_y ), .red( draw_red ), .green( draw_green ), .blue( draw_blue ));
	
	/*************************** Pixels ************************************/
	// Pixel values are buffered in registers for one clock cycle to avoid timing problems
	reg [2:0] next_red;
	reg [2:0] next_green;
	reg [1:0] next_blue;
	
	always @ (posedge clk25M) begin
		red <= next_red;
		green <= next_green;
		blue <= next_blue;
	end
	
	// Horizontal back porch = 144 (128+16)
	// Horizontal front portch - 784 (128+16+640)
	// Vertical back porch = 35 (6+29)
	// Vertical front porch = 515 (6+29+480)
	
	// Output colors when within the porches
	
	always @ (*) begin
		if (horizcount < 144 || horizcount >= 784 || vertcount < 35 || vertcount >= 515) begin
			next_red = 3'b000;
			next_green = 3'b000;
			next_blue = 2'b00;
		end
		else begin
			next_red = draw_red;
			next_green = draw_green;
			next_blue = draw_blue;
		end
	end

endmodule
