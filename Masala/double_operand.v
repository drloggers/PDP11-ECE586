//This function handles instruction of type Double Operand 

function double_operand;
  input[15:0]instruction;
  
  reg[15:0]source_data;
  reg[15:0]destination_data;
  reg[16:0]result;
  
  reg data_type;
  




begin
  double_operand=0;
  data_type=instruction[15];
  
  SEAddress = effective_address(instruction[11:9],instruction[8:6],data_type);
	DEAddress = effective_address(instruction[5:3],instruction[2:0],data_type);

			  
  case(instruction[14:12])
          MOV:
          begin
						
            source_data=read(instruction[11:9],instruction[8:6],data_type,SEAddress);
            if(write(instruction[5:3],instruction[2:0],source_data,data_type))
              $display("Error during MOV Instruction");
              
              if((~data_type && !(source_data)) || (data_type && !(source_data[7:0])))
              
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(source_data[15-data_type*8])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             PSW[OVERFLOW]=0;
          end
         
          
          CMP:
          begin
            source_data=read(instruction[11:9],instruction[8:6],data_type,SEAddress);
            destination_data=read(instruction[5:3],instruction[2:0],data_type,DEAddress);
            result=source_data-destination_data;
            
            if((~data_type && !(result)) || (data_type && !(result[7:0])))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15-data_type*8])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             if(result[16-data_type*8])
               PSW[CARRY]=1;
             else
               PSW[CARRY]=0;
               
                if((source_data[15-data_type*8]!=destination_data[15-data_type*8])&&result[15-data_type*8]==source_data[15-data_type*8])
                 PSW[OVERFLOW]=1;
               else
                 PSW[OVERFLOW]=0;
             
    
          end
          
          
          BIT:
          begin
            
            source_data=read(instruction[11:9],instruction[8:6],data_type,SEAddress);
            destination_data=read(instruction[5:3],instruction[2:0],data_type,DEAddress);
            result=source_data & destination_data;
            
            if(write(instruction[5:3],instruction[2:0],result,data_type))
              $display("Error during BIT Instruction");
            
            if((~data_type && !(result)) || (data_type && !(result[7:0])))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15-data_type*8])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
            PSW[OVERFLOW]=0; 

          end
         
          BIC://Bit Clear. Clears bits in Destination corrosponding to set bits in Source.
          begin
            
            source_data=read(instruction[11:9],instruction[8:6],data_type,SEAddress);
            destination_data=read(instruction[5:3],instruction[2:0],data_type,DEAddress);
            
            result=~(source_data)&(destination_data);
            
            if(write(instruction[5:3],instruction[2:0],result,data_type))
              $display("Error during BIC Instruction");
              
              if((~data_type && !(result)) || (data_type && !(result[7:0])))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15-data_type*8])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
            PSW[OVERFLOW]=0; 
            
            
          end
          
          BIS:
          begin//Bit Set. Sets bits in Destination corrosponding to set bits in Source. 
           begin
             
             source_data=read(instruction[11:9],instruction[8:6],data_type,SEAddress);
            destination_data=read(instruction[5:3],instruction[2:0],data_type,DEAddress);
            
            result=source_data | destination_data;
             if(write(instruction[5:3],instruction[2:0],result,data_type))
              $display("Error during BIS Instruction");
              
              if((~data_type && !(result)) || (data_type && !(result[7:0])))
             PSW[ZERO]=1;
             else 
             PSW[ZERO]=0;
             
            if(result[15-data_type*8])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
            PSW[OVERFLOW]=0; 
          end  
            
          end
         
          ADD:
          begin 
            
            source_data=read(instruction[11:9],instruction[8:6],data_type,SEAddress);
            destination_data=read(instruction[5:3],instruction[2:0],data_type,DEAddress);

            if(data_type) // its a subtract instruction and so added logic here
						begin
         		result=destination_data-source_data;
            if(write(instruction[5:3],instruction[2:0],result[15:0],data_type))
            $display("Error during SUB Instruction");
            
            if((~data_type && !(result[15:0])) || (data_type && !(result[7:0])))
             PSW[ZERO]=1;
           else 
             PSW[ZERO]=0;
             
            if(result[15-data_type*8])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             if(result[16-data_type*8])
               PSW[CARRY]=1;
             else
               PSW[CARRY]=0;
               
               if((source_data[15-data_type*8]!=destination_data[15-data_type*8])&&result[15-data_type*8]==source_data[15-data_type*8])
                 PSW[OVERFLOW]=1;
               else
                 PSW[OVERFLOW]=0;


						end
						else
						begin              
            result=source_data+destination_data;
            if(write(instruction[5:3],instruction[2:0],result[15:0],data_type))
            $display("Error during ADD Instruction");

            if((~data_type && !(result[15:0])) || (data_type && !(result[7:0])))
             PSW[ZERO]=1;
           else 
             PSW[ZERO]=0;
             
            if(result[15-data_type*8])
             PSW[NEGATIVE]=1;
           else
             PSW[NEGATIVE]=0;
             
             if(result[16-data_type*8])
               PSW[CARRY]=1;
             else
               PSW[CARRY]=0;
               
               if((source_data[15-data_type*8]==destination_data[15-data_type*8])&&result[15-data_type*8]!=source_data[15-data_type*8])
                 PSW[OVERFLOW]=1;
               else
                 PSW[OVERFLOW]=0;
                 
						end
          end
          default:
          begin
            //Error- Invalid Instruction
            double_operand=1;
          end
  endcase
  
  
end
endfunction