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
module velocity(
	input clk,
	input button_pressed,
	output [9:0] velocity
	);
	
	localparam VELOCITY_ON_PRESS = 40,
		GRAVITY = 10,
		UPDATE_FREQUENCY = 500000; // 10 ms
		
	wire clk_out;
	
	clock_divider divider (
		.clk(clk),
		.clk_out(clk_out)
	);
	
	reg [9:0] velocity_reg = 0;
	
//	always @(posedge button_pressed)
//	begin
//		velocity_reg <= VELOCITY_ON_PRESS;
//	end
	
	always @(posedge clk_out)
	begin
		if (button_pressed) velocity_reg <= VELOCITY_ON_PRESS;
		else velocity_reg <= velocity_reg - GRAVITY;
	end

	assign velocity = velocity_reg;
	
endmodule
