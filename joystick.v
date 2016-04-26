`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:32:34 04/19/2016 
// Design Name: 
// Module Name:    joystick 
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

module joystick_paddle_movement(
    input clk50M,
    input reset, endofframe, // Goes from LOW to HIGH when the VGA output leaves the display area
    // Connect to SPI hardware
    output cs,              // ~chipselect
    output mosi,            // MOSI - master out, slave in
    input miso,             // MISO - master in, slave out
    output sck,             // SCK - SPI clock
    // position output
    output reg [9:0] y
    );
    
    // Joystick interface
    wire ld1, ld2; // Joystick LED values
    assign ld1 = 1;
    assign ld2 = 1;
    wire [9:0] joystick_y; // Position of joystick
    
    real_joystick spi_joystick(.clk50M(clk50M), .LD1(ld1), .LD2(ld2), .y(joystick_y),
        .sck(sck), .mosi(mosi), .miso(miso), .cs(cs));
	 
     // Position update
     parameter down_fast_boundary = 10'h2d0;
     parameter down_slow_boundary = 10'h220;
     parameter up_slow_boundary = 10'h180;
     parameter up_fast_boundary = 10'h0a0;
     
     initial y = 10'd40;
     reg [9:0] next_y;
     always @ (*) begin
        if (y < 10 && joystick_y > down_slow_boundary)
            next_y = y;
        else if (y + 50 > 470 && joystick_y < up_slow_boundary)
            next_y = y;
        else if (joystick_y > down_fast_boundary)
            next_y = y - 3;
        else if (joystick_y > down_slow_boundary)
            next_y = y - 1;
        else if (joystick_y > up_slow_boundary)
            next_y = y;
        else if (joystick_y > up_fast_boundary)
            next_y = y + 1;
        else
            next_y = y + 3;
    end
    
    always @ (posedge endofframe or posedge reset)
        if (reset)
            y <= 0;
        else
            y <= next_y;
    
endmodule

// Theoretical, so it doesn't actually work.  real_joystick is good enough.
module theoretical_joystick(
    input clk50M,
    input LD1,
    input LD2,
    output [9:0] x,
    output [9:0] y,
    output [1:0] btn,
    // SPI
    output sck,
    input miso,
    output mosi,
    output cs
    );
    
    wire trigger;
    wire [39:0] out_bytes;
    assign out_bytes = {6'b100000, LD2, LD1, {32{1'b0}}};
    wire [39:0] in_bytes;
    
    spi spi_conn(clk50M, trigger, out_bytes, in_bytes, cs, mosi, miso, sck);
    
    // SPI clock
    reg enable = 1;
    wire spi_clk;
    wire spi_sck_dummy;
    spi_clk ctr_clk(clk50M, enable, spi_clk, spi_sck_dummy);
    
    reg [5:0] bit_ctr = 0;
    reg [5:0] next_bit_ctr;
    
    always @ (*) begin
        next_bit_ctr = bit_ctr[5]==1 ? 6'b0 : bit_ctr + 1;
    end
    
    always @ (posedge spi_clk)
        bit_ctr <= next_bit_ctr;
    
    assign trigger = bit_ctr[5];
    
    // Get x, y, button values
    assign x = {in_bytes[25:24], in_bytes[39:32]};
    assign y = {in_bytes[5:4], in_bytes[23:16]};
    assign btn = in_bytes[2:1];
endmodule
