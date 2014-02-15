//This function handles instruction of type Single Operand 

function single_operand;
  input[15:0]instruction;
	reg [15:0]result;
	reg [17:0]temp;
	reg [7:0]swapingReg;
	reg tempbit;
	reg data_type;

	begin
	  
		single_operand = 0;
		data_type=instruction[15];
		SEAddress = effective_address(instruction[5:3],instruction[2:0],data_type);
		DEAddress = effective_address(instruction[5:3],instruction[2:0],data_type);
		
			case(instruction[10:6])
				CLR:
				begin
					if(write(instruction[5:3],instruction[2:0],0,data_type))
						$display("Error during CLR instruction");
					PSW[CARRY] = 0;
					PSW[OVERFLOW] = 0;
          PSW[ZERO] = 1;
          PSW[NEGATIVE] = 0;
				end
				
				COM:
				begin
					//$display("%b",~read(instruction[5:3],instruction[2:0]));
					result = ~read(instruction[5:3],instruction[2:0],data_type,SEAddress);
					if(write(instruction[5:3],instruction[2:0],result,data_type))
						$display("Error during COM instruction");

					if((~data_type &&!(result[15:0]))||(data_type &&!(result[7:0])))
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result[15-data_type*8])
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

						PSW[OVERFLOW] = 0;
						PSW[CARRY] = 1;
				end
					INC:
				begin
					//$display("%b :::::::::: %o",read(instruction[5:3],instruction[2:0]),15'o77777);
					result = read(instruction[5:3],instruction[2:0],data_type,SEAddress);
					result = result + 1;
					
					if(write(instruction[5:3],instruction[2:0],result,data_type))
						$display("Error during INC instruction");

					if((~data_type &&!(result[15:0]))||(data_type &&!(result[7:0])))
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if((~data_type && (result[15:0]-1 == 16'o077777))||(data_type && (result[7:0]-1 == 8'o177)))
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0;

					if(result[15-data_type*8])
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

				end

					DEC:
				begin
					//$display("%b",read(instruction[5:3],instruction[2:0]));
					result = read(instruction[5:3],instruction[2:0],data_type,SEAddress);
					result = result - 1;
					
					if(write(instruction[5:3],instruction[2:0],result,data_type))
						$display("Error during DEC instruction");

					if((~data_type &&!(result[15:0]))||(data_type &&!(result[7:0])))
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result[15:0] == 16'o100000)//What for byte ?
						PSW[CARRY] = 1;
					else
						PSW[CARRY] = 0;

					if(result[15-data_type*8])
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;
				end

					NEG:
				begin
					//$display("%b",~read(instruction[5:3],instruction[2:0]));
					result = -(read(instruction[5:3],instruction[2:0],data_type,SEAddress)); //- works ? Best thing is to do 2's complement and store
					if(write(instruction[5:3],instruction[2:0],result,data_type))
						$display("Error during NEG instruction");
					
					if((~data_type &&!(result[15:0]))||(data_type &&!(result[7:0])))
					begin
						PSW[ZERO] = 1;
						PSW[CARRY] = 0;
					end
					else 
					begin
						PSW[ZERO] = 0;
						PSW[CARRY] = 1;
					end				

					if(result[15-data_type*8])
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

					if(result[15:0] == 16'o100000)//What for byte ?
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0;
				end

					ADC:
				begin
					result = read(instruction[5:3],instruction[2:0],data_type,SEAddress);
					result = result + PSW[CARRY];
					if(write(instruction[5:3],instruction[2:0],result,data_type))
						$display("Error during ADC instruction");

					if((~data_type &&!(result[15:0]))||(data_type &&!(result[7:0])))
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result[15:0]-PSW[CARRY] == 16'o177777 && PSW[CARRY] == 1) //For byte ?
						PSW[CARRY] = 1;
					else
						PSW[CARRY] = 0;

					if(result[15-data_type*8] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

					if(result == 16'o077777 && PSW[CARRY] == 1) //For byte ?
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0; 
				end

					SBC:
				begin
						result = read(instruction[5:3],instruction[2:0],data_type,SEAddress);
						result = result - PSW[CARRY];
					if(write(instruction[5:3],instruction[2:0],result,data_type))
						$display("Error during SBC instruction");

						if((~data_type &&!(result[15:0]))||(data_type &&!(result[7:0])))
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result+PSW[CARRY] && PSW[CARRY] == 1)
						PSW[CARRY] = 0;
					else
						PSW[CARRY] = 1;

					if(result[15-data_type*8] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

					if((result)+PSW[CARRY] == 16'o100000)//For byte ?
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0;
				end

					TST:
				begin
					result = read(instruction[5:3],instruction[2:0],data_type,SEAddress) - 0;
					if(result == 0)
						PSW[ZERO] = 1;
					else
						PSW[ZERO] = 0;

					if(result[15] == 1)
						PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;
	
				end
				
				
				//Byte implementation pending from all instructions below this.
				ROR:
				begin
			  temp = {PSW[CARRY], read(instruction[5:3],instruction[2:0],data_type,SEAddress)};
			  tempbit = temp[0];
			  temp = temp >> 1;
			  PSW[CARRY] = tempbit;
			  if(write(instruction[5:3],instruction[2:0],temp[15:0],data_type))
			    $display("Error during ROR instruction");  
			    if(temp[15:0] == {16{1'b0}})
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(temp[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

						PSW[OVERFLOW] = PSW[NEGATIVE]^PSW[CARRY];
				end

				ROL:
				begin
				tempbit = PSW[CARRY];
			  temp = {PSW[CARRY], read(instruction[5:3],instruction[2:0],data_type,SEAddress)};
        temp = temp << 1;
        PSW[CARRY] = temp[16];
        temp[0] = tempbit;
        if(write(instruction[5:3],instruction[2:0],temp[15:0],data_type))
        $display("Error during ROL instruction");  
			    if(temp[15:0] == {16{1'b0}})
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(temp[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

						PSW[OVERFLOW] = PSW[NEGATIVE]^PSW[CARRY];
				end
				
				
				  ASR:
				begin
			   temp = {read(instruction[5:3],instruction[2:0],data_type,SEAddress), PSW[CARRY]};
			   tempbit = temp[16];
			   temp = temp >> 1;
			   PSW[CARRY] = temp[0];
			   temp[16] = tempbit;
			   if(write(instruction[5:3],instruction[2:0],temp[16:1],data_type)) 
			   $display("Error during ASR instruction");  
			    if(temp[15:0] == {16{1'b0}})
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(temp[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

						PSW[OVERFLOW] = PSW[NEGATIVE]^PSW[CARRY];
				end

					ASL:
				begin
			   temp = {PSW[CARRY], read(instruction[5:3],instruction[2:0],data_type,SEAddress)};
			   temp = temp << 1;
			   PSW[CARRY] = temp[16];
			   temp[0] = 1'b0;
			   if(write(instruction[5:3],instruction[2:0],temp[15:0],data_type))
			     $display("Error during ASL instruction");  
			    if(temp[15:0] == {16{1'b0}})
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(temp[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

						PSW[OVERFLOW] = PSW[NEGATIVE]^PSW[CARRY];
				end

					MARK:		// byte variant of this has different functionality, take note
				begin
			
				end

					MFPI:
				begin
			
				end

					MTPI:
				begin
			
				end

					SXT:
				begin
			
				end
				default:
						single_operand = 1;

			endcase

	end
endfunction

function JSR_instruction;
input [15:0]instruction;
reg [15:0]temp;
reg [15:0]result;
reg dummy;
begin
  result = effective_address(instruction[5:3],instruction[2:0],instruction[15]);
	dummy = push(R[instruction[8:6]]);
	R[instruction[8:6]] = R[PC];
	$fwrite(branch_file,"%6o %s %6o %0d\n",R[PC],"JSR",result,1);
	R[PC] = result;
	JSR_instruction=0;
end
endfunction
