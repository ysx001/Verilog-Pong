`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:11:45 04/07/2016 
// Design Name: 
// Module Name:    graphicstest 
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
module graphicstest(
    input clk50M,
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
	 
	 wire [9:0] ball_x;
	 assign ball_x = 10'd200;
	 reg [9:0] ball_y = 10'd10;
	 reg ball_direction = 1;
	 assign paddle_one_x = 10'b0;
	 assign paddle_one_y = 10'b0;
	 assign paddle_two_x = 10'b0;
	 assign paddle_two_y = 10'b0;
	 
	 reg [9:0] ball_y_next;
	 reg ball_direction_next;
	 wire slowclk;
     
	 always @ (*) begin
	     if (ball_direction == 1) begin
            ball_y_next = ball_y + 1;
            ball_direction_next = ball_y_next > 400 ? 0 : 1;
         end
         else begin
            ball_y_next = ball_y - 1;
            ball_direction_next = ball_y_next < 1 ? 1 : 0;
         end
     end
     
     always @ (posedge slowclk) begin
         ball_y <= ball_y_next;
         ball_direction <= ball_direction_next;
     end
	 
     ball_clkdiv clkdiv(clk50M, slowclk);
     
	 graphics graphics_mod(clk50M, ball_x, ball_y, paddle_one_x, paddle_one_y, paddle_two_x, paddle_two_y, 
	     red, green, blue, HS, VS);
endmodule

module ball_clkdiv(
    input clk50M, 
    output slowclk);
    
    parameter FACTOR = 19;
    
    reg [FACTOR-1:0] counter = {FACTOR{1'b0}};
    
    always @ (posedge clk50M)
        counter <= counter + 1;
    
    assign slowclk = counter[FACTOR-1];

endmodule
