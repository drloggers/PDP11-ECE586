//Function to read from MODE and SOURCE.
//This function returns 16/8 bit value from appropriate Source in given Mode 

function [15:0]read;
   input[2:0]mode;
  input[2:0]source;
  input data_type;
	input [15:0]address;
  
  reg[15:0] address;
  reg[15:0] X;
	
  
  begin
		
    case(mode)
      REGISTER:
      begin
        read = R[source];
      end
      
			default:begin
				
					read = mem_read(address,data_type,data);
			end    endcase
		
    end
endfunction  