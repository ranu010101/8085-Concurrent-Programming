;                                   INTRODUCTION


;             TITLE:   Concurrent Programming on 8085 Series of Processors by INTEL

;           PURPOSE: Project assigned as part of CS321(Computer Peripherals and Interfacing Lab)
;           AUTHORS: Rishi Sharma(120101060), Parag Gangil(120101048), Namaba Jamir(120101044),
;                    Mohit(120101041), Ranu Vikram(120101057)
;           CONTACT: s.rishi, g.parag, namaba, mohit2012, v.ranu (Webmail ids)
;
;---------------------------------------------------------------------------------------------------
;                                   DETAILS 
;                                   
;           
;           ALGORITHM(S) EMPLOYED: Round-Robin Scheduling
;
;
;---------------------------------------------------------------------------------------------------
;                                   MEMORY MANAGEMENT
;
;
; 			Memory Layout
;
;			8000H		____
;			|	 |			|  3984 Bytes of memory.
;			|	 |			|  (Reserved for Main program, User program's addresses)
;			|	 |		____|
;			8F8FH
;			.	 .		____  
;			.	 .		____|	Memory utilized by system.
;			9000H		____
;			|	 |			|  28761 Bytes of memory.
;			|	 |			|  (User programs and their stacks)
;			|	 |			|
;			|	 |		____|
;			FFFFH
;
;			9000H - 9017H      Array of program addresses
;			9018H			   Pointer to array (Only LSB as MSB is always 90H)
;			9019H - 9400H	   Stack for Process 1
;			9401H - 97E8H	   Stack for Process 2
;			97E9H - 9BD0H	   Stack for Process 3
;			9BD1H - 9FB8H	   Stack for Process 4
;			9FB9H - A3A0H	   Stack for Process 5
;			A3A1H - A788H	   Stack for Process 6
;			A789H - A794H	   Queue of running processes
;			A795H			   Enqueue pointer (Only LSB as MSB is always A7)
;			A796H			   Dequeue pointer (Only LSB as MSB is always A7)
;			A797H			   Main program stack pointer LSB
;			A798H 			   Main program stack pointer MSB
;			A799H			   Running processes count
;
;
;			STACK ORGANIZTION
;
;			|__BC___|
;			|__DE___|
;			|__HL___|
;			|__PSW__|
;			|__PC___|
;			| USER	|
;			|_SPACE_|
;
;---------------------------------------------------------------------------------------------------
;
;                                   ASM CODE

CPU "8085.TBL"
HOF "INT8"

ORG 8000H
JMP MAINPROG

; INIT SUB-ROUTINE FOR INITIALIZING BOTH STACK AND QUEUE MEMORY LOCATIONS
; STACK STORES ALL PROGRAMS TO BE RUN AND QUEUE REPRESENTS RUNNING QUEUE

INIT:NOP         
	CALL STACK_INIT
	CALL QUEUE_INIT
	RET

QUEUE_INIT:NOP
	LXI D,8400H
	LXI B,03E8H
	LXI H,0A789H




STACK_INIT:NOP	   ; Fills the stack PC with starting address of programs and rest all zeroes. 
	LHLD 9018H     ; Load content of array[0] & array[1] in HL reg. pair
	MVI H,90H      ; Because only LSB is stored in 8018 and MSB is always 90H
	LXI D,9401H    ; Stack pointer to the first stack (initially to -1 level)
	LXI B,03E8H	   ; Hex value of 1000 to be added to stack pointer to get to next stack
	JMP WHILE1
	PUSH_STACK:NOP ; Push the PC for process into its stack
		
		MOV B,H  		;
		MOV C,L 		; Storing the main program SP 
		LXI H,0H 		; to 9797H and 9798H
		DAD SP 			;
		SHLD 0A797H 	;
		MOV H,B  		;
		MOV L,C 		;

		MOV C,M 		;
		INX H 			; Move the contents of array to BC reg. pair
		MOV B,M 		;
		
		XCHG	        ; 
		SPHL 			;
		PUSH B 			; Push the starting address of the program and 
		LXI B,0H 		; then its registers values all intialized to zero.
		PUSH B 			; 
		PUSH B 			;
		PUSH B 			;
		PUSH B 			;
		
		MOV B,H         ;
		MOV C,L    		; Restore the main program stack pointer.
		LHLD 0A797H 	; 
		SPHL 			;
		MOV H,B 		;
		MOV L,C 		;
		
		LXI B,03E8H 	; 
		DAD B 			; Increment the stack pointer by 1000 (03E8H) to point
		XCHG 			; to next stack base. And increase the array pointer to
		INX H 			; point to next program's address.
		RET 			;

	WHILE1:NOP
		LDA 0A799H
		INR A
		STA 0A799H
		CALL PUSH_STACK
		MOV A,L 	 	;
		STA 9018H	 	;
		CPI 0CH  	 	; Check if we have filled the queue fully
		RZ			 	;
		MOV A,M 	 	;
		CPI 0H  	 	; Or if all the programs have been loaded by checking
		JZ ENDIT    	; the memory content.
	JMP WHILE1

	ENDIT:NOP   ; Sub routine to load 0000H to the useless stacks
		XCHG
		DCX H
		WHILE2:NOP
		MVI M,0H
		MOV A,L
		CPI 88H
		RZ
		DAD B
		JMP WHILE2







MAINPROG:NOP
LXI H,0FFFFH
SPHL
MVI A,00H
STA 9018H
STA 0A799H
CALL INIT
RST 5
