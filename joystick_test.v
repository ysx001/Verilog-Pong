`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:18 04/19/2016 
// Design Name: 
// Module Name:    joystick_test 
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
module joystick_test(
    input clk50M,
    // Connect to SPI hardware
    output cs,              // ~chipselect
    output mosi,            // MOSI - master out, slave in
    input miso,             // MISO - master in, slave out
    output sck,             // SCK - SPI clock
    output [7:0] segments,
    output [3:0] anode,
	 output [4:0] leds
    );
    
    wire ld1, ld2;
    assign ld1 = 1;
    assign ld2 = 1;
    wire [9:0] y;
    
    real_joystick spi_joystick(.clk50M(clk50M), .LD1(ld1), .LD2(ld2), .y(y),
        .sck(sck), .mosi(mosi), .miso(miso), .cs(cs));
    
    //display4digit hexdisplay({{6{1'b0}}, {10{1'b1}}}, clk50M, segments, anode);
    
    display4digit hexdisplay({{6{1'b0}}, y}, clk50M, segments, anode);
	 
	 assign leds[0] = (y > 10'h02f0) ? 1 : 0;
	 assign leds[1] = (y < 10'h02f0 && y > 10'h0220) ? 1 : 0;
	 assign leds[2] = (y < 10'h0220 && y > 10'h0180) ? 1 : 0;
	 assign leds[3] = (y < 10'h0180 && y > 10'h00a0) ? 1 : 0;
	 assign leds[4] = (y < 10'h00a0) ? 1 : 0;
endmodule
