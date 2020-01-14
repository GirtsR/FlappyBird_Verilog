`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:15 01/14/2020 
// Design Name: 
// Module Name:    segment 
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
module segment
	#(parameter X_ST = 500, parameter Y_ST = 380)(
		input [9:0] x,	
		input [9:0] y,
		input [3:0] number,
		output segment_on
    );
	
	reg [6:0] n_show;
	always @(*)
	begin
	 case(number)
	 4'b0000: n_show = 7'b0000001; // "0"  
	 4'b0001: n_show = 7'b1001111; // "1" 
	 4'b0010: n_show = 7'b0010010; // "2" 
	 4'b0011: n_show = 7'b0000110; // "3" 
	 4'b0100: n_show = 7'b1001100; // "4" 
	 4'b0101: n_show = 7'b0100100; // "5" 
	 4'b0110: n_show = 7'b0100000; // "6" 
	 4'b0111: n_show = 7'b0001111; // "7" 
	 4'b1000: n_show = 7'b0000000; // "8"  
	 4'b1001: n_show = 7'b0000100; // "9" 
	 default: n_show = 7'b0000001; // "0"
	 endcase
	end
	
	assign f_segment = x >= X_ST && x < X_ST + 3 && y >= Y_ST && y < Y_ST + 15;
	assign e_segment = x >= X_ST && x < X_ST + 3 && y >= Y_ST + 17 && y < Y_ST + 32;
	
	assign a_segment = x >= X_ST + 5 && x < X_ST + 17 && y >= Y_ST && y < Y_ST + 3;
	assign g_segment = x >= X_ST + 5 && x < X_ST + 17 && y >= Y_ST + 14 && y < Y_ST + 17;
	assign d_segment = x >= X_ST + 5 && x < X_ST + 17 && y >= Y_ST + 29 && y < Y_ST + 32;
	
	assign b_segment = x >= X_ST + 19 && x < X_ST + 22 && y >= Y_ST && y < Y_ST + 15;
	assign c_segment = x >= X_ST + 19 && x < X_ST + 22 && y >= Y_ST + 17 && y < Y_ST + 32;
	
	
	assign segment_on = (a_segment & ~n_show[6]) |
							  (b_segment & ~n_show[5]) |
							  (c_segment & ~n_show[4]) |
							  (d_segment & ~n_show[3]) |
							  (e_segment & ~n_show[2]) |
							  (f_segment & ~n_show[1]) |
							  (g_segment & ~n_show[0]);

endmodule
