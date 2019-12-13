`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:09:23 12/13/2019 
// Design Name: 
// Module Name:    obstacle_generator 
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
module obstacle_generator(
	input clk, 
	input [3:0] randombit, 
	input reset_score, reset_physics,
	output obs1en, obs2en, obs3en,
	output reg [6:0] score,
	output reg [9:0] obs1x, obs1y, obs2x, obs2y, obs3x, obs3y
	);
	
	localparam BIRD_POS_X = 100;
	
	reg obs1, obs2, obs3;
	assign obs1en = obs1;
	assign obs2en = obs2;
	assign obs3en = obs3;
	initial obs1 = 0;
	initial obs2 = 0;
	initial obs3 = 0;
	initial score = 0;

	always @(posedge clk) 
	begin							
		if (reset_physics) 
		begin
			 obs1 = 0;
			 obs1x = 680;
			 obs2 = 0;
			 obs2x = 680;
			 obs3 = 0;
			 obs3x = 680;
			 score = 0;
		end
		else 
		begin
			if (!obs1) begin
				obs1 = 1;
				obs1x = 680; // Place obs1 on very right of screen
			end
			else if (obs1x == 640 - 213 && !obs2) begin
				obs2 = 1;
				obs2x = 680; // Place obs2 on very right of screen
			end
			else if (obs1x == 214 && !obs3) begin
				obs3 = 1;
				obs3x = 680; // {lace obs3 on very right of screen
			end
			if (obs1) begin 
				obs1x = obs1x - 1; // Move one pixel to the left
				if (obs1x <= 0) begin // Obstacle offscreen, reset x
					obs1x = 680;
					obs1y = (randombit[0] == 1'b0) ? 200 + (randombit * 10) : 300 - (randombit * 11);
				end
				if (obs1x == BIRD_POS_X) score = score + 1; //if bird passes obs, +1 score
			end
			if (obs2) begin
				obs2x = obs2x - 1;
				if (obs2x <= 0) begin
					obs2 = 0;
				end
				if (obs2x == BIRD_POS_X) score = score + 1;
			end
			if (obs3) begin
				obs3x = obs3x-1;
				if (obs3x <= 0) begin
					obs3 = 0;
				end
				if (obs3x == BIRD_POS_X) score = score + 1;
			end
		end

		// Calcuate the random position of the pipe
		if (!obs1) obs1y = (randombit[0] == 1'b0) ? 200 + (randombit * 10) : 300 - (randombit * 11);
		if (!obs2) obs2y = (randombit[1] == 1'b1) ? 300 - (randombit * 7) : 125 + (randombit * 2);
		if (!obs3) obs3y = (randombit[2] == 1'b1) ? 300 - (randombit * 2) : 150 + (randombit * 6);
	end

endmodule
