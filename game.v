// game.v
// Game logic and glue

`define PADDLE_WIDTH 5
`define PADDLE_LENGTH 50
`define PADDLE_ONE_X 10'd30
`define PADDLE_TWO_X 10'd600

/**************************** Game glue *****************************************/
module pong_game(
    input clk50M,
    // PMOD SPI - joystick 1
    output j1_cs,              // ~chipselect
    output j1_mosi,            // MOSI - master out, slave in
    input j1_miso,             // MISO - master in, slave out
    output j1_sck,             // SCK - SPI clock
    // PMOD SPI - joystick 2
    output j2_cs,
    output j2_mosi,
    input j2_miso,
    output j2_sck,
    // PMOD - sound
    output speaker,
    // 7 segment display
    output [7:0] seven_value,
    output [3:0] disp_select,
    // VGA
    output [2:0] red,
    output [2:0] green,
    output [1:0] blue,
    output HS,
    output VS, 
	 // Debug
	 output reg restart,
	 output isMoving,
	 output [1:0] collided
	 );
    
    wire [9:0] paddle_one_x;
    wire [9:0] paddle_one_y;
    wire [9:0] paddle_two_x;
    wire [9:0] paddle_two_y;
	 
	wire [9:0] ball_x, ball_y;
	assign paddle_one_x = `PADDLE_ONE_X;
	assign paddle_two_x = `PADDLE_TWO_X;
	
	wire endofframe;
    wire endofframe_2;
	wire reset;
	assign reset = 0;
	
	wire isMoving_0, isMoving_1;
	//wire restart;
	wire [1:0] missed;
	wire score_clr;
    
    shift_delay eof_delay(clk50M, endofframe, endofframe_2);
    
    graphics graphics_mod(clk50M, reset, ball_x, ball_y, paddle_one_y, paddle_two_y, 
	    red, green, blue, HS, VS, endofframe);
		
	ball_movement ball_mv( .endofframe( endofframe_2 ), .restart(restart), .paddle_one_x( paddle_one_x), 
		.paddle_one_y( paddle_one_y ), .paddle_two_x( paddle_two_x ), 
		.paddle_two_y( paddle_two_y ), .ball_x( ball_x ), .ball_y( ball_y ), .collided( collided ), .missed( missed ));
    
    
    joystick_paddle_movement paddle_mv_1(.clk50M( clk50M ), .endofframe( endofframe ), .reset( reset ), 
        .cs( j1_cs ), .mosi( j1_mosi ), .miso( j1_miso ), .sck( j1_sck ), .y ( paddle_one_y ), .isMoving(isMoving_0));
    
    joystick_paddle_movement paddle_mv_2(.clk50M( clk50M ), .endofframe( endofframe ), .reset( reset ), 
        .cs( j2_cs ), .mosi( j2_mosi ), .miso( j2_miso ), .sck( j2_sck ), .y ( paddle_two_y ), .isMoving(isMoving_1));
	
	 assign isMoving = isMoving_1 | isMoving_0;

    debounce_test score_disp(.clk(clk50M), .reset(reset), .btn(collided),  .seven_value(seven_value), .disp_select(disp_select));
    
//	 fsm game_fsm( .clk(clk50M), .endofframe(endofframe), .collided(collided), .missed(missed), .isMoving(isMoving), .score_clr(score_clr), 
//    .restart (restart) );

	wire point, lose;
	assign point = collided[0] | collided[1];
	assign lose = missed[0] | missed[1];

	 sound note(.clk25(clk50M), .point(collided), .lose(missed), .speaker(speaker)); 

// ============================================ FSM =============================================

    // State declaration
    localparam [1:0] start = 2'b00;
    localparam [1:0] game = 2'b01;
    localparam [1:0] ball_refill = 2'b10;
    localparam [1:0] end_game = 2'b11;
    
    reg [1:0] state, state_next;
    reg ball, ball_next;
	 
	 reg timer_begin;
	 wire timer_end;
  
  reg [6:0] timer, timer_next;
  
  always @ (posedge clk50M, posedge reset)
    if (reset)
      timer <= 7'b1111111;
    else
      timer <= timer_next;
  
  always @ (*)
  begin
    if (timer_begin)
      timer_next = 7'b1111111;
    else if ((endofframe) && (timer != 0))
      timer_next = timer - 1;
    else
      timer_next = timer;
  end
  
  assign timer_end = (timer == 0);
    
  always @ (posedge clk50M, posedge reset)
    begin
      if (reset)
        begin
          state <= start;
          ball <= 0;
		 end
      else
        begin
          state <= state_next;
          ball <= ball_next;
        end
    end
    
  always @ (*)
  begin
    //restart = 1'b0;
	 //score_clr = 1'b0;
	 state_next = state;
	 ball_next = ball;
    case (state)
      start:
		 begin
          ball_next = 2'b11;
          //score_clr = 1'b1;
          if (isMoving)
            begin
              state_next = game;
              ball_next = ball - 1;
            end
			end
      game:
        begin
          //restart = 1'b0;
          if (missed != 2'b00)
            begin 
              if (ball == 0)
                state_next = end_game;
              else
                state_next = ball_refill;
              timer_begin = 1'b1;
              ball_next = ball - 1;
            end
			end
      ball_refill:
			begin
        if (timer_end && (isMoving))
          state_next = game;
			end
      end_game:
			begin
        if (timer_end)
          state_next = start;
			 end
    endcase
  end
  
endmodule


module shift_delay(
    input clk50M,
    input signal,
    output reg signal_delayed);
    
    reg next_signal_delayed;
    
    always @ (posedge clk50M) begin
        next_signal_delayed <= signal;
        signal_delayed <= next_signal_delayed;
    end

endmodule


/******************************* Paddles *************************************************/
module paddle_graphics #(parameter x_val=5)(
		input reset,
		input [9:0] x, y, // the length of this reg depends on the length of the output of the VGA
		input [9:0] paddle_one_y, // button for controlling the paddle
		output [2:0] red, green, // outputs the rgb color value for the paddle
		output [1:0] blue,
		output paddle_on // Control signal for mux for vga ouput
		);

	// Define size for a paddle 
	
	wire [9:0] paddle_top, paddle_bottom;
    
	//paddle on or off
	assign paddle_top = paddle_one_y;
	assign paddle_bottom = paddle_one_y + `PADDLE_LENGTH - 1;

	assign paddle_on = (x >= x_val && x <= x_val + `PADDLE_WIDTH && 
					  y >= paddle_top && y <= paddle_bottom);
	
	
	// paddle color
	assign red = 3'b000;
	assign green = 3'b000; 
	assign blue = 2'b11; // blue

endmodule

/********************* Ball ****************************/

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
	input restart,
	input [1:0] btn,
	input [9:0] paddle_one_x, paddle_one_y,
	input [9:0] paddle_two_x, paddle_two_y,
	output reg [9:0] ball_x, ball_y,
	output reg [1:0] collided, missed
	);
	
    initial ball_x = 10'd50;
    initial ball_y = 10'd50;
    
	// collided is asserted when the ball hits the paddle
	// missed is asserted when the paddle miss the ball and the ball touches border
    
	// Define a size for the ball
	localparam ball_size = 10;
	wire [9:0] ball_left, ball_right, ball_top, ball_bottom;
	
	wire [9:0] ball_x_next, ball_y_next;
	
	reg [9:0] diff_x, diff_y; // difference in x and y -> for tracking x_vel and y_vel
	initial diff_x = 1;
   initial diff_y = 1;
    reg [9:0] diff_x_next, diff_y_next;
	
	localparam paddle_length = 50;
    wire [9:0] paddle_one_top, paddle_one_bottom;
	assign paddle_one_top = paddle_one_y;
	assign paddle_one_bottom = paddle_one_y + paddle_length - 1;
    
    wire [9:0] paddle_two_top, paddle_two_bottom;
	assign paddle_two_top = paddle_two_y;
	assign paddle_two_bottom = paddle_two_y + paddle_length - 1;
	
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

	 //Set the ball to the center if restart else change position when a frame has ended
	assign ball_x_next = (restart) ? 320 : (endofframe) ? ball_x + 2*diff_x : ball_x;
	assign ball_y_next = (restart) ? 240 : (endofframe) ? ball_y + 2*diff_y : ball_y;
	
	always @ (*) begin
	
		collided = 1'b0;
		missed = 1'b0;
		
		diff_x_next = diff_x;
		diff_y_next = diff_y;
	
		if (ball_top <= 10) // top
			diff_y_next = 2;
		else if (ball_bottom >= 470) // bottom
			diff_y_next = -2; 
        else if (ball_left <= `PADDLE_ONE_X && (ball_bottom >= paddle_one_top //Left Paddle
            && ball_top <= paddle_one_bottom)) begin
			diff_x_next = 2;
            collided[0] = 1'b1;
        end 
		else if (ball_right >= `PADDLE_TWO_X && (ball_bottom >= paddle_two_top // Right Paddle
                && ball_top <= paddle_two_bottom)) begin
			diff_x_next = -2;
			collided[1] = 1'b1;
			end
        else if (ball_left <= 2) begin
            diff_x_next = 2;
            missed[0] = 1'b1;
        end
		else if (ball_right > 630) begin
			missed[1] = 1'b1;
			diff_x_next = -2;
        end
	end
endmodule
