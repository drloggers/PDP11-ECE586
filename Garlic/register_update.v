function register_update;
  input[2:0]mode;
  input[2:0]source;
  input data_type;


case(mode)
     
      AUTOINCREMENT:
      begin
       
        R[source] = R[source]+2**(~data_type);
      end
      
      AUTOINCREMENT_DEFERRED:
      begin
       
        R[source] = R[source]+2;
      end
      
     
			default:begin
				
		
			end    endcase
			
			endfunction