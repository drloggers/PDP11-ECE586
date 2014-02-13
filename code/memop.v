//Memory Read/Write functions



//This function reads a byte from specified address from the memory 

function mem_fill;
  input dummy;
  
  begin
    mem_fill=0;
    data_file=$fopen(memory_image,"r");
    
     eof=$feof(data_file);
     mem_fill_ptr=0;
     R[PC]=0;

    while(!eof)
  begin
      
    scan_file=$fscanf(data_file,"%c%o\n",character,instruction);
    eof=$feof(data_file);
   
    
    if(character == "@")
      begin
          mem_fill_ptr=instruction;
      end
      
    else
      if(character =="*")
        R[PC]=instruction;
      
    else
      begin
      {mem[mem_fill_ptr+1],mem[mem_fill_ptr]}=instruction;
      mem_fill_ptr=mem_fill_ptr+2;
    end
  end
  $fclose(data_file);
  
  end
endfunction


function [15:0]mem_read;
  input [15:0]address;
  input byte_read;
  input Instruction_Read;

  reg [15:0]result;
  
  begin
    
    if(!byte_read & address[0])
      $display("Error Alignment. Expected word aligned address but obtained  non-word aligned address %o",address);
      
      
    if(byte_read)  
      begin
      
	result = mem[address];
		if (result[7:0] === {8{1'bx}})
			$display("Warning : Read access from a memory location %6o that was never written",address);
		else
		begin
    mem_read=result;
      
      if(Instruction_Read)
        $display("Fatal Error: Instruction read CAN'T be a byte read");
        
        $fwrite(trace_file,"%0d %6o\n",data_read,address);
      end
end
  else
    begin
      result={mem[address+1],mem[address]};
      if (result === {16{1'bx}})
			$display("Warning : Read access from a memory location %6o that was never written",address);
			
    
    
    
    //Trace generation 
      if(Instruction_Read)
        begin
      $fwrite(trace_file,"%0d %6o\n%0d %6o\n",instruction_fetch,address,instruction_fetch,address+1);
        end
    else
      $fwrite(trace_file,"%0d %6o\n%0d %6o\n",data_read,address,data_read,address+1);
      
      mem_read=result;
    end

  end
  
endfunction

  
  
function mem_write;
  input [15:0]address;
  input [15:0]data;
  input byte_write;
  
  begin
    
    if(!byte_write & address[0])
      $display("Error in Alignment during Write. Expected word aligned address but obtained %o",address);
      
    if(byte_write)  
    begin
     mem[address]=data;
     $fwrite(trace_file,"%0d %6o\n",data_write,address);
    end
  else
    begin
       {mem[address+1],mem[address]}=data;
       $fwrite(trace_file,"%0d %6o\n%0d %6o\n",data_write,address,data_write,address+1);
    end
    
   
	mem_write = 0;
  end
  
endfunction