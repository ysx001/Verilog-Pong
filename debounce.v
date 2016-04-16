`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:51:40 03/29/2016 
// Design Name: 
// Module Name:    debouncer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: none
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// Revised debouncer using a FSMD approach -- Inspriation from FPGA prototyping by Verilog Examples

module debouncer(
    input raw,
    input clk, reset
    output reg db_clk, q
    );
    	
    	// states
    	localparam stable_0 = 2'b00;
    	localparam 0_to_1 = 2'b01;
    	localparam stable_1 = 2'b10;
    	localparam 1_to_0 = 2'b11;
	reg [1:0] state, state_next;
    	
	// 2^19 / 50M ~ 10ms
	localparam N = 19; 
	
	reg [N-1:0] counter, counter_next;
	
	always @ (posedge clk, posedge reset) begin
		if (reset)
			begin
				state <= stable_0;
				counter <= 0;
			end
		else
			begin
				state <= state_next;
				counter <= counter_next;
			end
	end
	
	
	
	// set counter to all 1's each time button is pressed, decrement the counter each clock tick
	// when the counter reaches 0, changes output q.
	always @(*) begin
		state_next = state;
		counter_next = counter;
		db_clk = 1'b0;
		case (state)
			stable_0: begin
				q = 1'b0;
				if (raw) begin // if button is pressed
					state_next = 0_to_1;
					counter_next = {N{1'b1}};
				end
			end
			0_to_1: begin
				q = 1'b0
				if (raw) begin
					counter_next = counter - 1;
					if (counter_next == 0) begin
						state_next = stable_1;
						db_clk = 1'b1;
					end
				end
				else
					state_next = stable_0;
			end
			stable_1: begin
				q = 1'b1;
				if (~raw) begin
					state_next = 1_to_0;
					counter_next = {N{1'b1}};
				end
			end
			1_to_0: begin
				q = 1'b1;
				if (~raw) begin
					counter_next = counter - 1;
					if (counter_next == 0)
						state_next = stable_0;
				end
				else
					state_next = stable_1;
			end
			default: state_next = stable_0;
		endcase
	end

endmodule
