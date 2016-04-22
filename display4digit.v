`timescale 1ns / 1ps
// Code to test stuff - copied from a lab
//

module display4digit(
    input [15:0] A,
    input clk,
    output [7:0] segments,
    output reg [3:0] digitselect
    );

	reg [18:0] counter = 0;
	wire [1:0] toptwo;
	reg [3:0] value4bit;
	
	always @(posedge clk)
		counter <= counter + 1;
	
	assign toptwo[1:0] = counter[18:17];
	
	always @ (*)
		case(toptwo)
			2'b00: digitselect = ~ 4'b0001;  // Note inversion
			2'b01: digitselect = ~ 4'b0010;
			2'b10: digitselect = ~ 4'b0100;
			default: digitselect = ~ 4'b1000;
		endcase

	always @ (*)
		case (toptwo)
			2'b00: value4bit = A[3:0];
			2'b01: value4bit = A[7:4];
			2'b10: value4bit = A[11:8];
			default: value4bit = A[15:12];
		endcase
	
	HexTo7Seg myhexencoder(value4bit, segments);

endmodule


module HexTo7Seg(
    input [3:0] A,
    output reg [7:0] SevenSegValue
    );

	always @ (*)
		case(A)
			4'h0: SevenSegValue = ~ 8'b11111100;  // Note inversion
			4'h1: SevenSegValue = ~ 8'b01100000;
			4'h2: SevenSegValue = ~ 8'b11011010;
			4'h3: SevenSegValue = ~ 8'b11110010;
			4'h4: SevenSegValue = ~ 8'b01100110;
			4'h5: SevenSegValue = ~ 8'b10110110;
			4'h6: SevenSegValue = ~ 8'b10111110;
			4'h7: SevenSegValue = ~ 8'b11100000;
			4'h8: SevenSegValue = ~ 8'b11111110;
			4'h9: SevenSegValue = ~ 8'b11110110;
			4'hA: SevenSegValue = ~ 8'b11101110;
			4'hB: SevenSegValue = ~ 8'b00111110;
			4'hC: SevenSegValue = ~ 8'b10011100;
			4'hD: SevenSegValue = ~ 8'b01111010;
			4'hE: SevenSegValue = ~ 8'b10011110;
			default: SevenSegValue = ~ 8'b10001110;
		endcase

endmodule
