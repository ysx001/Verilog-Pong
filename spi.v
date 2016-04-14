`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:40:12 04/14/2016 
// Design Name: 
// Module Name:    spi 
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
module spi(
    input [39:0] out_bytes,
    output [39:0] in_bytes,
    output cs,
    output mosi,
    input miso,
    output sck
    );

    

endmodule

// SPI clock must be something below 1MHz
module spi_clk(
    input clk50M,
    output clk
    );
    
    parameter N = 6;
    
    reg [N-1:0] next_ctr;
    reg [N-1:0] ctr;
    
    always @ (*)
        next_ctr <= ctr + 1;
       
    always @ (posedge clk50M)
        ctr <= next_ctr;
    
    assign clk = ctr[N-1];

endmodule
