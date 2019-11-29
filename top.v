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
	input wire ps2c, ps2d,
	output [7:0] led,
	output spacebar_pressed
	);

	wire [9:0] x;  
	wire [9:0] y;

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
		.led(led),
		.spacebar_pressed(spacebar_pressed)
	);

	wire game_clk_g;
	clock_divider #(32'd500000) div_g ( .clk(clk), .clk_out(game_clk_g));

	reg[9:0] g_up = 10'd400;
	reg[9:0] g_down = 10'd440;

	always @(posedge game_clk_g)
	begin
		g_up = g_up + 1;
		g_down = g_down + 1;

		if (g_down > 480)
		begin
			g_up = 0;
			g_down = 40;
		end
	end

	wire game_clk_b;
	clock_divider #(32'd100000) div_b ( .clk(clk), .clk_out(game_clk_b));

	reg[9:0] b_up = 10'd400;
	reg[9:0] b_down = 10'd440;

	always @(posedge game_clk_b)
		begin
		b_up = b_up + 1;
		b_down = b_down + 1;

		if (b_down > 480)
		begin
			b_up = 0;
			b_down = 40;
		end
	end


	// Four overlapping squares
	wire sq_g;
	assign sq_g = ((x > 300) & (x < 340) & (y > g_up) & (y < g_down)) ? 1 : 0;
	assign sq_b = ((x > 200) & (x < 240) & (y > b_up) & (y < b_down)) ? 1 : 0;

	assign red = 0;         // square b is red
	assign green = sq_g;       // squares a and d are green
	assign blue = sq_b;        // square c is blue
endmodule
