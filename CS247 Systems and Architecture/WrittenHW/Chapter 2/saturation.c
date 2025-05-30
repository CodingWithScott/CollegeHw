/*  Scott Felch
	W00750298
	felchs@students.wwu.edu
	20 January 2013
	HW 2.73

-------------------------------------------------------------------------------
Prompt:
	Write code for a function with the following prototype:
		// Addition that saturates to TMin or TMax
		int saturating_add(int x, int y);

	Instead of overflowing the way normal two's-complement addition does,
	saturating addition returns TMax when there would be positive overflow,
	and TMin when there would be negative overflow. Saturating arithmetic is
	commonly used in programs that perform digital signal processing.
	
	Your function should follow the bit-level integer coding rules. (p. 120)
-------------------------------------------------------------------------------
Two's-complement min and max values for 32-bit word size. Pre-defined in 
<limits.h>. See textbook p. 62 for more information

	TMin:
		Dec:	-2,147,483,648
		Bin:	10000000000000000000000000000000
		Hex:	0xFFFFFFFF
	TMax:
		Dec:    2,147,483,647
		Bin:	01111111111111111111111111111111
		Hex:	0x7FFFFFFF
		
	Dec: -1
	Bin: 11111111111111111111111111111111
	
	Dec: 0 
	Bin: 00000000000000000000000000000000
-------------------------------------------------------------------------------
       Algorithm pseudocode:
	1. Test if signs of X and Y are different
	2. Test if signs of results are different
	3. Return bits 1...1 if overflow, 0...0 if underflow, using data from
	   parts (1) and (2).
	4. Compute MAX_INT if overflow, MIN_INT if underflow, otherwise all
	   bits will be unchanged (the result).
	   MAX_INT = 01...1
	   MIN_INT = 10...0
	5. Insert the result computed in (4) into (3)
-------------------------------------------------------------------------------
		Bit logic cheat sheet: 
	OR		|
	AND		&
	NOT		~
	XOR		^
-------------------------------------------------------------------------------
*/

#include <stdio.h>
#include <limits.h> 	

// Addition that saturates to TMin or TMax
int saturating_add(int x, int y) {
	int sum;		// Sum of X and Y, will be tested for overflow
	int copy_x;		// Copy of X I can alter without losing original 
	int copy_y;		// Copy of Y I can alter without losing original 
	int copy_sum;	// Copy of Sum I can alter without losing original
	int zero_max_or_min;	/* Depending on value of overflow, will 
		store 0000s, 0111, or 1000. Will make more sense in context. */

	int same_signs_for_args = 0;	/* Flag indicates if X and Y have
	  different signs */
	int sum_sign_diff = 0;	/* Flag indicates if sum and arguments have 
	  different signs */
	int overflow = 0;	/* Flag indicating if an overflow has occurred. */
	
	copy_x = x;
	copy_y = y;
	sum = x + y;
	copy_sum = sum;

	copy_x = copy_x >> 31;	/* Arithmetic shift right by 31 (w-1) places, 
	entire 	integer will now be repetitions of what the sign bit was. */ 
	copy_y = copy_y >> 31;	/* Can now compare copy_x and copy_y to see if they 
		are	the same sign. */
	copy_sum = copy_sum >> 31; /* Same as above, can now see sign of sum. */
	
	/* XOR of the signs of X and Y will result in 0000s if both X and Y
	  were positive or both negative. Will result in 1111s if X and Y
	  had different signs. Complement of that will result in 1111s for
	  X and Y having same sign, 0000s for different signs. */
	same_signs_for_args = ~(copy_x ^ copy_y);

	/* XOR returning 1111s if the signs of X and the sign of the sum are the 
	   same. */
	sum_sign_diff = (copy_x ^ copy_sum);
	
	/* If arguments have same sign, and different sign than the sum, overflow
	   has occurred. */
	overflow = same_signs_for_args & sum_sign_diff;
	
	/* If X was +, this will result in zero_max_or_min storing 0111. If
	   X was -, this will result in zero_max_or_min storing 1000. */
	zero_max_or_min = copy_x ^ INT_MAX;
	
	/* (sum & ~overflow) will result in 0 if there was an overflow, 
	   or original value of sum if there was no overflow.
	   zero_max_or_min & overflow
       (zero_max_or_min & overflow) will result in 0 if no overflow
	   occurred, or TMax or Tmix if an overflow did occur. 
	   Add the two parts together and you'll get either 
	   TMax + 0, TMin + 0, or 0 + Original Sum. */
	sum = (zero_max_or_min & overflow) + (sum & ~(overflow)); 
	
	return sum;	
}

int main(void) {

	int total = 0;	/* This will be used to hold the the values that
	 could potentially overflow a standard 32-bit two's complement integer. */
	int num1, num2;
	
//	printf("Int_min:  "); printf("%d", INT_MIN); printf("\n");
//	printf("Int_max:   "); printf("%d", INT_MAX); printf("\n");

	printf("We're going to add two large numbers together.\n");
	printf("1st number:    5"); printf("\n");
	num1 = 5;
	printf("2nd number:    6"); printf("\n");
	num2 = 6;

	total = saturating_add(INT_MAX, INT_MAX);
	printf("Total:  "); printf("%d", total); printf("\n");	

	return (0);
}
