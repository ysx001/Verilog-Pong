`timescale 1ns / 1ps
// lcg.v
//  Linear Congruential Generator PRNG
// Default parameters taken from glibc
module lcg #(parameter N=32, a=1103515245, c=12345) (
    input clk50M,
    output reg [N-1:0] rand
    );
    
    initial rand = 1; // I think this seed is good enough
    
    reg [N-1:0] next_rand;
    
    always @ (*)
        next_rand = a * rand + c;
    
    always @ (posedge clk50M)
        rand <= next_rand;
endmodule
