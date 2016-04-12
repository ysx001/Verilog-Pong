# Verilog-Pong
A Pong game implemented using Verilog for a Spartan 3E XCS500E FPGA board.

This project is developed for the final project of ECEG240 (Spring 2016) at Bucknell University.

The game will be displayed on to a monitor via a VGA cable, and be played by a single player who tries to keep the ball not falling off the paddle for as long as possible. The paddles will be controlled by two buttons. One button will move the paddle up and the other will move the paddle down. The game also contains a score display using the 7-segment-displays on the FPGA board. In addition, a beep sound will notice the player whenever he/she scores a point.

Updates April 11, 2016
1) Added paddle.v allowing paddle to move according to button input (up and down)
2) fixed ball.v to 8-bit rgb output and mux control ouput(ball_on)
3) added function call to ball.v in graphics.v for generating ball movement on vga.

Things to test in lab on April 12, 2016:
1) If ball can bounce around the screen freely
2) If paddle can move up and down on screen according to button inputs

Further improvements:
1) incorporate button control and ball movement to make ball bounce off paddle the same way it bounce off wall
2) record score each collison
3) seven_seg display of score
4) sound output
