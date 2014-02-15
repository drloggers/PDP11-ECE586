//Function to write byte/word to specific MODE and destination.
//This function stores 16 bit value to appropriate destination in given Mode 

function write;
  input[2:0]mode;
  input[2:0]destination;
  input[15:0]data_to_write;
  input data_type;
  
  reg temp;
  reg [15:0]address;
  reg [15:0]X;
  
  begin
    write=0;
    case(mode)
      REGISTER:
      begin
        R[destination]=data_to_write;
      end
	
	    default:    begin
	      if(mem_write(DEAddress,data_to_write,data_type))
					$display("Error writing data");
	      end
    endcase
    end
endfunction  