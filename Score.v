`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:44:47 04/12/2016 
// Design Name: 
// Module Name:    score display 
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


module seven_seg(input clk25,
					input [3:0] first,
					input [3:0] second, // from other modules, if socred then let this be one.
					input reset,
					output [7:0] segments,
					output reg [3:0] digitselect
				);


	reg [18:0] counter = 0;
	reg [3:0] A;
	wire [1:0] toptwo;
	
	always @(posedge clk25)
		counter <= counter + 1;
	assign toptwo[1:0] = counter[18:17];	

	always @(*)
	
		case(toptwo)
			2'b00 : 
			begin
				digitselect = ~4'b0001;
				A = first;
		   end
			2'b01 : 
			begin
				digitselect = ~4'b0010;
				A = second;
			end
			2'b10 :
			begin
				digitselect = ~4'b0100;
				A = 2'b00;
			end
			2'b11 :
			begin
				digitselect = ~4'b1000;
				A = 2'b00;
			end
		endcase
		
HexTo7Seg myencoder(A, segments);
endmodule

module HexTo7Seg(
    input [3:0] A,
//    output reg [3:0] DispSelect = ~(4'b0001),
    output reg [7:0] SevenSegValue
    );
	
	always @(*)
		case(A)			
			4'd0 : SevenSegValue = ~8'b11111100;  // Note inversion
			4'd1 : SevenSegValue = ~8'b01100000;
			4'd2 : SevenSegValue = ~8'b11011010;
			4'd3 : SevenSegValue = ~8'b11110010;
			4'd4 : SevenSegValue = ~8'b01100110;
			4'd5 : SevenSegValue = ~8'b10110110;
			4'd6 : SevenSegValue = ~8'b10111110;
			4'd7 : SevenSegValue = ~8'b11100000;
			4'd8 : SevenSegValue = ~8'b11111110;
			4'd9 : SevenSegValue = ~8'b11110110;
			default : SevenSegValue = ~ 8'b10001110;
		endcase
endmodule

