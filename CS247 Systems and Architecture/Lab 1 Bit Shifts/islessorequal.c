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
//	int result = x-y;
	int result = x + (~y) + 1;
	
	printf("x is negative:  "); printf("%d", x_is_neg); printf("\n");
	printf("y is negative:  "); printf("%d", y_is_neg); printf("\n");
	
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


int main(void) {

	int num1 = -2147483647;
	int num2 = 2147483647;
	
	int test = isLessOrEqual(num1, num2);
	
	if (test == 0) {
		printf("%d", num1); printf("%s", "  is > "); printf("%d", num2); printf("\n");
	}
	else if (test == 1) {
		printf("%d", num1); printf("%s", "  is <= "); printf("%d", num2); printf("\n");
	}
	
	return 0;
}
