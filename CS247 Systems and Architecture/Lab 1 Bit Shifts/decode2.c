/*  Scott Felch
	W00750298
	felchs@students.wwu.edu
	28 January 2013
	HW 3.54

Prompt:
	A function wtih prototype
		int decode2(int x, int y, int z);
	is compiled into IA32 assembly code. The body of the code is as follows:

		x at %ebp+8, y at %ebp+12, z at %ebp+16
		---------------------------------------
		movl	12(%ebp), 	%edx
		subl	16(%ebp), 	%edx
		movl 	%edx, 		%eax
		sall 	$31, 		%eax
		sarl	$31,		%eax
		imull	8(%ebp),	%edx
		xorl	%edx, 		%eax

	Parameters x, y, and z are stored at memory locations with offsets 8, 12,
	and 16 relative to the address in register %ebp. The code stres the return
	value in register %eax.
	
	Write C code for decode2 that will have an effect equivalent to our 
	assembly code.	

	See p. 179 for more info on integer arithmetic operations.
*/

int decode2(int x, int y, int z) {

	/* I used "edx" and "eax" as variable names, just copying the assembly 
	code provided. When actually compiled the registers are different, and 
	memory offsets are slightly different as well. */

	int edx = y - z;
	int eax = edx;
	
	eax = eax << 31;
	eax = eax >> 31;
			
	eax = eax * x;
	
	eax = edx ^ eax;
	
	/* If the return statement isn't added then no code is generated at all
	by the "optimizing" compiler. */
	return eax;

}

int main(void) {

	int blah = decode2(1, 2, 3);
	
	return 0;
}
