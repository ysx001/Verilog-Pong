`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:37:28 04/12/2016 
// Design Name: 
// Module Name:    track 
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
module debounce_test(
    input wire clk_50M, reset,
    input wire [1:0] btn,
    output [7:0] seven_value,
    output [3:0] disp_select,
    );
	reg [7:0] btn_1, btn_0;
	wire [7:0] btn_1_next, btn_0_next;
	wire db_clk_1, db_clk_0;
	
	debounce dp_btn_0 (.raw(btn[0]), .clk(clk), .reset(reset), .db_clk(db_clk_0), .q());
	debounce dp_btn_1 (.raw(btn[1]), .clk(clk), .reset(reset), .db_clk(db_clk_1), .q());
	
	sseg_hex btn_disp(.clk(clk), .reset(reset), .first_1(btn_0[7:4]), .first_0(btn_0[3:0]), .second_1(btn_1[7:4]),\
			.second_0(btn_1[3:0]), .disp_select(disp_select), .seven_value(seven_value))
			
	always @ (posedge clk) begin
		btn_1 = btn_1_next;
		btn_0 = btn_0_next;
	end
  
	assign btn_1_next = (db_clk_1) ? btn_1 + 1 : btn_1;
	assign btn_0_next = (db_clk_0) ? btn_0 + 1 : btn_0;
  
endmodule

module sseg_hex (input clk, reset,
		input [3:0] first_1, first_0, second_1, second_0,
		output reg [3:0] disp_select.
		output reg [7:0] seven_value,
		);
	
	
	reg [18:0] counter, counter_next;
	reg [3:0] A;
	wire [1:0] toptwo;
	
	always @ (posedge clk25, posedge reset)
		if (reset)
			counter <= 0;
		else
			counter <= counter_next;
	
	assign counter_next = counter + 1;
	assign toptwo[1:0] = counter[18:17];	
	
	always @(*)
	
		case(toptwo)
			2'b00 : 
			begin
				disp_select = ~4'b0001;
				A = first_0;
		   end
			2'b01 : 
			begin
				disp_select = ~4'b0010;
				A = first_1;
			end
			2'b10 :
			begin
				disp_select = ~4'b0100;
				A = second_0;
			end
			2'b11 :
			begin
				disp_select = ~4'b1000;
				A = second_1;
			end
		endcase
		
	always @(*) begin
		case(A)			
			4'h0 : seven_value = ~8'b11111100;  // Note inversion
			4'h1 : seven_value = ~8'b01100000;
			4'h2 : seven_value = ~8'b11011010;
			4'h3 : seven_value = ~8'b11110010;
			4'h4 : seven_value = ~8'b01100110;
			4'h5 : seven_value = ~8'b10110110;
			4'h6 : seven_value = ~8'b10111110;
			4'h7 : seven_value = ~8'b11100000;
			4'h8 : seven_value = ~8'b11111110;
			4'h9 : seven_value = ~8'b11110110;
			4'h9 : seven_value = ~8'b11110110;
			4'ha : seven_value = ~8'b11101110;
      			4'hb : seven_value = ~8'b00111110;
      			4'hc : seven_value = ~8'b10011100;
      			4'hd : seven_value = ~8'b01111010;
      			4'he : seven_value = ~8'b10011110;
      			default: seven_value = ~8'b10001110;
		endcase
	end
endmodule

