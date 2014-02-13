

function push;
input [15:0]data;
begin
	push = 0;
	R[SP] = R[SP] - 2;
	if(mem_write(R[SP],data,0))
		$display("Error in push operation");
	end
endfunction

function [15:0]pop;
input dummy;
begin
	pop = mem_read(R[SP],0,data_read);
	R[SP] = R[SP] + 2;
end
endfunction