`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:57:58 11/29/2019 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider(
		input clk,
		output clk_out
    );
	 
	 parameter DIVIDER = 32'd50000000; // By default generates 1Hz clock

	 reg clk_reg = 0;
	 reg[31:0] counter = 32'd0;
	 
	 always @(posedge clk)
	 begin
		if(counter_g > DIVIDER)
		begin
			clk_reg <= ~game_clk_g;
			counter <= 0;
		end
		else
			counter <= counter + 1;
	 end
	 
	 assign clk_out = clk_reg;
endmodule
