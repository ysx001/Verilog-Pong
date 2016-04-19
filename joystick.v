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
module joystick(
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
    
    spi spi_joystick(clk50M, trigger, out_bytes, in_bytes, cs, mosi, miso, sck);
    
    // SPI clock
    reg enable = 1;
    wire spi_clk;
    wire spi_sck_dummy;
    spi_clk ctr_clk(clk50M, enable, spi_clk, sck_2);
    
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
    assign y = {in_bytes[9:8], in_bytes[23:16]};
    assign btn = in_bytes[2:1];
endmodule
