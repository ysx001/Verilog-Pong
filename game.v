// game.v
// Game logic and glue

/**************************** Game glue *****************************************/
module pong_game(
    input clk50M,
    // PMOD SPI - joystick 1
    output j1_cs,              // ~chipselect
    output j1_mosi,            // MOSI - master out, slave in
    input j1_miso,             // MISO - master in, slave out
    output j1_sck,             // SCK - SPI clock
    // PMOD SPI - joystick 2
    // PMOD - sound
    // 7 segment display
    // VGA
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
	assign paddle_one_x = 10'd300;
    //assign paddle_one_y = 10'd0;
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
    
    joystick_paddle_movement paddle_mv(.endofframe( endofframe ), .reset( reset ), .cs( j1_cs ), .mosi( j1_mosi ), 
        .miso( j1_miso ), .sck( j1_sck ), .y ( paddle_one_y ));
endmodule


/******************************* Paddles *************************************************/

`define PADDLE_WIDTH 5
`define PADDLE_LENGTH 50

module paddle_movement(
	input reset, endofframe, // Goes from LOW to HIGH when the VGA output leaves the display area
	input [1:0] btn,
	output reg [9:0] paddle_one_y
	);
	

	
	reg [9:0] paddle_one_y_next;
	wire [9:0] paddle_top, paddle_bottom;
	
	//paddle top and bottom
	assign paddle_top = paddle_one_y;
	assign paddle_bottom = paddle_one_y + `PADDLE_LENGTH - 1;
	
	
	always @ (posedge endofframe, posedge reset)
		if (reset) begin
			paddle_one_y <= 0;
		  end
		else
		  begin
			paddle_one_y <= paddle_one_y_next;
		  end
			
	
	// paddle movement
	
	always @ (*) begin

		paddle_one_y_next = paddle_one_y;

		if(endofframe) begin //when a frame has ended
	
			if (btn[1] & (paddle_bottom < 479 - 5)) // 479 is the lower boundary and 5 is the pixel displacement
				paddle_one_y_next = paddle_one_y + 5; 
			else if (btn[0] & (paddle_top > 5)) // bottom
				paddle_one_y_next = paddle_one_y - 5;
		end
	end

endmodule
	
	
	

module paddle_one_graphics(
		input reset,
		input [9:0] x, y, // the length of this reg depends on the length of the output of the VGA
		input [9:0] paddle_one_y, // button for controlling the paddle
		output [2:0] red, green, // outputs the rgb color value for the paddle
		output [1:0] blue,
		output paddle_on // Control signal for mux for vga ouput
		);

	// Define size for a paddle 

	localparam paddle_x = 600;
	
	wire [9:0] paddle_top, paddle_bottom;
    
	//paddle on or off
	assign paddle_top = paddle_one_y;
	assign paddle_bottom = paddle_one_y + `PADDLE_LENGTH - 1;

	assign paddle_on = (x >= paddle_x && x <= paddle_x + `PADDLE_WIDTH && 
					  y >= paddle_top && y <= paddle_bottom);
	
	
	// paddle color
	assign red = 3'b000;
	assign green = 3'b000; 
	assign blue = 2'b11; // blue

endmodule



`define BALL_SIZE 10


// Graphics module for the ball
module ball_graphics(
		input reset,
		input [9:0] x, y, // the length of this reg depends on the length of the output of the VGA
		input [9:0] ball_x, ball_y,
		output [2:0] red, green, // outputs the rgb color value for the ball
		output [1:0] blue,
		output ball_on // Control signal for mux for vga ouput
		);

	// Define a size for the ball
	wire [9:0] ball_left, ball_right, ball_top, ball_bottom;
	
	//ball on or off
	assign ball_left = ball_x;
	assign ball_top = ball_y;
	assign ball_right = ball_left + `BALL_SIZE - 1;
	assign ball_bottom = ball_top + `BALL_SIZE - 1;
	
	assign ball_on = (x >= ball_left && x <= ball_right && y >= ball_top && y <= ball_bottom);
	
	// ball color
	assign red = 3'b000;
	assign green = 3'b111; // green
	assign blue = 2'b00;

endmodule

// Movement module for the ball
module ball_movement(
	input reset, 
	input endofframe, // Goes from LOW to HIGH when the VGA output leaves the display area
	input [1:0] btn,
	input [9:0] paddle_one_x, paddle_one_y,
	input [9:0] paddle_two_x, paddle_two_y,
	output reg [9:0] ball_x, ball_y,
	output reg collided, missed
	);
	
	// collided is asserted when the ball hits the paddle
	// missed is asserted when the paddle miss the ball and the ball touches border
	
	// Define a size for the ball
	localparam ball_size = 10;
	wire [9:0] ball_left, ball_right, ball_top, ball_bottom;
	
	reg [9:0] ball_x_next, ball_y_next;
	
	reg [9:0] diff_x, diff_y; // difference in x and y -> for tracking x_vel and y_vel
	reg [9:0] diff_x_next, diff_y_next;
	
	wire [9:0] paddle_top, paddle_bottom;
	
	localparam paddle_length = 50;
	assign paddle_one_top = paddle_one_y;
	assign paddle_one_bottom = paddle_one_y + paddle_length - 1;
	
	always @ (posedge endofframe, posedge reset)
		if (reset) begin
			ball_x <= 0;
			ball_y <= 0;
			diff_x <= 0;
			diff_y <= 0;
		  end
		else
		  begin
			ball_x <= ball_x_next;
			ball_y <= ball_y_next;
			diff_x <= diff_x_next;
			diff_y <= diff_y_next;
		  end
	
	//ball on or off
	assign ball_left = ball_x;
	assign ball_top = ball_y;
	assign ball_right = ball_left + ball_size - 1;
	assign ball_bottom = ball_top + ball_size - 1;
	
	// ball movement
	
	always @ (*) begin //when a frame has ended
			ball_x_next = ball_x + diff_x;
			ball_y_next = ball_y + diff_y;
	end
	
	always @ (*) begin
	
		collided = 1'b0;
		missed = 1'b0;
		
		diff_x_next = diff_x;
		diff_y_next = diff_y;
	
		if (ball_top <= 3) // top
			diff_y_next = 1;
		else if (ball_bottom >= 477) // bottom
			diff_y_next = -1;
		else if (ball_left <= 30) // NOTE!! Arbitary number for left boundary
			diff_x_next = 1;
		else if (ball_right >= 600 && ball_bottom >= paddle_one_top && ball_top <= paddle_one_bottom) 
			begin
			diff_x_next = -1;
			collided = 1'b1;
			end
		else if (ball_right > 620)
			missed = 1'b1;
			diff_x_next = -ball_x;
			diff_y_next = -ball_y;
	end
endmodule
