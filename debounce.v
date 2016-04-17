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

module debounce(
    input raw,
    input clk, reset,
    output reg db_clk, q
    );
    	
    	// states
    	localparam stable_zero = 2'b00;
    	localparam zero_to_one = 2'b01;
    	localparam stable_one = 2'b10;
    	localparam one_to_zero = 2'b11;
	reg [1:0] state, state_next;
    	
	// 2^19 / 50M ~ 10ms
	localparam N = 19; 
	
	reg [N-1:0] counter, counter_next;
	
	always @ (posedge clk, posedge reset) begin
		if (reset)
			begin
				state <= stable_zero;
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
			stable_zero: begin
				q = 1'b0;
				if (raw) begin // if button is pressed
					state_next = zero_to_one;
					counter_next = {N{1'b1}};
				end
			end
			zero_to_one: begin
				q = 1'b0;
				if (raw) begin
					counter_next = counter - 1;
					if (counter_next == 0) begin
						state_next = stable_one;
						db_clk = 1'b1;
					end
				end
				else
					state_next = stable_zero;
			 end
			stable_one: begin
				q = 1'b1;
				if (~raw) begin
					state_next = one_to_zero;
					counter_next = {N{1'b1}};
				end
			end
			one_to_zero: 
				begin
					q = 1'b1;
					if (~raw) begin
						counter_next = counter - 1;
						if (counter_next == 0)
							state_next = stable_zero;
					end
					else
					 state_next = stable_one;
				end
			default: state_next = stable_zero;
		endcase
	end

endmodule
