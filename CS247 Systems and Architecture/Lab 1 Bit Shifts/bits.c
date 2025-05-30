/* 
 * CS:APP Data Lab 
 * 
 * Scott Felch
 * W00750298
 * user: felchs
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
/*	To start, 1 = 0...0000001. Then shifting left 31 bits will be 1...00000,
	which is the smallest number a 32-bit two's complement can hold. */
	return (1 << 31);
}

/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters 
 *   '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
	/* If X is >0x39 (the upper bound for ASCII digit) then subtracting 0x39 
	will yield a positive value. Expecting a negative value to be in range.
	If X is the same as biggest possible number then this will yield a 0 which 
	is considered a positive number in the two's complement system so subtract
	another 1 to get it negative. 
	
	Shift 31 digits to the right to test sign. 
	If it's a negative number, then this will result in all 1s being stored.
	If it's positive then it will be all 0s. 
	
	All 1s = X is too big 
	All 0s = X is not too big  */
	
	// (x + ((~0x39) + 1) is equivalent to (X - (0x39))
	// + ~0 (add complement 0) is equivalent to -1 (subtract 1)
	int too_big = ((x + ((~0x39) + 1) + ~0) >> 31) + 1;
	
	/* If X is smaller than 0x30 (the lower bound for ASCII digit) then 
	subtracting 0x30 will yield a negative value. Shift 31 digits to the 
	right to test sign. Too_small will then be 1111s if too low to be ASCII,
	or 0000s if it's an acceptable value. Bang Bang will convert to boolean. */
	
	int too_small = !!((x + (~0x30) + 1 ) >> 31);

	/* If either Too_Big or Too_Small are true, then this is not an ASCII
	value. So return the inverse of that. */
	return !(too_big | too_small);

}
/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {

	int copy_x = x;
	copy_x = (!!x);
	
	// If copy_x was 0001, left shift will make it 1000
	copy_x = copy_x << 31;
	// then shifting back right makes it 1111.
	copy_x = copy_x >> 31;
	
	/* copy_x & y will return y unmolested if copy_x was 1111, or
	0000 if copy_x was 0000s. 
	
	  If copy_x was 1111s, then flip it to 0000s and & it with z to neutralize
	  Z. If copy_x was 0000s, then flip it to 1111s and & it with z to return
	  Z's original value.  */
	return (((~copy_x) & z) | (copy_x & y));
}
/* 
 * allEvenBits - return 1 if all even-numbered bits in word set to 1
 *   Examples allEvenBits(0xFFFFFFFE) = 0, allEvenBits(0x55555555) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allEvenBits(int x) {
/*	Evens are all 0s
	Dec:	1431655765
	Bin:	01010101 01010101 01010101 01010101
	Hex:	0x55555555
*/

	/* Example:
	x = 
	Dec:	4294967294
	Bin:	11111111 11111111 11111111 11111110
	Hex:	0xFFFFFFFE
	
	x & mask = 
	Dec:	14316557640
	Bin:	00110101 01010101 01010101 01010100 1000
	Hex:	0x355555548
	
	(x & mask) ^ mask = 
	If this produces 0 then all even bits are set to 1, so the ! will flip the
	answer and return 1, that it's true all even bits are set to 1. If it 
	produces anything other than 0, then the ! will flip it to 0, indicating 
	that not all the even bits are set to 1. */ 

	int	mask = (0x55 << 24) + (0x55 << 16) + (0x55 << 8) + (0x55);
	
	
	return !((x & mask) ^ mask);
}
/* 
 * implication - return x -> y in propositional logic - 0 for false, 1
 * for true
 *   Example: implication(1,1) = 1
 *            implication(1,0) = 0
 *   Legal ops: ! ~ ^ |
 *   Max ops: 5
 *   Rating: 2
 */
int implication(int x, int y) {
    return (!x) | y;
}
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y) {
//	int result = x - y;
	// This flag is set to 0 if x-y results in anything but 0.
//	int is_zero = !(x - y);

	int x_is_neg = !!(x >> 31);
	int y_is_neg = !!(y >> 31);
	int result = x + (~y) + 1;
	
	
	/* x-y will produce an integer with a leading 1 or 0, shifting right 31 
	places will result in either 0000 (positive) or 0001 (negative). Bang bang, 
	get a flag for 0 if positive value, 1 for negative. */
	int result_is_neg = !!(result >> 31);
	
	// num1 is negative, num2 is positive, and result is positive
	int underflow = (x_is_neg & !y_is_neg) & !result_is_neg;
	
	// num1 is positive, num2 is negative, and result is negative
	int overflow = (!x_is_neg & y_is_neg) & result_is_neg;
	
//	printf("is_zero:  "); printf("%d", is_zero); printf("\n");
//	printf("is_positive:  "); printf("%d", is_positive); printf("\n");
//	printf("is_negative:  "); printf("%d", is_negative); printf("\n");
	
	// If x-y is negative or zero, return 1. Otherwise return 0.
	return ((result_is_neg + (!result) | underflow) & !overflow);
}
/* 
 * bang - Compute !x without using !
 *   Examples: bang(3) = 0, bang(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int bang(int x) {
	int invx = ~x;					//if x==0, then -1
	int negx = invx + 1;			//if x==0, then 0
	//if x was 0, then MSB is 1, so MSB>>31 & 1 = 1
	return ((~negx & invx) >> 31) & 1; 
}
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
  return 0;
}
/* 
 * byteSwap - swaps the nth byte and the mth byte
 *  Examples: byteSwap(0x12345678, 1, 3) = 0x56341278
 *            byteSwap(0xDEADBEEF, 0, 2) = 0xDEEFBEAD
 *  You may assume that 0 <= n <= 3, 0 <= m <= 3
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 25
 *  Rating: 2
 */
int byteSwap(int x, int n, int m) {
    return 2;
}
/* 
 * leastBitPos - return a mask that marks the position of the
 *               least significant 1 bit. If x == 0, return 0
 *   Example: leastBitPos(96) = 0x20
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2 
 */
int leastBitPos(int x) {
	/* Complementing X with ~X would give all 0s, except incrementing 1 
	   will highlight the right-most 1 bit. */
	return (x & (~x + 1));
}
/* 
 * logicalShift - shift x to the right by n, using a logical shift
 *   Can assume that 0 <= n <= 31
 *   Examples: logicalShift(0x87654321,4) = 0x08765432
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3 
 */
int logicalShift(int x, int n) {
	// ~0 = 1111
	// Left shift by n times, get 1100
	// ~ that and get 0011.
	// Now left shift that by 32-n bits to get mask.
	int mask = ~(~0 << n) << (32 + ((~n) + 1));

	// Shift x by n bits and & it with complement of mask for logical shift.
	return (x >> n) & ~mask;
}

/* 
 * float_neg - Return bit-level equivalent of expression -f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representations of
 *   single-precision floating point values.
 *   When argument is NaN, return argument.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 10
 *   Rating: 2
 */
unsigned float_neg(unsigned uf) {

//	int NaN_mask = (1 << 31) + (1 << 30) + (1 << 29) + (1 << 28) + (1 << 27)
//	 + (1 << 26) + (1 << 25);
	
	int nan_mask = (0x7FFFFFFF);
	int result;

	// If binary places 31-23 are 1, then this is NaN, return argument.
	if ((nan_mask & uf) > 0x7F800000) {
//		printf("A\n");
		return uf;
	}
	else {
		// Otherwise toggle the left-most bit, return value
//		printf("%f", (uf ^ (1 << 32)));
//		printf("uf:  "); printf("%d", uf); printf("\n");
		return (uf ^ (0x80000000));
//		return (uf ^ (1 << 31));
	}
}
/* 
 * float_f2i - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int float_f2i(unsigned uf) {
  return 2;
}
