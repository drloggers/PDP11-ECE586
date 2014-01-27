// This function handles Branch instruction

function Branch_instruction;
  input [15:0]instruction;
  reg[15:0]TargetAddress;
  
  
  begin
    Branch_instruction=0;
    TargetAddress=2*instruction[7:0];
    
    case({instruction[15],instruction[10:8]})
      
      BR: //Uncoditional Branch
      begin
        
      R[PC] = R[PC]+TargetAddress;
      $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BR",TargetAddress,1);
      end
      
      BNE:
      begin
        
      if(!PSW[ZERO])
            begin
              R[PC]= R[PC]+TargetAddress;
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BNE",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BNE",TargetAddress,0);
      end
      
        BEQ:
        begin
        if(PSW[PSW[ZERO]])
        begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BEQ",TargetAddress,1);
        end
      else
        $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BEQ",TargetAddress,0);
      end
        
        BPL:
        begin
        if(!PSW[NEGATIVE])
          begin
            R[PC]= (R[PC]+TargetAddress);
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BPL",TargetAddress,1);
          end
        else
          $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BPL",TargetAddress,0);
        end
          
          BMI:
          begin
          if(PSW[NEGATIVE])
          begin
            R[PC]= (R[PC]+TargetAddress);
            PSW[PSW[NEGATIVE]] = 0;
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BMI",TargetAddress,1);
          end
        else
          $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BMI",TargetAddress,0);
        end
        
          
          BVC:
          begin
          if(!PSW[OVERFLOW])
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BVC",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BVC",TargetAddress,0);
          end
          
          BVS:begin
          if(PSW[OVERFLOW])
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BVS",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BVS",TargetAddress,0);
          end
            
          BCC:
          begin
          if(!PSW[CARRY])
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BCC",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BCC",TargetAddress,0);
          end
          
          BLO:
          begin
          if(PSW[CARRY])
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLO",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLO",TargetAddress,0);
          end
            
          BGE:
          begin
          if(!(PSW[NEGATIVE] || PSW[OVERFLOW]))
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BGE",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BGE",TargetAddress,0);
          end
            
          BLT:
          begin
          if(PSW[NEGATIVE] || PSW[OVERFLOW])
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLT",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLT",TargetAddress,0);
          end
            
          BGT:
          begin
          if(!(PSW[ZERO] || (PSW[NEGATIVE] ^ PSW[OVERFLOW])))
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BGT",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BGT",TargetAddress,0);
          end
            
          BLE:
          begin
         if(PSW[ZERO] || (PSW[NEGATIVE] ^ PSW[OVERFLOW]))
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLE",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLE",TargetAddress,0);
          end
            
          BHI:
          begin
          if(!(PSW[CARRY] && PSW[ZERO]))
             begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BHI",TargetAddress,1);
             end
           else
             $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BHI",TargetAddress,0);
           end
            
          BLOS:begin
          if(PSW[CARRY]&&PSW[ZERO])
            begin
              R[PC]= (R[PC]+TargetAddress);
              $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLOS",TargetAddress,1);
            end
          else
            $fwrite(branch_file,"%6o %s %6o %b\n",R[PC],"BLOS",TargetAddress,0);
          end
            
        /*  CLC:
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
        */     
      endcase
     end
  endfunction    