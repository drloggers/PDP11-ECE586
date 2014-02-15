// displays functions

function displayMemory;
	input indicate;
	integer i;
	begin
		if(indicate)
		begin
		$display("\nMemory Location : Data");
	 for(i=0;i<MSIZE;i=i+2)
		begin
        if (mem[i]!== 8'bxxxxxxxx && mem[i+1]!== 8'bxxxxxxxx)
					$display(" %6o 		: %o",i,{mem[i+1],mem[i]});
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
		$display("CARRY 			: %d",PSW[CARRY]);
		$display("OVERFLOW     	   		: %d",PSW[OVERFLOW]);
		$display("ZERO 			: %d",PSW[ZERO]);
		$display("NEGATIVE         		 	: %d",PSW[NEGATIVE]);
	displayPSW = 0;
end
	end
endfunction