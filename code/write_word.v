//Function to find MODE and destination.
//This function stores 16 bit value to appropriate destination in given Mode 

function write_word;
  input[2:0]mode;
  input[2:0]destination;
  input[15:0]data;
  reg temp;
  reg [15:0]address;
  reg [15:0]X;
  
  begin
    write_word=0;
    case(mode)
      REGISTER:
      begin
        R[destination]=data;
      end
      
      REGISTER_DEFERRED:
      begin
        temp=mem_write(R[destination],data[7:0]);
        temp=mem_write(R[destination]+1,data[15:8]);
        
      end
      
      AUTOINCREMENT:
      begin
        temp=mem_write(R[destination],data[7:0]);
        temp=mem_write(R[destination]+1,data[15:8]);
        
        R[destination]=R[destination]+2;
      end
      
      AUTOINCREMENT_DEFERRED:
      begin
        address={mem_read(R[destination]+1,0),mem_read(R[destination],0)};
        temp=mem_write(address,data[7:0]);
        temp=mem_write(address+1,data[15:8]);
         R[destination]=R[destination]+2;
      end
      
      AUTODECREMENT:
      begin
        R[destination]=R[destination]-2;
        temp=mem_write(R[destination],data[7:0]);
        temp=mem_write(R[destination]+1,data[15:8]);
        
      end
      
      AUTODECREMENT_DEFERRED:
      begin
        R[destination]=R[destination]-2;
        address={mem_read(R[destination]+1,0),mem_read(R[destination],0)};
        temp=mem_write(address,data[7:0]);
        temp=mem_write(address+1,data[15:8]);
       
      end
      
      INDEX:
      begin
         X={mem_read(R[PC]+1,0),mem_read(R[PC],0)};
         temp=mem_write(R[destination]+X,data[7:0]);
          temp=mem_write(R[destination]+X+1,data[15:8]);
            
         R[PC]=R[PC]+2;
      end
      
     INDEX_DEFERRED:
      begin
        X={mem_read(R[PC]+1,0),mem_read(R[PC],0)};
        address={mem_read(R[destination]+X+1,0),mem_read(R[destination]+X,0)};
        temp=mem_write(address,data[7:0]);
        temp=mem_write(address+1,data[15:8]);
     
         R[PC]=R[PC]+2;
      end
      
      default:
      begin
        //Error. 
        write_word=1;
      end
    endcase
    end
endfunction  