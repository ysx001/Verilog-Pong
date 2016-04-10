`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:44 04/05/2016 
// Design Name: 
// Module Name:    vgapixelclock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Divide the 50MHz clock to 25MHz for the VGA pixel clock
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(
    input clk25M, reset
    output [9:0] hcount, vcount,
    output HS, VS, vga_on
    );
  
  // horizonal and vertical counters
  reg [9:0] hcount_reg, h_next_count;
  reg [9:0] vcount_reg, v_next_count;
  
  // buffer
  reg hs_next, vs_next;
  reg hs_reg, vs_reg;
  
  wire h_next_term;
  
  // Timing Specifications for 640x480 @ 60Hz
  // Inspiration from https://learn.digilentinc.com/Documents/269
  
  // Horizonal h_num_pixels = h_bp + h_fp + h_st +  639
  localparam h_num_pixels = 799;  // Value of pixels in a horizonal line = 799
  localparam h_bp = 48; // width for hor back porch is 48 pixels
  localparam h_fp = 16; // width for hor back porch is 16 pixels
  localparam h_st = 96; // widtth for hor sync time is 96 pixels
  
  // Vertical v_num_pixels = v_bp + v_fp + v_st +  479
  localparam v_num_pixels = 524;  // Value of pixels in a horizonal line = 799
  localparam v_bp = 33; // width for vertical back porch is 33 pixels
  localparam v_fp = 10; // width for vertical back porch is 10 pixels
  localparam v_st = 2; // widtth for vertical sync time is 2 pixels
  
	// Horizontial Counter
  always @ (*) begin
	if (hcount_reg < h_num_pixels)
		h_next_count = hcount_reg + 1; 
	else
		h_next_count = 0; // counter has reached the end of pixel count - reset the counter
	h_next_term = (h_next_count >= h_num_pixels) ? 1 : 0; // Enable the vertical counter when hcount >= 799
    end
  
  // Vertical Counter
  // increment count when h_next_term is 1 (end of horizontal counter in reached)
	always @ (*)
		if (count < v_num_pixels & h_next_term)
			v_next_count = vcount_reg + 1;
		else
			v_next_count = 0; // Reset when reach 524 lines
			
  
  assign hs_next =  (hcount_reg <= ( 639 + v_bp + v_st) && hcount_reg > (639 + v_bp)) ? 1 : 0;
  // vs_next asserted between 513 and 514
  assign vs_next = (vcount_reg <= (479 + v_bp + v_st) && vcount_reg > (479 + v_bp)) ? 1 : 0;
  
  // vga_on
  assign vga_on = (hcount_reg > 144 || h_count_reg <= 784 || vcount_reg > 35 || vcount_reg <= 515) ? 1 : 0;
  
  always @ (posedge clk25M, posedge reset) begin
	if (reset)
	  begin
		  hcount_reg <= 0;
		  vcount_reg <= 0;
		  hs_reg <= 1'b0;
		  vs_reg <= 1'b0;
		end
	else
	  hcount_reg <= h_next_count;
	  vcount_reg <= v_next_count;
	  hs_reg <= hs_next;
	  vs_reg <= vs_next;
  end
  
  //output
  
  assign HS = hs_reg;
  assign VS = vs_reg;
  assign hcount = hcount_reg;
  assign vcount = vcount_reg;
  
endmodule


