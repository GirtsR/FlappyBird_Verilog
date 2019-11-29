`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:01:08 11/01/2019
// Design Name:   keyboard
// Module Name:   /home/students/Documents/girts/keyboard/test_keyboard.v
// Project Name:  keyboard
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: keyboard
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_keyboard;

	// Inputs
	reg clk;
	reg data;
	reg [7:0] key;
	
	// Outputs
	wire [7:0] code;
	wire led0;

	// Instantiate the Unit Under Test (UUT)
	keyboard uut (
		.clk(clk), 
		.data(data), 
		.code(code), 
		.led0(led0)
	);
	
	initial begin
		// Initialize Inputs
		clk = 0;
		data = 0;

		key = 8'b00101001;
		 
		#10;
		#10 data = key[0];
		#10 data = key[1];
		#10 data = key[2];
		#10 data = key[3];
		#10 data = key[4];
		#10 data = key[5];
		#10 data = key[6];
		#10 data = key[7];
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
     
	always #5 clk = ~clk;
	
endmodule

