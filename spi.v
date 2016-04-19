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

// SPI parameters for PMOD joystick (from obscure PDF):
// CPOL=0
// CPHA=0
// This means:
//  * Read on rising clock
//  * Write on falling clock

module spi(
    // Things that connect to other modules
    input clk,              // 50 MHz global clock
    input trigger,          // Initiates a data transfer
    input [39:0] out_bytes, // Data to send to the slave
    output reg [39:0] in_bytes, // Data received from the slave
    // Connect to external hardware
    output reg cs,          // ~chipselect
    output mosi,            // MOSI - master out, slave in
    input miso,             // MISO - master in, slave out
    output sck              // SCK - SPI clock
    );
    
    initial in_bytes = 40'b0;
    
    reg out_enable = 0;
    wire sclk;
	wire spi_clk;
    spi_clk clk_spi( .clk50M( clk ), .enable( out_enable ), .clk( spi_clk ), .sck( sclk ));
    assign sck = sclk; // sck is ignored when cs is 1
    
    wire [39:0] input_sr;
    spi_input spi_in( .sclk( sclk ), .in_bytes( input_sr ), .miso( miso ) );
    
    spi_output spi_out( .sclk(sclk), .reset( trigger ), .out_bytes(out_bytes), .mosi(mosi) );
    
    // FSM
    reg [5:0] fsm_ctr = 6'd41;
    reg [5:0] next_fsm_ctr;
    reg next_out_enable;
    
    always @ (*) begin
        if (fsm_ctr > 40)
            if (trigger == 1)
                next_fsm_ctr = 0;
            else
                next_fsm_ctr = fsm_ctr;
        else
            next_fsm_ctr = fsm_ctr + 1;
        next_out_enable = fsm_ctr < 40 ? 1 : 0;
    end
    
    always @ (posedge spi_clk) begin
        fsm_ctr <= next_fsm_ctr;
        out_enable <= next_out_enable;
        in_bytes <= (next_fsm_ctr == 40) ? input_sr : in_bytes;
        cs <= ~next_out_enable;
    end
    
endmodule

// Shift register for SPI output
// Note: this module assumes that the clock is only 
// active during an active SPI transfer, and that 
// each active SPI transfer continues for exactly 
// 40 clock cycles
module spi_output #(parameter size=40)(
    input sclk,
    input reset,
    input [size - 1:0] out_bytes,
    output mosi);
    
    reg [8:0] n = 9'd0;
    reg [8:0] next_n;
    
    always @ (*)
        next_n =  n > 0 ? n - 1 : 0;
    
    always @ (negedge sclk or posedge reset) begin
        if (reset == 1)
            n <= size - 1;
        else
            n <= next_n;
    end
            
    
    assign mosi = out_bytes[n];

endmodule

// Shift register for SPI input
module spi_input #(parameter size=40)(
    input sclk,
    output reg [size - 1:0] in_bytes,
    // Connect to external hardware
    input miso);
    
    reg [size-1:0] next_in_bytes;
    initial in_bytes = {size{1'b0}};
    
    always @ (*)
        next_in_bytes = (in_bytes << 1) | miso;
    
    always @ (posedge sclk)
        in_bytes <= next_in_bytes;

endmodule

// Clock for use with the SPI bus
// SPI clock must be something below 1MHz
// We use 781.25 kHz, sample code has 66.67 kHz
module spi_clk(
    input clk50M,
    input enable,
    output clk,
    output reg sck
    );
    
    //parameter N=2;
    parameter N = 8;
    
    reg [N-1:0] next_ctr;
    reg [N-1:0] ctr;
    reg next_sck = 0;
    initial ctr = 0;
    initial sck = 0;
    
    always @ (*) begin
        next_ctr <= ctr + 1;
        next_sck <= enable ? next_ctr[N-1] : 0;
    end
       
    always @ (posedge clk50M) begin
        ctr <= next_ctr;
        sck <= next_sck;
    end
    
    assign clk = ctr[N-1];

endmodule

//module pulse_counter #(parameter period)(
//    input clk,
//    output reg pulse);
//    
//    reg [7:0] ctr = 1;
//    reg [7:0] ctr_next;
//    reg pulse_next;
//    
//    always @ (*) begin
//        ctr_next = ctr + 1;
//        pulse_next = ctr_next == period ? 1 : 0;
//    end
//    
//    always @ (posedge clk) begin
//        ctr <= ctr_next;
//        pulse <= pulse_next;
//    end
//endmodule
