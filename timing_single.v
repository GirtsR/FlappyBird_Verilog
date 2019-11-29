module VGATimer_single(clk, sync, active, count);
	input clk;		// Activ pe frontul crescator, ori ceas pentru pixel ori pentru linie
	output sync;		// Activ high pentru semnalul de sincronizare
	output active;		// Activ high pentru semnalul video util
	output [11:0] count;// pixel/linie curent/a (numarator de la 0)

	// Toate sunt in functie de ceas
	// Valorile trebuiesc setate pentru un sistem real
	parameter ACTIVE_LEN = 4;		// Cat timp semnalul video e valid
	parameter AFTER_ACTIVE_LEN = 2;	// Cuprinde "back porch" si marginea din dreapta/ de jos
	parameter SYNC_LEN = 1;		  	// Cat timp semnalul sync e activ
	parameter BEFORE_ACTIVE_LEN = 2;	// Cuprinde "front porch" si marginea din stanga/ de sus

	reg syncReg;
	reg activeReg;
	reg [11:0] counter; // pixel/linie curent/a (numarata de la 0)
	
	assign sync = syncReg;
	assign active = activeReg;
	assign count = counter;

	always @ (posedge clk) begin
		if(counter==ACTIVE_LEN -1)
			begin activeReg <= 0; counter <= counter + 1; end
		else if (counter==(ACTIVE_LEN + AFTER_ACTIVE_LEN -1))
			begin syncReg <= 1; counter <= counter + 1; end
		else if (counter==(ACTIVE_LEN + AFTER_ACTIVE_LEN + SYNC_LEN -1))
			begin syncReg <= 0; counter <= counter + 1; end
		else if (counter==(ACTIVE_LEN + AFTER_ACTIVE_LEN + SYNC_LEN + BEFORE_ACTIVE_LEN -1))
			begin activeReg <= 1; counter <= 0; end
		else
			counter <= counter + 1;			
	end
endmodule
