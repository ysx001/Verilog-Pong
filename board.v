`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:40:06 04/12/2016 
// Design Name: 
// Module Name:    board 
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
module board_graphics(
    input [9:0] x, y,
    output board_on,
    output [2:0] r, g,
    output [1:0] b
    );

assign r=3'b110;
assign g=3'b110;
assign b=2'b11;

assign board_on =   y < 10 ? 1 : 
                    y > 470 ? 1 :
                    x > 315 && x < 325 && (y % 16) > 8 ? 1 :
                    0;

endmodule
