//This function handles instruction of type Double Operand 

function single_operand;
  input[15:0]instruction;
	reg [15:0]result;
	reg [17:0]temp;
	reg [7:0]swapingReg;
	reg tempbit;

	begin
		single_operand = 0;
			case(instruction[10:6])
				SWAB:
				begin
					result = read_word(instruction[5:3],instruction[2:0]);
					swapingReg = result[7:0];
					result = {swapingReg,result[15:8]};
					if(write_word(instruction[5:3],instruction[2:0],result))
						$display("Error during CLR instruction");

					if(result[7:0] == 0)
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result[7] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

						PSW[OVERFLOW] = 0;
						PSW[CARRY] = 0;
				end
				CLR:
				begin
					if(write_word(instruction[5:3],instruction[2:0],0))
						$display("Error during CLR instruction");
					PSW[CARRY] = 0;
					PSW[OVERFLOW] = 0;
          PSW[ZERO] = 1;
          PSW[NEGATIVE] = 0;
				end
				COM:
				begin
					//$display("%b",~read_word(instruction[5:3],instruction[2:0]));
					result = ~read_word(instruction[5:3],instruction[2:0]);
					if(write_word(instruction[5:3],instruction[2:0],result))
						$display("Error during COM instruction");

					if(result == 0)
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

						PSW[OVERFLOW] = 0;
						PSW[CARRY] = 1;
				end
					INC:
				begin
					//$display("%b :::::::::: %o",read_word(instruction[5:3],instruction[2:0]),15'o77777);
					result = read_word(instruction[5:3],instruction[2:0]);
					if(write_word(instruction[5:3],instruction[2:0],result+1))
						$display("Error during INC instruction");

					if((result+1) == 0)
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result == 16'o077777)
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0;

					if(result[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

				end

					DEC:
				begin
					//$display("%b",read_word(instruction[5:3],instruction[2:0]));
					result = read_word(instruction[5:3],instruction[2:0]);
					if(write_word(instruction[5:3],instruction[2:0],result-1))
						$display("Error during DEC instruction");

					if((result-1) == 0)
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result == 16'o100000)
						PSW[CARRY] = 1;
					else
						PSW[CARRY] = 0;

					if(result[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;
				end

					NEG:
				begin
					//$display("%b",~read_word(instruction[5:3],instruction[2:0]));
					result = -(read_word(instruction[5:3],instruction[2:0]));
					if(write_word(instruction[5:3],instruction[2:0],result))
						$display("Error during NEG instruction");
					
					if(result == 0)
					begin
						PSW[ZERO] = 1;
						PSW[CARRY] = 0;
					end
					else 
					begin
						PSW[ZERO] = 0;
						PSW[CARRY] = 1;
					end				

					if(result[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

					if(result == 16'o100000)
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0;
				end

					ADC:
				begin
					result = read_word(instruction[5:3],instruction[2:0]);
					if(write_word(instruction[5:3],instruction[2:0], result + PSW[CARRY]))
						$display("Error during ADC instruction");

					if((result + PSW[CARRY]) == 0)
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result == 16'o177777 && PSW[CARRY] == 1)
						PSW[CARRY] = 1;
					else
						PSW[CARRY] = 0;

					if(result[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

					if(result == 16'o077777 && PSW[CARRY] == 1)
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0; 
				end

					SBC:
				begin
						result = read_word(instruction[5:3],instruction[2:0]);
					if(write_word(instruction[5:3],instruction[2:0],result - PSW[CARRY]))
						$display("Error during SBC instruction");

						if((result - PSW[CARRY]) == 0)
						PSW[ZERO] = 1;
					else 
						PSW[ZERO] = 0;

					if(result == 0 && PSW[CARRY] == 1)
						PSW[CARRY] = 0;
					else
						PSW[CARRY] = 1;

					if(result[15] == 1)
          	PSW[NEGATIVE] = 1;
					else
						PSW[NEGATIVE] = 0;

					if((result - PSW[CARRY]) == 16'o100000)
						PSW[OVERFLOW] = 1;
					else
						PSW[OVERFLOW] = 0;
				end

					TST:
				begin
					//if(write_word(instruction[5:3],instruction[2:0],read_word(instruction[5:3],instruction[2:0])))
					//	$display("Error during COM instruction");
				end
				ROR:
				begin
			  temp = {PSW[CARRY], read_word(instruction[5:3],instruction[2:0])};
			  tempbit = temp[0];
			  temp = temp >> 1;
			  PSW[CARRY] = tempbit;
			  if(write_word(instruction[5:3],instruction[2:0],temp[15:0]))
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
			  temp = {PSW[CARRY], read_word(instruction[5:3],instruction[2:0])};
        temp = temp << 1;
        PSW[CARRY] = temp[16];
        temp[0] = tempbit;
        if(write_word(instruction[5:3],instruction[2:0],temp[15:0]))
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
			   temp = {read_word(instruction[5:3],instruction[2:0]), PSW[CARRY]};
			   tempbit = temp[15];
			   temp = temp >> 1;
			   PSW[CARRY] = temp[0];
			   temp[16] = tempbit;
			   if(write_word(instruction[5:3],instruction[2:0],temp[16:1]))  
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
			   temp = {PSW[CARRY], read_word(instruction[5:3],instruction[2:0])};
			   temp = temp << 1;
			   PSW[CARRY] = temp[16];
			   temp[0] = 1'b0;
			   if(write_word(instruction[5:3],instruction[2:0],temp[15:0]))
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
begin
	temp = instruction[5:0];
	result = read_word(instruction[5:3],instruction[2:0]);
	//push(read_word(0,instruction[8:6]));
	R[instruction[8:6]] = R[PC];
	R[PC] = temp;
	JSR_instruction = 0;
end
endfunction
