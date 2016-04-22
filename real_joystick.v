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
module real_joystick(
    input clk50M,
    input LD1,
    input LD2,
    output [9:0] y,
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
    wire sck_2;
    spi_clk ctr_clk(clk50M, enable, spi_clk, sck_2);
    
    parameter trig_N = 9;
    reg [trig_N-1:0] bit_ctr = 0;
    reg [trig_N-1:0] next_bit_ctr;
    
    always @ (*) begin
        next_bit_ctr = bit_ctr[trig_N-1]==1 ? 6'b0 : bit_ctr + 1;
    end
    
    always @ (posedge spi_clk)
        bit_ctr <= next_bit_ctr;
    
    assign trigger = bit_ctr[trig_N-1];
    
    // Get y value
    assign y = {in_bytes[6:5], in_bytes[20:13]};
endmodule
