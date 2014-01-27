

function push;
input [15:0]data;
begin
push = 0;
	R[SP] = R[SP] - 2;
	{mem[SP-1],mem[SP]}=data;
	end
endfunction

function [15:0]pop;
begin
	pop = {mem[SP+1],mem[SP]};
	R[SP] = R[SP] + 2;
end
endfunction