`timescale 1ns / 1ps

module clock_divider // By default generates 1Hz clock
	#(parameter DIVIDER = 32'd50000000)( 
		input clk,
		output clk_out
    );
	 reg clk_reg = 0;
	 reg[31:0] counter = 32'd0;
	 
	 always @(posedge clk)
	 begin
		if(counter > DIVIDER)
		begin
			clk_reg <= ~clk_reg;
			counter <= 0;
		end
		else
			counter <= counter + 1;
	 end
	 
	 assign clk_out = clk_reg;
endmodule
