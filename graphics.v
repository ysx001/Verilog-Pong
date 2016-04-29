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
    input clk50M, reset,
    input [9:0] ball_x,
    input [9:0] ball_y,
    input [9:0] paddle_one_y,
    input [9:0] paddle_two_y,
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [1:0] blue,
    output HS,
    output VS,
	output endofframe
    );

	/*************************** Timing ***********************************/
	wire clk25M;
	wire termcount;

	wire [9:0] horizcount;
	wire [9:0] vertcount;
	
	vgapixelclock pixclk( .clk50M( clk50M ), .clk25M( clk25M ) );
	horizcount hcount( .clk25M( clk25M ), .HS( HS ), .hcount( horizcount ), .termcount( termcount ));
	vertcount vcount( .increment( termcount ), .VS( VS ), .vcount( vertcount ), .endofframe( endofframe ));

	/*************************** Drawing Code *************************************/
    wire [9:0] xpixel, ypixel;
	assign xpixel = horizcount - 144;
	assign ypixel = vertcount - 35;
	
    // ball graphics
	wire [2:0] ball_red;
	wire [2:0] ball_green;
	wire [1:0] ball_blue;
	wire ball_on;
	ball_graphics drawball( .reset( reset), .x( xpixel ), .y( ypixel ), .ball_x( ball_x ), .ball_y( ball_y ),
		.red( ball_red ), .green( ball_green ), .blue( ball_blue ), .ball_on( ball_on ));
	
    // board graphics
    wire [2:0] board_red, board_green;
    wire [1:0] board_blue;
    wire board_on;
	board_graphics drawboard(.x( xpixel ), .y( ypixel ), .board_on( board_on ), 
        .r( board_red ), .g( board_green ), .b( board_blue ));
    
    // paddle graphics
    wire [2:0] p1_red, p1_green;
    wire [1:0] p1_blue;
    wire p1_on;
    paddle_graphics #(5) p1_draw(.x(xpixel), .y(ypixel), .paddle_one_y(paddle_one_y), 
        .red(p1_red), .green(p1_green), .blue(p1_blue), .paddle_on(p1_on));
    wire [2:0] p2_red, p2_green;
    wire [1:0] p2_blue;
    wire p2_on;
    paddle_graphics #(600) p2_draw(.x(xpixel), .y(ypixel), .paddle_one_y(paddle_two_y), 
        .red(p2_red), .green(p2_green), .blue(p2_blue), .paddle_on(p2_on));
	
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
	// Vertical back porch = 35 (2+33)
	// Vertical front porch = 515 (2+33+480)
	
	// Output colors when within the porches
	
	
	always @ (*) begin
		// Output black while outside of range of display
		if (horizcount < 144 || horizcount >= 784 || vertcount < 35 || vertcount >= 515) begin
			next_red = 3'b000;
			next_green = 3'b000;
			next_blue = 2'b00;
		end
		else begin
			if (ball_on) begin
				next_red = ball_red;
				next_green = ball_green;
				next_blue = ball_blue;
			end
            else if (board_on) begin // board should stay second to last
                next_red = board_red;
                next_green = board_green;
                next_blue = board_blue;
            end
            else if (p1_on) begin
                next_red = p1_red;
                next_green = p1_green;
                next_blue = p1_blue;
            end
            else if (p2_on) begin
                next_red = p2_red;
                next_green = p2_green;
                next_blue = p2_blue;
            end
			else begin
				next_red = 3'b001;
				next_green = 3'b000;
				next_blue = 2'b01;
			end
		end
	end

endmodule
