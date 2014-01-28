//Memory Read/Write functions



//This function reads a byte from specified address from the memory 

function mem_fill;
  input dummy;
  
  begin
    mem_fill=0;
    data_file=$fopen(memory_image,"r");
    
     eof=$feof(data_file);
     mem_fill_ptr=0;
    
    while(!eof)
  begin
      
    scan_file=$fscanf(data_file,"%c%o\n",character,instruction);
    $display("character : %c instruction : %o",character,instruction);
    eof=$feof(data_file);
   R[PC]=0;
    
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


function [7:0]mem_read;
  input [15:0]address;
  input Instruction_Read;
  
  begin
    mem_read=mem[address];
    
    //Trace generation 
      if(Instruction_Read)
      $fwrite(trace_file,"%0d %6o\n",2,address);
    else
      $fwrite(trace_file,"%0d %6o\n",0,address);

  end
  
endfunction
  
  
function mem_write;
  input [15:0]address;
  input [7:0]data;
  
  begin
    
    mem[address]=data;
      
    $fwrite(trace_file,"%0d %6o\n",1,address);
	mem_write = 1;
  end
  
endfunction