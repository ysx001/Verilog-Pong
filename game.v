module game(
		input [9:0] X // the length of this reg depends on the length of the output of the VGA
		input [9:0] Y // the length of this reg depends on the length of the output of the VGA
		output //?? ALARM!!!!!!!  reserved
		)	

//part: the movent of the ball
	reg [9:0] ballX; //the x-pos of the ball
	reg [9:0] ballY; //the y-pos of the ball
	reg ball_dirX, ball_dirY; //1=right&up, 0=left&down
	reg bounceX, bounceY; //1=right&up, 0=left&down

	wire endofframe = (??) //depends on how the video is being scanned

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
	end