/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
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

int main(void) {

	int test = isAsciiDigit(60);
	
	if (test == 1) {
		printf("%s", "That number is an ASCII digit"); printf("\n"); 
	}
	else if (test == 0) {
		printf("%s", "That number is not an ASCII digit"); printf("\n");
	}
	


	return 0;
}
