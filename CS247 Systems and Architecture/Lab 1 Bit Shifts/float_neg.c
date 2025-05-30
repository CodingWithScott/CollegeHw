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
	
	int nan_mask = (0x7F800000);
	int result;

	// If binary places 31-23 are 1, then this is NaN, return argument.
	if ((nan_mask & uf) == nan_mask) {
		printf("A\n");
		return uf;
	}
	else {
		// Otherwise toggle the left-most bit, return value
//		printf("%f", (uf ^ (1 << 32)));
		printf("uf:  "); printf("%d", uf); printf("\n");
		return (uf ^ (0x80000000));
//		return (uf ^ (1 << 31));
	}
}

int main(void) {
	
	float number = 1.0;
	float test = float_neg(number);
	
	printf("test = "); printf("%f", test); printf("\n");

	return 0;
}
