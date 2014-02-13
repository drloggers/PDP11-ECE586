//Function to find MODE and SOURCE.
//This function returns 16 bit value from appropriate Source in given Mode 

function [15:0]effective_address;
   input[2:0]mode;
  input[2:0]source;
	input data_type;

  reg[15:0] X;
  
  begin
    case(mode)
			
			REGISTER:
			begin
				$display("Register Mode does not require effective address calculation, check for error in calling level");
			end
           
      REGISTER_DEFERRED:
      begin
       effective_address = R[source];
      end
      
      AUTOINCREMENT:
      begin
        effective_address=R[source];
        R[source] = R[source]+2**(~data_type);
      end
      
      AUTOINCREMENT_DEFERRED:
      begin
         effective_address = mem_read(R[source],word,data);			
         R[source] = R[source]+2;
      end
      
      AUTODECREMENT:
      begin
        R[source] = R[source]-2**(~data_type);
        effective_address = R[source];
      end
      
      AUTODECREMENT_DEFERRED:
      begin
        R[source] = R[source]-2;
        effective_address = mem_read(R[source],word,data);			
      end
      
      			INDEX:
			begin
			 X = mem_read(R[PC],word,data);
			 R[PC] = R[PC]+2;
		   effective_address = R[source]+X;
		   
			end
    			INDEX_DEFERRED:
			begin
	     X = mem_read(R[PC],word,data);					/// do we really need word here or it should be data_type!!!
 		   R[PC]=R[PC]+2;
	     effective_address = mem_read(R[source]+X,data_type,data);
	    end
			default:begin
				$display("This Addressing mode is not supported by this version of PDP11.");
				
			end    endcase
    end
endfunction  