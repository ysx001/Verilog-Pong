module game(
		input clk25M, reset, vga_on;
		input [9:0] x, y; // the length of this reg depends on the length of the output of the VGA
		output [2:0] rgb; // outputs the rgb color value for the ball
		)	

	
	
	// Define a size for the ball
	localparam ball_size = 10;
	wire [9:0] ball_left, ball_right, ball_top, ball_bottom;
	
	reg [9:0] ball_x, ball_y;
	wire [9:0] ball_x_next, ball_y_next;
	
	reg [9:0] diff_x, diff_y; // difference in x and y -> for tracking x_vel and y_vel
	reg [9:0] diff_x_next, diff_y_next; // 
	
	
	reg ball_dirX, ball_dirY; //1=right&up, 0=left&down
	reg bounceX, bounceY; //1=right&up, 0=left&down

	wire endofframe = (x == 0 && y == 481); //depends on how the video is being scanned
	// end of frame when raster reach the beginning of last line
	
	
	always @ (posedge clk25M, posedge reset)
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
			
	
	
	// ball movement
	
	assign ball_left = ballX;
	always @(posedge clk) begin

		if(endofframe) //when a frame has ended
			if(ballX==0 & ballY==0) //check if the game is resetted or not
				ballX <= 240; //if reset, then move ball to intial x-pos 240
				ballY <= 320; //if reset, then move ball to intial y-pos 320

			else begin //if not reset
				if(ball_dirX | bounceX) //if the direction of the ball or the bouncing direction of the ball is to the right
					ballX <= ballX + 1; //add 2 units to the ball's x-pos (move to the right)
				else //if the direction of the ball or the bouncing direction of the ball is to the left
					ballX <= ballX - 1; //subtract 2 units from the ball's x-pos (move to the left)
				if(ball_dirY | bounceY) //same for the y direction.
					ballY <= ballY + 1;
				else
					ballY <= ballY - 1
			end
