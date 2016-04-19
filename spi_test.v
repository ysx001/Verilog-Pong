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
    input clk50M,
    // Connect to SPI hardware
    output cs,              // ~chipselect
    output mosi,            // MOSI - master out, slave in
    input miso,             // MISO - master in, slave out
    output sck,             // SCK - SPI clock
    output [7:0] segments,
    output [3:0] anode
    );
    
    wire trigger;
    reg [39:0] out_bytes = 40'b10000011_00000000_00000000_00000000_00000000;
    wire [39:0] in_bytes;
    
    spi spi_joystick(clk50M, trigger, out_bytes, in_bytes, cs, mosi, miso, sck);
    
    // SPI clock
    reg enable = 1;
    wire spi_clk;
    wire sck_2;
    spi_clk ctr_clk(clk50M, enable, spi_clk, sck_2);
    
    reg [5:0] bit_ctr = 0;
    reg [5:0] next_bit_ctr;
    
    always @ (*) begin
        next_bit_ctr = bit_ctr[5]==1 ? 6'b0 : bit_ctr + 1;
    end
    
    always @ (posedge spi_clk)
        bit_ctr <= next_bit_ctr;
    
    assign trigger = bit_ctr[5];
    
    
    display4digit hexdisplay(in_bytes[15:0], clk50M, segments, anode);
endmodule

module joystick_test(
    input clk50M,
    // Connect to SPI hardware
    output cs,              // ~chipselect
    output mosi,            // MOSI - master out, slave in
    input miso,             // MISO - master in, slave out
    output sck,             // SCK - SPI clock
    output [7:0] segments,
    output [3:0] anode
    );
    
    wire ld1, ld2;
    assign ld1 = 1;
    assign ld2 = 1;
    wire [9:0] x, y;
    wire [1:0] btn;
    
    joystick spi_joystick(.clk50M(clk50M), .LD1(ld1), .LD2(ld2), .x(x), .y(y), .btn(btn),
        .sck(sck), .mosi(mosi), .miso(miso), .cs(cs));
    
    display4digit hexdisplay({{6{1'b0}}, x}, clk50M, segments, anode);
endmodule