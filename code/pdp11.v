/*
 Portland State University
 Maseeh College of Engineering & Computer Science
 ECE 586 Computer Architecure Winter 2014
 PDP-11/20 Instruction Set Architecture Simulator 
 by
 Sameer Ghewari   PSUID-966754851   sghewari@pdx.edu
 Sanket Borhade   PSUID-984706685   sanket@pdx.edu
 Tejas Kulkarni   PSUID-915828294		tpk2@pdx.edu          
 Eshan Kanoje     PSUID-902098678	  ekanoje@pdx.edu     
 */

module pdp11;

//Include config.v. Includes all parameters.
`include"config.v"

  
//File handles 
integer data_file;
integer scan_file,eof;
integer mem_fill_ptr;
integer trace_file;
integer branch_file;


integer i;

//String to hold input ascii file's name 
reg [8*256:0] memory_image;

reg [7:0]character;
reg [15:0]instruction;

integer instruction_count;

reg [15:0]dummy;
reg done;

//Declaration of Register File & PSW 

reg [15:0]R[7:0];
reg [15:0]PSW;

//Declaration of memory
reg [MWIDTH:0]mem[MSIZE:0];

`include"memop.v"
`include"read_word.v"
`include"write_word.v"
`include"double_operand.v"
`include"single_operand.v"
`include"branch.v"
`include"jump.v"
`include"stack_operation.v"
`include"display_functions.v"
`include"effective_address.v"



initial
begin
  
//Obtain memory image file from the command line 
if($value$plusargs("IMAGE=%s", memory_image)) 
    begin
      $display("Loading from Memory Image %0s",memory_image);
    end
else 
  begin
  $display("Error: Image Not Specified in Command Line. The syntax is: vsim -novopt pdp11 +IMAGE=<Trace To Be Run>");
  $display("Simulation Halted. Please spcecify a trace file to run.");
  $stop;
  end
  
    
 //Call to Memory Fill function. Reads specified file and copies in memory array  
    if(mem_fill(0))
      $display("Error reading memory image file");
    
//Create/Open file specified_name_trace.txt in write mode for writing trace to  
    trace_file=$fopen({memory_image,"_trace.txt"},"w");
    branch_file=$fopen({memory_image,"_branch.txt"},"w");
    

   done=0;
   instruction_count=0;
	 R[SP] = 16'o177776;
        
    while(done!=1)
    begin
      
    //Instruction Fetch
    instruction=mem_read(R[PC],word,inst);
    R[PC]=R[PC]+2;
    instruction_count=instruction_count+1;
    
    //Instruction Decode+Execute beyond here
    if(instruction==HALT)
      begin
      done=1;
    end
		else if(instruction == NOP)
		begin  					///do nothing
		end
    
  else
    begin
      
     
    case(instruction[14:12])
      
      3'b000:
      begin
        if(instruction[11])
					begin
							if(instruction[11:9] == 3'b100)
							begin
									$display("The Instruction is JSR Instruction");
									if(JSR_instruction(instruction))
										$display("Invalid Instruction");
							end
					else begin
          $display("The Instruction is of Type Single Operand Instruction");
          if(single_operand(instruction))
						$display("Invalid Instruction");
					end
					end
				else if(instruction[9:8] == 2'b00)
				begin
					if(call_Swab(instruction))
						$display("swab failed");
				end
        else
          begin
          $display("The instruction is of Type Condition Branch Instruction OR Zero Operand");
          if(Branch_instruction(instruction))
						$display("Invalid Instruction");
        end
      end
     
      
      3'b111:
      begin
        $display("The instruction is of Type 1 & 1/2 Operand Instruction\n these do not exist in PDP11/20");
      end
      
      default:
      begin
      $display("The instruction is of Type Double Operand Instruction");
      //Call function that takes care of these type of instructions
      if(double_operand(instruction))
        $display("Invalid Instruction");
            
    end
    endcase
    
     if(step)
       begin
         //call display functions here
         if(displayMemory(showMemory));
        if(displayRegister(showRegisters));
        if(displayPSW(showPSW)); 
         
         $display("Type run and hit Enter to Step");
         $stop;
       end
     end
    end
    
    if(displayMemory(showMemory));
    if(displayRegister(showRegisters));
    if(displayPSW(showPSW)); 
    end

   function call_Swab;
		input [15:0]instruction;
		reg [15:0]result;
		reg [7:0]swapingReg;
		begin
					result = read(instruction[5:3],instruction[2:0],word);
					swapingReg = result[7:0];
					result = {swapingReg,result[15:8]};
					if(write(instruction[5:3],instruction[2:0],result,word))
						$display("Error during SWAB instruction");

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
		call_Swab = 0;
				end
			
endfunction



endmodule 