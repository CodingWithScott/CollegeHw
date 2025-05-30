/*  Scott Felch
	W00750298
	felchs@students.wwu.edu
	2 February 2013
	HW 3.56
	
	Consider the following assembly code:
	
	x at %ebp+8, n at %ebp+12
	
	movl	8(%ebp),	%esi		Take X passed in, store in %esi
	movl	12(%ebp),	%ebx		Take N passed in, store in %ebx
	movl	$-1,		%edi		Store -1 (used for Result) in %edi
	movl	$1,			%edx		Store 1 (used for Mask) in %edx
.L2:									Enter loop
	movl	%edx,		%eax		Move Mask to %eax
	andl	%esi,		%eax		x AND Mask, store in %eax
	xorl	%eax,		%edi		Mask XOR Result, store in mask
	movl	%ebx,		%ecx		Move N to %ecx
	sall	%cl,		%edx		Shift mask left by (LSB of N) bytes
	testl	%edx,		%edx		Test if Mask == 0 
jne		.L2							Check, if mask != 0 goto .L2
	movl	%edi,		%eax		Return value in %edi to %eax as Result
	
	A. Which registers hold the program values x, n, result, and mask? 
	B. What are the initial values of result and mask? 
	C. What is the test condition for mask?
	D. How does mask get updated?
	E. How does result get updated?
	F. Fill in all the missing parts of C code.
	
	(pretend I put the C code from the book here, will do it later)	*/
	
	
/*	My answers:
	
	A. 	Initial register locations:
		---------------------------
			x:		%esi		
	   		n:		%ebp		
	   result:		%edi		
         mask:		%edx		
         
    B. Initial values:
       -----------------------------
     	result:		-1
          mask: 	 1
          
    C. Test condition for mask:
       -----------------------------
       mask != 0
      
	D. Mask gets updated:
	   -----------------------------
	   Shifted N bits to the left every time going through the loop.
	   
	E. Result gets updated:
	   -----------------------------
	   Result is XORed with (mask & x) each time through the loop.
	   
	F. Fill in the all the missing parts of the C code. 
	   ------------------------------------------------
	   See below.
	*/ 
	
int loop(int x, int n) {
	int result = 1;
	int mask;
	for (mask = -1; mask != 0; mask <<= n) {
		result ^= (mask & x);
	}
	
	return result;
}
