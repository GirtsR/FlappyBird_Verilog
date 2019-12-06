`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:18:38 11/29/2019 
// Design Name: 
// Module Name:    velocity 
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
module position(
	input clk,
	input button_pressed,
	output [9:0] position
	);
	
	localparam VELOCITY_ON_PRESS = 32,	// Velocity when Space is pressed
		POS_MAX = 479,	// Bottom of the screen
		POS_MIN = 40,	// Top of the screen
		GRAVITY = 4,	// Speed removed every 10ms
		VELOCITY_MIN = -8,	// Max falling speed
		UPDATE_FREQUENCY = 500000; // 10ms
		
	wire clk_out;
	clock_divider #(UPDATE_FREQUENCY) div_g ( .clk(clk), .clk_out(clk_out));
	
	reg [9:0] position_reg = 240; // Starting position
	reg signed [9:0] velocity = 0;
	
	reg should_jump = 1;
	always @(posedge clk_out)
	begin
		if(button_pressed && should_jump)
		begin		
			should_jump = 0;
			velocity = VELOCITY_ON_PRESS;
		end
		else if(!button_pressed)
		begin
			should_jump = 1;
		end
		
		if (velocity <= VELOCITY_MIN) velocity = VELOCITY_MIN;
		else velocity = velocity - GRAVITY;
		
		position_reg = position_reg - velocity;
		
		if (position_reg >= POS_MAX)
		begin
			position_reg = POS_MAX;
		end
		else if (position_reg <= POS_MIN)
		begin
			position_reg = POS_MIN;
		end
	end

	assign position = position_reg;
	
endmodule
