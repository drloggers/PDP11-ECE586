// Function to find Jump and Subroutine instruction

function jump_instruction;  
  input [15:0]instruction;
  reg [15:0]result;  
    begin      
      jump_instruction = 0;      
      case(instruction[8:6])       
          JMP:     
          begin
            if(instruction[5:3] == 3'b000)
              begin
                $display("Can not use Register addressing mode for JMP instruction");
              end             
             else
               begin
                result = effective_address(instruction[5:3], instruction[2:0],instruction[15]);
                if(result%2 == 0)
                begin
                  $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"JMP",result,1);
                   R[PC] = result;
                end                  
                else
                  $display("Boundry Error. The address cannot be odd");                
               end      
         end          
           RTS:
           begin
								result = read(instruction[5:3],instruction[2:0],instruction[15]);
                $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"RTS",result,1);
                R[PC] = result;          
                R[instruction[2:0]] = pop(0);    
           end
  	endcase
end       
endfunction