//This function handles instruction of type Double Operand 

function double_operand;
  input[15:0]instruction;
  
  reg[15:0]source_word;
  reg[15:0]destination_word;
  reg[16:0]result;




begin
  double_operand=0;
  source_word=read_word(instruction[11:9],instruction[8:6]);
  destination_word=read_word(instruction[5:3],instruction[2:0]);
  
  case(instruction[15:12])
          MOV:
          begin
            if(write_word(instruction[5:3],instruction[2:0],source_word))
              $display("Error during MOV Instruction");
              
              if(!(result[15:0]))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             PSW[OVERFLOW]=0;
          end
          
          MOVB:
          begin
          end 
          
          CMP:
          begin
            
            result=source_word-destination_word;
            if(!(result[15:0]))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             if(result[16])
               PSW[CARRY]=1;
             else
               PSW[CARRY]=0;
                if((source_word[15]!=destination_word[15])&&result[15]==source_word[15])
                 PSW[OVERFLOW]=1;
               else
                 PSW[OVERFLOW]=0;
             
            //Overflow logic goes here
          end
          
          CMPB:
          begin
          end
          BIT:
          begin
            result=source_word & destination_word;
            
            if(!(result[15:0]))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
            PSW[OVERFLOW]=0; 

          end
          BITB:
          begin
          end
          BIC://Bit Clear. Clears bits in Destination corrosponding to set bits in Source.
          begin
            result=~(source_word)&(destination_word);
            if(write_word(instruction[5:3],instruction[2:0],result))
              $display("Error during BIC Instruction");
              
              if(!(result[15:0]))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
            PSW[OVERFLOW]=0; 
            
            
          end
          BICB:
          begin
          end
          BIS:
          begin//Bit Set. Sets bits in Destination corrosponding to set bits in Source. 
           begin
            result=source_word || destination_word;
             if(write_word(instruction[5:3],instruction[2:0],result))
              $display("Error during BIS Instruction");
              
              if(!(result[15:0]))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
            PSW[OVERFLOW]=0; 
          end  
            
          end
          BISB:
          begin
          end
          ADD:
          begin 
            result=source_word+destination_word;
            if(write_word(instruction[5:3],instruction[2:0],result))
            $display("Error during ADD Instruction");
            
            if(!(result[15:0]))
             PSW[ZERO]=1;
           else 
             PSW[ZERO]=0;
             
            if(result[15])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             if(result[16])
               PSW[CARRY]=1;
             else
               PSW[CARRY]=0;
               
               if((source_word[15]==destination_word[15])&&result[15]!=source_word[15])
                 PSW[OVERFLOW]=1;
               else
                 PSW[OVERFLOW]=0;
                 

          end
          SUB:
          begin
             result=destination_word-source_word;
            if(write_word(instruction[5:3],instruction[2:0],result))
            $display("Error during SUB Instruction");
            
            if(!(result[15:0]))
             PSW[ZERO]=1;
           else 
             PSW[ZERO]=0;
             
            if(result[15])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             if(result[16])
               PSW[CARRY]=1;
             else
               PSW[CARRY]=0;
               
               if((source_word[15]!=destination_word[15])&&result[15]==source_word[15])
                 PSW[OVERFLOW]=1;
               else
                 PSW[OVERFLOW]=0;
                 
          end
          default:
          begin
            //Error- Invalid Instruction
            double_operand=1;
          end
  endcase
  
  
end
endfunction