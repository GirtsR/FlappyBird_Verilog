`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:34 11/01/2019 
// Design Name: 
// Module Name:    keyboard 
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
module keyboard(
	input wire clk,
	input wire ps2c, ps2d,
	output [7:0] led,
//	output [3:0] J1,
//	output [3:0] J2,
	output spacebar_pressed
	);
	
	// Keycodes
	reg [7:0] keycode = 0;
	reg [7:0] keycode_pre = 0;
	reg space_pressed_reg = 0;
	
	// 50MHz clock <-> ps2c sync registers
	reg [7:0] filter_reg;               // Shift register filter for ps2c
	wire [7:0] filter_next;             // Next state value of ps2c filter register
	reg f_val_reg;                      // ps2c filter value, either 1 or 0
	wire f_val_next;                    // Next state for ps2c filter value
	wire neg_edge;                      // Negative edge of ps2c clock filter value
	
	// 3 states for receiving data
	localparam 
		IDLE = 2'b00,
		RECEIVE = 2'b01,
		DELAY = 2'b10;
		
	// Used keycodes
	localparam 
		SPACE = 8'h29,		// Keycode for spacebar
		RELEASE = 8'hF0;	// Keycode for key release
	
	// 50MHz clock dividers
	localparam
		MILLISECOND = 32'd50000,
		DELAY = 32'd50000000;
		
	// Debouncer initialization
	reg reset = 1;
	wire [31:0] counter;
	debounce deb(.clk(clk),.reset(reset),.counter(counter));
	
	// State machine registers
	reg [1:0] state_reg, state_next = IDLE; // Current and next state
	reg [3:0] n_reg, n_next = 0;            // Current and next bit number 
	reg [10:0] d_reg, d_next = 0;           // Register to shift in received data
	
	// Sync with ps2c falling edge
	always @(posedge clk)
	begin
		filter_reg <= filter_next;
		f_val_reg  <= f_val_next;
	end
	
	// Next state value of ps2c filter: right shift in current ps2c value to register
	assign filter_next = {ps2c, filter_reg[7:1]};
	
	// Filter value next state, 1 if all bits are 1, 0 if all bits are 0, else no change
	assign f_val_next = 	(filter_reg == 8'b11111111) ? 1'b1 :
								(filter_reg == 8'b00000000) ? 1'b0 :
								f_val_reg;
	
	// Negative edge of filter value: if current value is 1, and next state value is 0
	assign neg_edge = f_val_reg & ~f_val_next;


	// Next states for the 3 state machine
	always @(posedge clk)
	begin
		begin
			state_reg <= state_next;
			n_reg <= n_next;
			d_reg <= d_next;
		end
	end
	
	always @* // Logic
	begin
		// Defaults
		state_next = state_reg;
		n_next = n_reg;
		d_next = d_reg;
		
		case (state_reg)
			IDLE:
			begin
				if (neg_edge)                 // Start bit received
				begin
					n_next = 0;             // set bit count down to 10
					state_next = RECEIVE;	// go to receive state
				end
			end
			RECEIVE:  // Receive 8 data, 1 parity, and 1 stop bit
			begin
				if (neg_edge)                         // Data bit received
				begin
					d_next = {ps2d, d_reg[10:1]}; // Right shift current data
					n_next = n_reg + 1;           // Bit count + 1
				end
			
				if (n_reg == 10)	// All bits received
				begin
					keycode_pre = keycode;	// Set previous and current keycode
					keycode = d_reg[8:1];
					
					state_next = idle;
											
					if (keycode_pre == RELEASE) // Space was released
					begin
						reset = 1;
						state_next = delay;
						space_pressed_reg = 0;
					end
					else if (keycode == SPACE)	// Space was pressed
					begin 
						space_pressed_reg = 1;
					end
				end
			end
			DELAY:
			begin
				reset = 0;
				if (counter == millisecond * 50)		// 50ms second delay
				begin
					state_next = idle;
				end
			end
		endcase
	end
	
//	assign led = keycode;
	assign led[7:6] = state_reg;
//	assign J1 = keycode[3:0];
//	assign J2 = keycode[7:4];
//	assign led = debounce [15:0];
	assign spacebar_pressed = space_pressed_reg;
endmodule