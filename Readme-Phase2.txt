Readme for Phase-2 Evaluation

1. Memory Layout

		8000H	____
		|   |	    |  3984 Bytes of memory.
		|   |	    |  (Reserved for Main program, Running Queue)
		|   |	____|
		8F8FH
		.   .	____  
		.   .	____|	Memory utilized by system.
		9000H	____
		|   |	    |  28761 Bytes of memory.
		|   |	    |  (User programs and their stacks)
		|   |	    |
		|   |	____|
		FFFFH

2. A main program will be loaded into the memory first and then the user programs. Main program's
   execution will be started first which will initiate the execution of other programs.

3. Programs will be executed in Pre-Emptive Round-Robin fashion. Processes will be alloted time slices
   in round-robin. Upon completion of a time slice, current process will be paused and next process will
   continue its execution.

4. Starting addresses of the input programs will maintained in an array ("Programs array").

5. There can be 6 processes running concurrently. However, user can give more than 6 programs as
   input but only 6 will run concurrently.

6. A queue ("running queue") will be managed of running processes. The running queue will contain the 
   stack pointers of processes. After the completion of given time slice of a process, that process will
   be enqueued to the queue. However if a process is finished, it won't be enqueued and a new program 
   will be brought into the running queue if available in programs array.

7. Context switch (or Process switch) will be implemented through timer based interrupts. Timer's out
   signal will be latched to the external signal for RST7.5 (or any other maskable interrupt). On board 
   timer will be programmed to a specific interval and upon completion, an interrupt will be generated. 
   In the Interrupt Service Routine, we will write the code for context switching and reprogramming the timer.

8. Context Switching :- Each process will be given a stack of a fixed size (yet to be determined). 
   Context switch will be implemented by pushing the pair of registers (BC, DE & HL), PSW and Program 
   counter into running process' stack. If the process isn't finished, it will be enqueued back to the 
   running queue, otherwise not. A process will be dequeued and the Stack pointer of 8085 will be made 
   to point to the dequeued process' stack pointer. Timer will be reprogrammed. Registers, flags and 
   program counter will be restored from the dequeued process' stack. Henceforth, the dequeued process 
   will continue execution.

9.The code for context switching has been written but without pre-emption.
