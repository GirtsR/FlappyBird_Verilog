`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:42:05 11/22/2019 
// Design Name: 
// Module Name:    debounce 
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
module debounce(
	input clk, 
	input reset, 
	output [31:0] counter
   );
	
	reg [31:0] counter_up;

	always @(posedge clk)
	begin
		if(reset)
			counter_up <= 32'd0;
		else
			counter_up <= counter_up + 32'd1;
	end
	
	assign counter = counter_up;

endmodule