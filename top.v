`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:35:25 11/15/2019 
// Design Name: 
// Module Name:    top 
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
module top(
	input clk,          // board clock: 50 MHz on Spartan3E
	// VGA outputs
	output hsync,       // horizontal sync output
	output vsync,       // vertical sync output
	output red,
	output green,
	output blue,
	// Keyboard inputs/outputs
	input ps2c, ps2d,
	output [7:0] led,
	output spacebar_pressed
	);
	
	localparam SCREEN_HEIGHT = 640,
		SCREEN_WIDTH = 480;

	wire [9:0] x;  
	wire [9:0] y;
	
	wire [6:0] score;
	wire [7:0] led_keyboard;

	vga_timing display (
	  .clk(clk),
	  .o_hs(hsync),
	  .o_vs(vsync),
	  .o_x(x),
	  .o_y(y)
	);
	
	keyboard keyboard (
		.clk(clk),
		.ps2c(ps2c),
		.ps2d(ps2d),
		.led(led_keyboard),
		.spacebar_pressed(spacebar_pressed)
	);

	game flappy_bird(
			.clk(clk),
			.x_crd(x),
			.y_crd(y),
			.btn_pressed(spacebar_pressed),
			.red_ch(red),
			.green_ch(green),
			.blue_ch(blue),
			.score_out(score)
			);
	
	// LEDs 0..6 show the score
	assign led [6:0] = score;
	// LED 7 blinks when space is pressed
	assign led [7] = led_keyboard [7];
endmodule
