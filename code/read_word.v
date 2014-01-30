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
       read_word=mem_read(R[source],word,data);
      end
      
      AUTOINCREMENT:
      begin
        read_word=mem_read(R[source],word,data);
        R[source]=R[source]+2;
      end
      
      AUTOINCREMENT_DEFERRED:
      begin
         address=mem_read(R[source],word,data);
        read_word=mem_read(address,word,data);
        R[source]=R[source]+2;
      end
      
      AUTODECREMENT:
      begin
        R[source]=R[source]-2;
        read_word=mem_read(R[source],word,data);
      end
      
      AUTODECREMENT_DEFERRED:
      begin
        
        R[source]=R[source]-2;
        address=mem_read(R[source],word,data);
        read_word=mem_read(address,word,data);
      end
      
      INDEX:
      begin
        X=mem_read(R[PC],word,data);
         read_word= mem_read(R[source]+X,word,data);
         R[PC]=R[PC]+2;
      end
      
     INDEX_DEFERRED:
      begin
         X=mem_read(R[PC],word,data);
         read_word= mem_read(R[source]+X,word,data);
         R[PC]=R[PC]+2;
      end
    endcase
    end
endfunction  