# autovelox
basic autovelox in mips

comandi Mips per principianti:
	1	add $t0, $t1, $t2 - Adds the contents of register $t1 and $t2 and stores the result in register $t0.
	2	sub $t0, $t1, $t2 - Subtracts the contents of register $t2 from the contents of register $t1 and stores the result in register $t0.
	3	and $t0, $t1, $t2 - Performs a bitwise AND operation on the contents of register $t1 and $t2 and stores the result in register $t0.
	4	or $t0, $t1, $t2 - Performs a bitwise OR operation on the contents of register $t1 and $t2 and stores the result in register $t0.
	5	xor $t0, $t1, $t2 - Performs a bitwise XOR operation on the contents of register $t1 and $t2 and stores the result in register $t0.
	6	slt $t0, $t1, $t2 - Sets register $t0 to 1 if the contents of register $t1 is less than the contents of register $t2, otherwise it is set to 0.
	7	sltu $t0, $t1, $t2 - Sets register $t0 to 1 if the contents of register $t1 is less than (unsigned) the contents of register $t2, otherwise it is set to 0.
	8	sll $t0, $t1, 5 - Shifts the contents of register $t1 to the left by 5 bits and stores the result in register $t0.
	9	srl $t0, $t1, 5 - Shifts the contents of register $t1 to the right by 5 bits and stores the result in register $t0.
	10	sra $t0, $t1, 5 - Shifts the contents of register $t1 to the right by 5 bits, preserving the sign bit, and stores the result in register $t0.
	11	lui $t0, 0x1234 - Loads the upper 16 bits of the immediate value 0x1234 into register $t0.
	12	ori $t0, $t1, 0x1234 - Performs a bitwise OR operation between the contents of register $t1 and the immediate value 0x1234 and stores the result in register $t0.
	13	andi $t0, $t1, 0x1234 - Performs a bitwise AND operation between the contents of register $t1 and the immediate value 0x1234 (which is sign-extended) and stores the result in register $t0.
	14	xori $t0, $t1, 0x1234 - Performs a bitwise XOR operation between the contents of register $t1 and the immediate value 0x1234 (which is sign-extended) and stores the result in register $t0.
	15	lw $t0, 0($t1) - Loads a word (4 bytes) from memory location pointed to by register $t1 and stores it in register $t0.
	16	sw $t0, 0($t1) - Stores the contents of register $t0 into the memory location pointed to by register $t1.
	17	beq $t0, $t1, label - If the contents of register $t0 is equal to the contents of register $t1, branches to the instruction at label.
	18	bne $t0, $t1, label - If the contents of register $t0 is not equal to the contents of register $t1, branches to the instruction at label.
	19	j label - Unconditionally jumps to the instruction at label.
	20	jal label - Jumps to the instruction at label and saves the return address in the `.
