/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
 
 /*	If    X != 0, return y
 	Elsif X == 0, return Z
 
 
 */ 
int conditional(int x, int y, int z) {

	int copy_x = x;
//	printf("%s", "Copy_x:  "); printf("%d", x); printf("\n");
	copy_x = (!!x);
//	printf("%s", "Copy_x, boolean:  "); printf("%d", x); printf("\n");
	
	// If copy_x was 0001, left shift will make it 1000
	copy_x = copy_x << 31;
	// then shifting back right makes it 1111.
	copy_x = copy_x >> 31;
//	printf("%s", "Copy_x, shifted:  "); printf("%d", x); printf("\n");
	
//	printf("%s", "Y:  "); printf("%d", y); printf("\n");
//	printf("%d", (copy_x & y)); printf("\n");

	/* copy_x & y will return y unmolested if copy_x was 1111, or
	0000 if copy_x was 0000s. 
	
	  If copy_x was 1111s, then flip it to 0000s and & it with z to neutralize
	  Z. If copy_x was 0000s, then flip it to 1111s and & it with z to return
	  Z's original value.  */
	return (((~copy_x) & z) | (copy_x & y));
}

int main (void) {

	int test = conditional(0, 4, 5);
	
	printf("%s", "test:  "); printf("%d", test); printf("\n");

	return 0;
}
