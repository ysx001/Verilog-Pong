module paddle(
		input clk25M, reset,
		input [9:0] x, y, // the length of this reg depends on the length of the output of the VGA
		input [1:0] btn; // button for controlling the paddle
		output [2:0] red, green, // outputs the rgb color value for the ball
		output [1:0] blue,
		output paddle_on // Control signal for mux for vga ouput
		);

	// Define size for a paddle 

	localparam paddle_width = 5;
	localparam paddle_length = 50;
	localparam paddle_x = 600;
	
	wire [9:0] paddle_top, paddle_bottom;
	reg [9:0] paddle_y, paddle_y_next;
		

	wire endofframe = (x == 0 && y == 481); //depends on how the video is being scanned
	// end of frame when raster reach the beginning of last line
	
	
	always @ (posedge clk25M, posedge reset)
		if (reset) begin
			paddle_y <= 0;
		  end
		else
		  begin
			paddle_y <= paddle_y_next;
		  end
			
	
	//ball on or off
	assign paddle_top = paddle_y;
	assign paddle_bottom = paddle_y + paddle_length - 1;
	

	assign ball_on = (x >= paddle_x && x <= paddle_x + paddle_width && 
					  y >= paddle_top && y <= paddle_bottom);
	
	
	// ball movement
	
	
	
	always @ (*) begin

		paddle_y_next = paddle_y;

		if(endofframe) begin //when a frame has ended
	
			if (btn[1] & (paddle_bottom < 479 - 5)) // 479 is the lower boundary and 5 is the pixel displacement
				paddle_y_next = paddle_y + 5; 
			else if (btn[0] & (paddle_top > 5)) // bottom
				paddle_y_next = paddle_y - 5;
		end
	end
	
	// ball color
	assign red = 3'b000;
	assign green = 3'b000; 
	assign blue = 2'b11; // blue

endmodule

