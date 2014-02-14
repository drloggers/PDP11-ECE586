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
      
      REGISTER_DEFERRED:
      begin
        if(mem_write(R[destination],data_to_write,data_type))
          $display("Error during write in Register Deferred");
	      end
      
      AUTOINCREMENT:
      begin
        if(mem_write(R[destination],data_to_write,data_type))
          $display("Error during write in Autoincrement");
              
         R[destination]=R[destination]+2**(~data_type);
      end
      
      AUTOINCREMENT_DEFERRED:
      begin
        address=mem_read(R[destination],data,word); 		
        if(mem_write(address,data_to_write,data_type))
          $display("Error during write in Autoincrement Deferred");
        
         R[destination]=R[destination]+2;
      end
      
      AUTODECREMENT:
      begin
        R[destination]=R[destination]-2**(~data_type);
        if(mem_write(R[destination],data_to_write,data_type))
          $display("Error during write in Autodecrement");       
      end
      
      AUTODECREMENT_DEFERRED:
      begin
        R[destination]=R[destination]-2;
        address=mem_read(R[destination],data,word);		
        if(mem_write(address,data_to_write,data_type))
        $display("Error during write in Autoincrement Deferred");
       
      end
      
      			INDEX:
      begin	     		   X=mem_read(R[PC],word,data);						
       if(mem_write(R[destination]+X,data_to_write,data_type))
          $display("Error during write in Index");
        		 R[PC]=R[PC]+2;
  		end
    		  INDEX_DEFERRED:
		  begin
		   X=mem_read(R[PC],word,data);			
	     address=mem_read(R[destination]+X,word,data);			
		   if(mem_write(address,data_to_write,data_type))
        $display("Error during write in Index Deferred");
      		   R[PC]=R[PC]+2;
	    end
	
	    default:    begin
	      //Error. 
	      write=1;
	      end
    endcase
    end
endfunction  