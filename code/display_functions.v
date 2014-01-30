// displays functions

function displayMemory;
	input indicate;
	integer i;
	begin
		if(indicate)
		begin
		$display("\nMemory Location : Data");
	 for(i=0;i<memory_size;i=i+1)
		begin
        if (mem[i]!== 8'bxxxxxxxx)
					$display(" %d 		: %o",i,mem[i]);
		end
	displayMemory = 0;
	end
	end
endfunction

function displayRegister;
	input indicate;
	integer i;
	begin
		if(indicate)
		begin
		$display("\n	Register : Data");
		for(i=0;i<8;i=i+1)
			begin
				$display(" %d 		:%o",i,R[i]);
			end	
	displayRegister = 0;	
	end
end
endfunction

function displayPSW;
	input indicate;
	begin
		if(indicate)
		begin
		$display("\nFlags 			: Status");
		$display("CARRY 			: %d",R[CARRY]);
		$display("OVERFLOW     	   		: %d",R[OVERFLOW]);
		$display("ZERO 			: %d",R[ZERO]);
		$display("NEGATIVE         		 	: %d",R[NEGATIVE]);
		$display("TRAP	 		: %d",R[TRAP]);
	displayPSW = 0;
end
	end
endfunction