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
module score(
    input wire clk50M, reset,
    input wire [1:0] score,
    input wire score_clr,
    output [7:0] seven_value,
    output [3:0] disp_select );
	 
	reg [7:0] score_1, score_0;
	reg [7:0] score_0_next, score_1_next;
	//wire db_clk_1, db_clk_0, q_0;
	
	//debounce dp_btn_0 (.raw(btn[0]), .clk(clk), .reset(reset), .db_clk(db_clk_0), .q(q_0));
	//debounce dp_btn_1 (.raw(btn[1]), .clk(clk), .reset(reset), .db_clk(db_clk_1), .q());
	
	 
	sseg_hex score_disp(.clk50M(clk50M), .reset(reset), .first_1(score_0[7:4]), .first_0(score_0[3:0]), .second_1(score_1[7:4]),
			.second_0(score_1[3:0]), .disp_select(disp_select), .seven_value(seven_value));

	
	always @ (posedge clk50M)
		if(reset) begin
			score_0 <= 0;
			score_1 <= 0;
		end
		else begin
			score_0 <= score_0_next;		
			score_1 <= score_1_next;
			
		end
  
	

	always @ (*)
	begin
		score_0_next = score_0;
		score_1_next = score_1;
		if (score_clr) begin
			score_0_next = 0;
			score_1_next = 0;
		end

		else if(score[0]) begin
		if(score_0_next[3:0] == 4'b1001)begin
			score_0_next[3:0] = 4'b0;
			if(score_0_next[7:4] == 4'b1001)
				score_0_next[7:4] = 0;
			else
				score_0_next[7:4] = score_0[7:4] + 1;
		end
		else
			score_0_next[3:0] = score_0[3:0] + 1;
		end

		else if(score[1]) begin
		if(score_1_next[3:0] == 4'b1001)begin
			score_1_next[3:0] = 4'b0;
			if(score_1_next[7:4] == 4'b1001)
				score_1_next[7:4] = 0;
			else
				score_1_next[7:4] = score_1[7:4] + 1;
		end
		else
			score_1_next[3:0] = score_1[3:0] + 1;
		end
	end
  
  
	//assign btn_1_next = (db_clk_1) ? btn_1 + 1 : btn_1;
	//assign btn_0_next = (db_clk_0) ? btn_0 + 1 : btn_0;
	//sound note(.clk25(clk), .point(btn[0]), .lose(db_clk_1), .speaker(speaker)); 
endmodule

module sseg_hex (input clk50M, reset,
		input [3:0] first_1, first_0, second_1, second_0,
		output reg [3:0] disp_select,
		output reg [7:0] seven_value
		);
	
	
	reg [18:0] counter;
	wire[18:0] counter_next;
	reg [3:0] A;
	wire [1:0] toptwo;
	
	always @ (posedge clk50M, posedge reset)
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
			4'ha : seven_value = ~8'b11101110;
      	4'hb : seven_value = ~8'b00111110;
      	4'hc : seven_value = ~8'b10011100;
      	4'hd : seven_value = ~8'b01111010;
      	4'he : seven_value = ~8'b10011110;
      	default: seven_value = ~8'b10001110;
		endcase
	end
endmodule
