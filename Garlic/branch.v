// This function handles Branch instruction

function Branch_instruction;
  input [15:0]instruction;
  reg[15:0]TargetAddress;
  
  
  begin
    Branch_instruction=0;
    TargetAddress=2*instruction[7:0];
		if(TargetAddress[7] == 1'b1)
			TargetAddress[15:8] = 8'b11111111;
		else
			 TargetAddress = TargetAddress; 
    
    case({instruction[15],instruction[10:8]})
      
      BR: //Uncoditional Branch
      begin
        $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BR",R[PC]+TargetAddress,1);
        R[PC] = R[PC]+TargetAddress;
      end
      
      BNE:
      begin
        
      if(!PSW[ZERO])
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BNE",R[PC]+TargetAddress,1);
              R[PC]= R[PC]+TargetAddress;
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BNE",R[PC]+TargetAddress,0);
      end
      
        BEQ:
        begin
        if(PSW[ZERO])
        begin
          $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BEQ",R[PC]+TargetAddress,1);
          R[PC]= (R[PC]+TargetAddress);
       end
      else
        $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BEQ",R[PC]+TargetAddress,0);
      end
        
        BPL:
        begin
        if(!PSW[NEGATIVE])
          begin
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BPL",R[PC]+TargetAddress,1);
            R[PC]= (R[PC]+TargetAddress);
          end
        else
          $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BPL",R[PC]+TargetAddress,0);
        end
          
          BMI:
          begin
          if(PSW[NEGATIVE])
          begin
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BMI",R[PC]+TargetAddress,1);
            R[PC]= (R[PC]+TargetAddress);
            PSW[NEGATIVE] = 0;
          end
        else
          $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BMI",R[PC]+TargetAddress,0);
        end
        
          
          BVC:
          begin
          if(!PSW[OVERFLOW])
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BVC",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
          end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BVC",R[PC]+TargetAddress,0);
          end
          
          BVS:begin
          if(PSW[OVERFLOW])
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BVS",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
           end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BVS",R[PC]+TargetAddress,0);
          end
            
          BCC:
          begin
          if(!PSW[CARRY])
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BCC",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);             
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BCC",R[PC]+TargetAddress,0);
          end
          
          BLO:
          begin
          if(PSW[CARRY])
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLO",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLO",R[PC]+TargetAddress,0);
          end
            
          BGE:
          begin
          if(!(PSW[NEGATIVE] || PSW[OVERFLOW]))
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BGE",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BGE",R[PC]+TargetAddress,0);
          end
            
          BLT:
          begin
          if(PSW[NEGATIVE] || PSW[OVERFLOW])
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLT",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLT",R[PC]+TargetAddress,0);
          end
            
          BGT:
          begin
          if(!(PSW[ZERO] || (PSW[NEGATIVE] ^ PSW[OVERFLOW])))
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BGT",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BGT",R[PC]+TargetAddress,0);
          end
            
          BLE:
          begin
         if(PSW[ZERO] || (PSW[NEGATIVE] ^ PSW[OVERFLOW]))
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLE",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLE",R[PC]+TargetAddress,0);
          end
            
          BHI:
          begin
          if(!(PSW[CARRY] && PSW[ZERO]))
             begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BHI",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
            end
           else
             $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BHI",R[PC]+TargetAddress,0);
           end
            
          BLOS:begin
          if(PSW[CARRY]&&PSW[ZERO])
            begin
              $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLOS",R[PC]+TargetAddress,1);
              R[PC]= (R[PC]+TargetAddress);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"BLOS",R[PC]+TargetAddress,0);
          end
            
         CLC:
          PSW[CARRY] = 1'b0;
          
          CLV:
          PSW[OVERFLOW] = 1'b0;
          
          CLZ:
          PSW[ZERO] = 1'b0;
          
          CLN:
          PSW[NEGATIVE] = 1'b0;
          
          SEC:
          PSW[CARRY] = 1'b1;
          
          SEV:
          PSW[OVERFLOW] = 1'b1;
        
          SEZ:
          PSW[ZERO] = 1'b1;
          
          SEN:
          PSW[NEGATIVE] = 1'b1;

					default: begin
							if(jump_instruction(instruction))
											$display("JMP/RTS failed");
					end
            
      endcase
     end
  endfunction    