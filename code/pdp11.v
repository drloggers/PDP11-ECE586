module pdp11;

`include"config.v"
  
  
integer data_file;
integer scan_file,eof;
integer mem_fill_ptr;
integer trace_file;
integer branch_file;

integer i;

reg [8*256:0] memory_image;

reg [7:0]character;
reg [15:0]instruction;
integer instruction_count;

reg [15:0]dummy;
reg done;

//Declaration of Register File & PSW 

reg [15:0]R[7:0];
reg [15:0]PSW;
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
  
    if(debug)
      begin
        for(i=0;i<=(MSIZE);i=i+1)
        mem[i]=i;
      end

 //Call to Memory Fill function. Reads specified file and copies in memory array  
    if(mem_fill(0))
      $display("Error reading memory image file");
    
//Create/Open file specified_name_trace.txt in write mode for writing trace to  
    trace_file=$fopen({memory_image,"_trace.txt"},"w");
    branch_file=$fopen({memory_image,"_branch.txt"},"w");
//Execution starts here
   done=0;
    
    while(done!=1)
    begin
      
      //Instruction Fetch
    instruction=mem_read(R[PC],word,inst);
    R[PC]=R[PC]+2;
    
    //Instruction Decode+Execute beyond here
    if(instruction==HALT)
      done=1;
      
      
    case(instruction[14:12])
      
      3'b000:
      begin
        if(instruction[11])
					begin
							if(instruction[11:9] == 3'b100)
							begin
									$display("The Instruction is JSR Instruction");
									if(JSR_instruction(instruction))
										$display("");$display("Invalid Instruction");
							end
					else begin
          $display("The Instruction is of Type Single Operand Instruction");
          if(single_operand(instruction))
						$display("Invalid Instruction");
					end
					end
				else if(instruction[8:6] == 3'b011)
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
        $display("The instruction is of Type 1 & 1/2 Operand Instruction");
      end
      
      default:
      begin
      $display("The instruction is of Type Double Operand Instruction");
      //Call function that takes care of these type of instructions
      if(double_operand(instruction))
        $display("Invalid Instruction");
            
    end
    endcase
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
					result = read_word(instruction[5:3],instruction[2:0]);
					swapingReg = result[7:0];
					result = {swapingReg,result[15:8]};
					if(write_word(instruction[5:3],instruction[2:0],result))
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