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
module gamecontrol(
    input clk, reset, endofframe
    input collided, missed,
    output restart, 
    
    
    );
    
    // State declaration
    localparam [1:0] start = 2'b00;
    localparam [1:0] game = 2'b01;
    localparam [1:0] ball_refill = 2'b10;
    localparam [1:0] end = 2'b11;
    
    reg [1:0] state, state_next;
    reg ball, ball_next;
    reg restart;
    
    
    
    always @ (posedge clk, posedge reset)
    begin
      if (reset)
        begin
          state <= start;
          ball <= 0;
          rgb <= 0;
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
    case (state)
      start:
        begin
          ball_next = 2b'11;
          score_clr = 1'b1;
          if (btn != 2'b00)
            begin
              state_next = game;
              ball_next = ball - 1;
            end
      game:
        begin
          restart = 1'b0;
          if (collided)
            score_inc = 1'b1;
          else if (missed)
            begin 
              if (ball == 0)
                state_next = end;
              else
                state_next = ball_refill;
              timer_begin = 1'b1;
              ball_next = ball - 1;
            end
      ball_refill:
        if (timer_end && (btn != 2'b11))
          state_next = game;
      
      end:
        if (timer_end)
          state_next = start;
    endcase
  end
  
  
  wire timer_begin, timer_end, timer_tick;
  
  reg [6:0] timer, timer_next;
  
  assign timer_tick = ((x == 0) && (y == 0));
  
  always @ (posedge clk, posedge reset)
    if (reset)
      timer <= 7'b1111111;
    else
      timer <= timer_next;
  
  always @ (*)
  begin
    if (timer_begin)
      timer_next = 7'b1111111;
    else if (timer_tick && timer != 0)
      timer_next = timer - 1;
    else
      timer_next = timer;
  
  assign timer_end = (timer == 0)
        
          
endmodule

