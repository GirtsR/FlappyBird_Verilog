`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:34 11/29/2019 
// Design Name: 
// Module Name:    game 
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
module game(
		input clk,
		input [9:0] x_crd,
		input [9:0] y_crd,
		input btn_pressed,
		output red_ch,
		output green_ch,
		output blue_ch
    );
	localparam BIRD_POS_X = 100;
	
	wire game_clk_g;
	clock_divider #(32'd500000) div_g ( .clk(clk), .clk_out(game_clk_g));

	wire [9:0] position;
	
	position bird_position (
		.clk(clk),
		.button_pressed(btn_pressed),
		.position(position)
	);
	
	reg[9:0] g_up = 10'd0;
	reg[9:0] g_down = 10'd40;
	
	always @(posedge game_clk_g)
	begin
		g_up = position - 40;
		g_down = position;
	end

	wire game_clk_b;
	clock_divider #(32'd100000) div_b ( .clk(clk), .clk_out(game_clk_b));

	reg[9:0] b_up = 10'd400;
	reg[9:0] b_down = 10'd440;

	always @(posedge game_clk_b)
		if(btn_pressed)
		begin			
			begin
			b_up = b_up + 1;
			b_down = b_down + 1;

			if (b_down > 480)
			begin
				b_up = 0;
				b_down = 40;
			end
		end
	end


	// Draw the squares
	assign sq_g = ((x_crd > BIRD_POS_X) & (x_crd < BIRD_POS_X + 40) & (y_crd > g_up) & (y_crd < g_down)) ? 1 : 0;
	assign sq_b = ((x_crd > 200) & (x_crd < 240) & (y_crd > b_up) & (y_crd < b_down)) ? 1 : 0;
	
	assign red_ch = 0;
	assign green_ch = sq_g;
	assign blue_ch = sq_b;
endmodule
