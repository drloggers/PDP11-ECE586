//This function handles instruction of type Double Operand 

function double_operand;
  input[15:0]instruction;
  
  reg[15:0]source_word;
  reg[15:0]destination_word;
  reg[16:0]result;




begin
  double_operand=0;
  source_word=read_word(instruction[11:9],instruction[8:6]);
  
  case(instruction[15:12])
          MOV:
          begin
            if(write_word(instruction[5:3],instruction[2:0],source_word))
              $display("Error during MOV Instruction");
          end
          
          MOVB:
          begin
          end 
          
          CMP:
          begin
            destination_word=read_word(instruction[5:3],instruction[2:0]);
            result=source_word-destination_word;
            if(!result)
              PSW[ZERO]=1;
            else if(result<0)
              PSW[NEGATIVE]=1;
            else if(result[16])
              PSW[CARRY]=0;
            //Overflow logic goes here
          end
          
          CMPB:
          begin
          end
          BIT:
          begin
          end
          BITB:
          begin
          end
          BIC:
          begin
          end
          BICB:
          begin
          end
          BIS:
          begin
          end
          BISB:
          begin
          end
          ADD:
          begin 
          end
          SUB:
          begin
          end
          default:
          begin
            //Error- Invalid Instruction
            double_operand=1;
          end
  endcase
  
  
end
endfunction