`timescale 1ns / 1ps
// VGA timing for 640*480 resolution
module vga_timing(
   input wire clk,              // 50MHz clock
	output wire o_hs,            // horizontal sync
   output wire o_vs,            // vertical sync
   output wire [9:0] o_x,       // current pixel x position
   output wire [9:0] o_y        // current pixel y position
   );

	localparam HS_STA = 16;              // horizontal sync start
	localparam HS_END = 16 + 96;         // horizontal sync end
	localparam HA_STA = 16 + 96 + 48;    // horizontal active pixel start
	localparam VS_STA = 480 + 10;        // vertical sync start
	localparam VS_END = 480 + 10 + 2;    // vertical sync end
	localparam VA_END = 480;             // vertical active pixel end
	localparam LINE   = 800;             // complete line (pixels)
	localparam SCREEN = 525;             // complete screen (lines)

	reg [9:0] h_count;  // line position
	reg [9:0] v_count;  // screen position

	// generate sync signals (active low for 640x480)
	assign o_hs = ~((h_count >= HS_STA) & (h_count < HS_END));
	assign o_vs = ~((v_count >= VS_STA) & (v_count < VS_END));

	// keep x and y bound within the active pixels
	assign o_x = (h_count < HA_STA) ? 0 : (h_count - HA_STA);
	assign o_y = (v_count >= VA_END) ? (VA_END - 1) : (v_count);

	wire clk_25mhz;	
	clock_divider #(32'd2) div (.clk(clk), .clk_out(clk_25mhz));

	always @ (posedge clk)
	begin
		if (clk_25mhz)  // once per pixel
		begin
			if (h_count == LINE)  // end of line
			begin
				h_count <= 0;
				v_count <= v_count + 1;
			end
			else 
				h_count <= h_count + 1;

			if (v_count == SCREEN)  // end of screen
				v_count <= 0;
		end
	end

endmodule
