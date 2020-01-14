`timescale 1ns / 1ps

module game(
	input clk,
	input [9:0] x_crd,
	input [9:0] y_crd,
	input btn_pressed,
	output red_ch,
	output green_ch,
	output blue_ch,
	output [6:0] score_out
	);
	localparam BIRD_POS_X_L = 100;
	localparam BIRD_SIZE = 30;
	localparam BIRD_POS_X_R = BIRD_POS_X_L + BIRD_SIZE;
	localparam SCR_WIDTH = 640;
	localparam SCR_HEIGHT = 480;
	
	wire game_clk_g;
	clock_divider #(32'd100000) div_g ( .clk(clk), .clk_out(game_clk_g));

	// Bird Y position calculation
	wire [9:0] position;
	position bird_position (
		.clk(clk),
		.button_pressed(btn_pressed),
		.position(position)
	);
	
	reg[9:0] bird_up = 10'd0;
	reg[9:0] bird_down = BIRD_SIZE;
	
	always @(posedge game_clk_g)
	begin
		bird_up = position - BIRD_SIZE;
		bird_down = position;
	end
	
	// Random number generation from bird position
	wire [3:0] random;
	random random_num (
		.bird_y(position),
		.randbit(random)
	);
	
	// Pipe obstacle generation
	reg reset_score = 0;
	reg reset_physics = 1;	// Game starts when space is pressed
	wire [6:0] score;
	wire [9:0] obs1x, obs1y, obs2x, obs2y, obs3x, obs3y;
	obstacle_generator obs_gen (
		.clk(game_clk_g),
		.randombit(random),
		.reset_score(reset_score),
		.reset_physics(reset_physics),
		.score(score),
		.obs1x(obs1x),
		.obs1y(obs1y),
		.obs2x(obs2x),
		.obs2y(obs2y),
		.obs3x(obs3x),
		.obs3y(obs3y)
	);
	
	reg collision1 = 0;
	reg collision2 = 0;
	reg collision3 = 0;
	
	always @(posedge game_clk_g)
	begin 
		if (btn_pressed && reset_physics) reset_physics = 0;
		if (reset_physics == 0)
		begin 
			collision1 = (bird_up < obs1y - 70 || bird_down > obs1y + 70) &&
					((BIRD_POS_X_L > obs1x - 40 && BIRD_POS_X_L < obs1x) |
					(BIRD_POS_X_R < obs1x && BIRD_POS_X_R > obs1x - 40));
					
			collision2 = (bird_up < obs2y - 70 || bird_down > obs2y + 70) &&
					((BIRD_POS_X_L > obs2x - 40 && BIRD_POS_X_L < obs2x) |
					(BIRD_POS_X_R < obs2x && BIRD_POS_X_R > obs2x - 40));
			
			collision3 = (bird_up < obs3y - 70 || bird_down > obs3y + 70) &&
					((BIRD_POS_X_L > obs3x - 40 && BIRD_POS_X_L < obs3x) |
					(BIRD_POS_X_R < obs3x && BIRD_POS_X_R > obs3x - 40));
		
			reset_physics = collision1 || collision2 || collision3;
		end
	end					 

	assign score_out = score;

	assign pipe_1_top = (x_crd > obs1x - 40) & (x_crd < obs1x) & (y_crd >= 0) & (y_crd < obs1y - 70);   
	assign pipe_1_bot = (x_crd > obs1x - 40) & (x_crd < obs1x) & (y_crd >= obs1y + 70) & (y_crd < SCR_HEIGHT);
	
	assign pipe_2_top = (x_crd > obs2x - 40) & (x_crd < obs2x) & (y_crd >= 0) & (y_crd < obs2y - 70);   
	assign pipe_2_bot = (x_crd > obs2x - 40) & (x_crd < obs2x) & (y_crd >= obs2y + 70) & (y_crd < SCR_HEIGHT);
	
	assign pipe_3_top = (x_crd > obs3x - 40) & (x_crd < obs3x) & (y_crd >= 0) & (y_crd < obs3y - 70);   
	assign pipe_3_bot = (x_crd > obs3x - 40) & (x_crd < obs3x) & (y_crd >= obs3y + 70) & (y_crd < SCR_HEIGHT);
	
	// Draw the bird
	assign bird = ((x_crd >= BIRD_POS_X_L) & (x_crd < BIRD_POS_X_R) & (y_crd >= bird_up) & (y_crd < bird_down));

	wire score_display;
	point_display #(550, 10) p_display(.x(x_crd), .y(y_crd), .score(score), .draw_display(score_display));

	assign red_ch = pipe_1_top | pipe_1_bot | pipe_2_top | pipe_2_bot | pipe_3_top | pipe_3_bot;
	assign green_ch = bird | pipe_2_top | pipe_2_bot | score_display;
	assign blue_ch = pipe_3_top | pipe_3_bot | score_display;
endmodule
