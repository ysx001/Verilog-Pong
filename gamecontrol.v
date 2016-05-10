`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:11:45 04/25/2016 
// Design Name: 
// Module Name:   gamecontrol
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
module fsm(
    input clk, reset, endofframe,
    input [1:0] collided, missed,
	 input isMoving,
	 output reg score_clr,
    output reg restart
    );
    
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
  
  always @ (posedge clk, posedge reset)
    if (reset)
      timer <= 7'b1111111;
    else
      timer <= timer_next;
  
  always @ (*)
  begin
    if (timer_begin)
      timer_next = 7'b1111111;
    else if (timer != 0)
      timer_next = timer - 1;
    else
      timer_next = timer;
  end
  
  assign timer_end = (timer == 0);
    
  always @ (posedge clk, posedge reset)
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
    restart = 1'b1;
	 score_clr = 1'b0;
	 state_next = state;
	 ball_next = ball;
    case (state)
      start:
		 begin

          ball_next = 2'b11;
          score_clr = 1'b1;
          if (isMoving)
            begin
              state_next = game;
              ball_next = ball - 1;
            end
			end
      game:
        begin
          restart = 1'b0;
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

