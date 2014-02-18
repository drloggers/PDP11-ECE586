// Parameters

//Debug Options
//Setting debug high does a memory fill upon initialization with its own index
parameter debug=0,
          step=0;

parameter showPSW = 1,
          showRegisters = 1,
          showMemory = 1,
          instruction_type = 0;


//Parameters of PSW
parameter CARRY=0,
          OVERFLOW=1,
          ZERO=2,
          NEGATIVE=3,
          TRAP=4;
          
parameter PC=7,
          SP=6;
 
 //Memory Parameters         
parameter MWIDTH=7,
          MSIZE=(64*1024)-1;          
          
           
//Parameter for HALT instruction

parameter HALT  =  16'o000000,
					NOP 	 =  16'o000240;          
//Parameters of MODE 

parameter REGISTER               = 3'b000,
          REGISTER_DEFERRED      = 3'b001,
          AUTOINCREMENT          = 3'b010,
          AUTOINCREMENT_DEFERRED = 3'b011,
          AUTODECREMENT          = 3'b100,
          AUTODECREMENT_DEFERRED = 3'b101,
          INDEX                  = 3'b110,
          INDEX_DEFERRED         = 3'b111;
                
                
//Parameters of Double Operand Instructions & one and half operand instruction 
parameter MOV  = 3'b001,
          CMP  = 3'b010,
          BIT  = 3'b011,
          BIC  = 3'b100,
          BIS  = 3'b101,
          ADD  = 3'b110,
          SUB  = 3'b110;
          
// Parameters for branch instruction 

parameter BR  = 4'b0001,
          BNE = 4'b0010,
          BEQ = 4'b0011,
          BPL = 4'b1000,
          BMI = 4'b1001,
          BVC = 4'b1100,
          BVS = 4'b1101,
          BCC = 4'b1110,
          BLO = 4'b1111,
          BGE = 4'b0100,
          BLT = 4'b0101,
          BGT = 4'b0110,
          BLE = 4'b0111,
          BHI = 4'b1010,
          BLOS= 4'b1011;
          

// Parameters for Jump instruction
parameter JMP = 3'b001,
					RTS = 3'b010;

//Parameters of Single Operand Instructions

//SWAB is added as seperate function due to conflict with branch instruction
parameter CLR  = 5'b01000,
					COM  = 5'b01001,
					INC  = 5'b01010,
					DEC  = 5'b01011,
					NEG  = 5'b01100,
					ADC  = 5'b01101,
					SBC  = 5'b01110,
					TST  = 5'b01111,
          ROR	 = 5'b10000,
					ROL	 = 5'b10001,
				  ASR  = 5'b10010,
					ASL  = 5'b10011,
					MARK = 5'b10100,		// byte variant of this has different functionality, take note
					MFPI = 5'b10101,
					MTPI = 5'b10110,
					SXT	 = 5'b10111;
					
// Conditional Codes
parameter  	CLC = 16'o000241,
          	 CLV = 16'o000242,
          	 CLZ = 16'o000244,
         		 CLN = 16'o000250,
         	 	SEC = 16'o000261,
         	 	SEV = 16'o000262,
          	 SEZ = 16'o000264,
         	 	SEN = 16'o000270;
         	 	
         	 	
//Parameters for read memory functions
parameter word=0,
          byte=1,
          inst=1,
          data=0;     
          
parameter instruction_fetch=2,
          data_read = 0,
          data_write =1;              	 	

