module ball(
		input clk25M, reset,
		input [9:0] x, y, // the length of this reg depends on the length of the output of the VGA
		output [2:0] ball_on, rgb // outputs the rgb color value for the ball
		);

	// Define a size for the ball
	localparam ball_size = 10;
	wire [9:0] ball_left, ball_right, ball_top, ball_bottom;
	
	reg [9:0] ball_x, ball_y;
	wire [9:0] ball_x_next, ball_y_next;
	
	reg [9:0] diff_x, diff_y; // difference in x and y -> for tracking x_vel and y_vel
	reg [9:0] diff_x_next, diff_y_next; // 
	
	
	reg ball_dirX, ball_dirY; //1=right&up, 0=left&down
	//reg bounceX, bounceY; //1=right&up, 0=left&down

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
			
	
	
	
	//ball on or off
	assign ball_left = ball_x;
	assign ball_top = ball_y;
	assign ball_right = ball_left + ball_size - 1;
	assign ball_bottom = ball_top + ball_size - 1;
	
	assign ball_on = (x >= ball_left && x <= ball_right && y >= ball_top && y <= ball_bottom);
	//I think the following can also do this:
	//assign ball_on = (x > 30 && x < 600 && y > 0 && y < 480)
	// ball movement
	
	if(endofframe) //when a frame has ended
			ball_x_next = ball_x + diff_x;
			ball_y_next = ball_y + diff_y;
	
	always @ (*) begin
	
		diff_x_next = diff_x;
		diff_y_next = diff_y;
	
		if (ball_top <= 3) // top
			diff_y_next = 1;
		else if (ball_bottom >= 477) // bottom
			diff_y_next = -1;
		else if (ball_left <= 30) // NOTE!! Arbitary number for left boundary
			diff_x_next = 1;
		else if (ball_right >= 600) // NOTE!! Arbitary number for right boundary -> change into the position of bar later
			diff_x_next = -1;
	end
	
	// ball color
	assign rbg = 3'b010 // green

endmodule

