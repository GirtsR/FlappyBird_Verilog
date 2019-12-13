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
	clock_divider #(32'd100000) div_g ( .clk(clk), .clk_out(game_clk_g));

	// Bird Y position calculation
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
	
	
	// Random number generation from bird position
	wire [3:0] random;
	random random_num (
		.bird_y(position),
		.randbit(random)
	);
	
	// Pipe obstacle generation
	reg reset_score = 0;
	reg reset_physics = 0;
	wire obs1en, obs2en, obs3en;
	wire [6:0] score;
	wire [9:0] obs1x, obs1y, obs2x, obs2y, obs3x, obs3y;
	obstacle_generator obs_gen (
		.clk(game_clk_g),
		.randombit(random),
		.reset_score(reset_score),
		.reset_physics(reset_physics),
		.obs1en(obs1en),
		.obs2en(obs2en),
		.obs3en(obs3en),
		.score(score),
		.obs1x(obs1x),
		.obs1y(obs1y),
		.obs2x(obs2x),
		.obs2y(obs2y),
		.obs3x(obs3x),
		.obs3y(obs3y)
	);

	assign pipe_1_top = (x_crd > obs1x - 40) & (x_crd < obs1x) & (y_crd >= 0) & (y_crd < obs1y - 70);   
	assign pipe_1_bot = (x_crd > obs1x - 40) & (x_crd < obs1x) & (y_crd >= obs1y + 70) & (y_crd < 480);
	
	assign pipe_2_top = (x_crd > obs2x - 40) & (x_crd < obs2x) & (y_crd >= 0) & (y_crd < obs2y - 70);   
	assign pipe_2_bot = (x_crd > obs2x - 40) & (x_crd < obs2x) & (y_crd >= obs2y + 70) & (y_crd < 480);
	
	assign pipe_3_top = (x_crd > obs3x - 40) & (x_crd < obs3x) & (y_crd >= 0) & (y_crd < obs3y - 70);   
	assign pipe_3_bot = (x_crd > obs3x - 40) & (x_crd < obs3x) & (y_crd >= obs3y + 70) & (y_crd < 480);
	// Draw the squares
	assign sq_g = ((x_crd >= BIRD_POS_X) & (x_crd < BIRD_POS_X + 40) & (y_crd >= g_up) & (y_crd < g_down));
	assign back = (x_crd > 0) & (x_crd < 640) & (y_crd >= 0) & (y_crd < 480);
	
	assign red_ch = pipe_1_top | pipe_1_bot | pipe_2_top | pipe_2_bot | pipe_3_top | pipe_3_bot;
	assign green_ch = sq_g | pipe_2_top | pipe_2_bot;
	assign blue_ch = pipe_3_top | pipe_3_bot;
endmodule
