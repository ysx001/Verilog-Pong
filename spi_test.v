`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:50:01 04/14/2016 
// Design Name: 
// Module Name:    spi_test 
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
module spi_test(
    input clk,
    // Connect to SPI hardware
    output cs,              // ~chipselect
    output mosi,            // MOSI - master out, slave in
    input miso,             // MISO - master in, slave out
    output sck              // SCK - SPI clock
    );
    
    reg trigger = 0;
    reg [39:0] out_bytes = 40'b0;
    wire [39:0] in_bytes;
    
    spi spi_joystick(clk, trigger, out_bytes, in_bytes, cs, mosi, miso, sck);

endmodule
