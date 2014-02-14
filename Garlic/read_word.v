//Function to read from MODE and SOURCE.
//This function returns 16/8 bit value from appropriate Source in given Mode 

function [15:0]read;
   input[2:0]mode;
  input[2:0]source;
  input data_type;
  
  reg[15:0] address;
  reg[15:0] X;
  
  begin
    case(mode)
      REGISTER:
      begin
        read = R[source];
      end
      
      REGISTER_DEFERRED:
      begin
       read = mem_read(R[source],data_type,data);
      end
      
      AUTOINCREMENT:
      begin
        read = mem_read(R[source],data_type,data);
        R[source] = R[source]+2**(~data_type);
      end
      
      AUTOINCREMENT_DEFERRED:
      begin
         address = mem_read(R[source],word,data);		
        read = mem_read(address,data_type,data);
        R[source] = R[source]+2;
      end
      
      AUTODECREMENT:
      begin
        R[source] = R[source]-2**(~data_type);
        read = mem_read(R[source],data_type,data);
      end
      
      AUTODECREMENT_DEFERRED:
      begin
        R[source] = R[source]-2;
        address = mem_read(R[source],word,data);		
        read = mem_read(address,data_type,data);
      end
      
      			INDEX:
			begin
			 X = mem_read(R[PC],word,data);
		   read = mem_read(R[source]+X,data_type,data);
		   R[PC] = R[PC]+2;
			end
    			INDEX_DEFERRED:
			begin
	     X = mem_read(R[PC],word,data);					
	     address = mem_read(R[source]+X,word,data);
			 read = mem_read(address,data_type,data);
		   R[PC]=R[PC]+2;
	    end
			default:begin
				$display("This Addressing mode is not supported by this version of PDP11.");
				read = 1;
			end    endcase
			TR[7]=R[7];
    end
endfunction  