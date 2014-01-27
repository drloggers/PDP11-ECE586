//Function to find MODE and SOURCE.
//This function returns 16 bit value from appropriate Source in given Mode 

function [15:0]read_word;
   input[2:0]mode;
  input[2:0]source;
  reg[15:0]address;
  reg [15:0]X;
  
  begin
    case(mode)
      REGISTER:
      begin
        read_word=R[source];
      end
      
      REGISTER_DEFERRED:
      begin
       read_word={mem_read(R[source]+1,0),mem_read(R[source],0)};
      end
      
      AUTOINCREMENT:
      begin
        read_word={mem_read(R[source]+1,0),mem_read(R[source],0)};
        R[source]=R[source]+2;
      end
      
      AUTOINCREMENT_DEFERRED:
      begin
         address={mem_read(R[source]+1,0),mem_read(R[source],0)};
        read_word={mem_read(address+1,0),mem_read(address,0)};
        R[source]=R[source]+2;
      end
      
      AUTODECREMENT:
      begin
        R[source]=R[source]-2;
        read_word={mem_read(R[source]+1,0),mem_read(R[source],0)};
      end
      
      AUTODECREMENT_DEFERRED:
      begin
        
        R[source]=R[source]-2;
        address={mem_read(R[source]+1,0),mem_read(R[source],0)};
       read_word={mem_read(address+1,0),mem_read(address,0)};
      end
      
      INDEX:
      begin
        X={mem_read(R[PC]+1,0),mem_read(R[PC],0)};
         read_word= {mem_read(R[source]+X+1,0),mem_read(R[source]+X,0)};
         R[PC]=R[PC]+2;
      end
      
     INDEX_DEFERRED:
      begin
         X={mem_read(R[PC]+1,0),mem_read(R[PC],0)};
         read_word= {mem_read(mem_read(R[source]+X+1,0),0),mem_read(mem_read(R[source]+X,0),0)};
         R[PC]=R[PC]+2;
      end
    endcase
    end
endfunction  