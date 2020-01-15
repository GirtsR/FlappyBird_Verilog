`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:19:19 01/14/2020 
// Design Name: 
// Module Name:    point_display 
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
module point_display #(parameter X_ST = 500, parameter Y_ST = 380)(
		input [9:0] x,
		input [9:0] y, 
		input [7:0] score,
		output draw_display
    );
	
	wire segment_0_on;
	wire segment_1_on;
	wire segment_2_on;
	
	wire [3:0] ones;
	wire [3:0] tens;
	wire [3:0] hundreds;
	
	bcd bcd_0 (.number(score), .hundreds(hundreds), .tens(tens), .ones(ones));
	
	segment #(X_ST, Y_ST) seg_0 ( .x(x), .y(y), .number(hundreds), .segment_on(segment_0_on));
	segment #(X_ST + 26, Y_ST) seg_1 ( .x(x), .y(y), .number(tens), .segment_on(segment_1_on));
	segment #(X_ST + 52, Y_ST) seg_2 ( .x(x), .y(y), .number(ones), .segment_on(segment_2_on));
	
	assign draw_display = segment_0_on | segment_1_on | segment_2_on;

endmodule


module bcd(number, hundreds, tens, ones);
   input  [7:0] number;
   output reg [3:0] hundreds;
   output reg [3:0] tens;
   output reg [3:0] ones;
   
   // Internal variable for storing bits
   reg [19:0] shift;
   integer i;
   
   always @(number)
   begin
      // Clear previous number and store new number in shift register
      shift[19:8] = 0;
      shift[7:0] = number;
      
      // Loop eight times
      for (i=0; i<8; i=i+1) begin
         if (shift[11:8] >= 5)
            shift[11:8] = shift[11:8] + 3;
            
         if (shift[15:12] >= 5)
            shift[15:12] = shift[15:12] + 3;
            
         if (shift[19:16] >= 5)
            shift[19:16] = shift[19:16] + 3;
         
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
      hundreds = shift[19:16];
      tens     = shift[15:12];
      ones     = shift[11:8];
   end
 
endmodule
