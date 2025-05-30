/* 
 * logicalShift - shift x to the right by n, using a logical shift
 *   Can assume that 0 <= n <= 31
 *   Examples: logicalShift(0x87654321,4) = 0x08765432
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3 
 */
 
 
 void int_to_bin(int num) {
  char str[9] = {0};
  int i;
  for (i=31; i>=0; i--) {
    str[i] = (num&1)?'1':'0';
    num >>= 1;
  }
  printf("%s\n", str);
}

 
int logicalShift(int x, int n) {

	
//	int mask= ~(1<<31)>>(n+(~1+1));
//	int mask= ~(1<<31) >> (n);
//	int mask= (1<<31) >> (n);


	// ~0 = 1111
	// Left shift by n times, get 1100
	// ~ that and get 0011, will use for mask.
	
	// need to shift by 32 - n 
//	printf("32 - n:  "); printf("%d", (32 + ((~n) + 1))); printf("\n");
	int mask = ~(~0 << n) << (32 + ((~n) + 1));
	
//	printf("%s", "Mask:  "); 	printf("%d", mask); printf("\n");
//	printf("%s", "(~1):  "); 
//	printf("%d", (~1)); printf("\n"); 
//	printf("%s", "(~1+1):  "); 
//	printf("%d", (~1+1)); printf("\n"); 
//	printf("%d", ~(1<<31)); printf("\n");
//	int_to_bin(~(1<<31)>>(n+(~1+1)));


	// Now it's dropping the negative sign when I put in a negative value,
	// what do?
	return (x >> n) & ~mask;
}


int main(void) {

//	int test = logicalShift(64, 16);
//printf("%s", "Test:  "); printf("%d", test); printf("\n");
//	printf("%s", "(~1)    "); printf("%d", (~1)); printf("\n");
//	printf("%s", "(~1+1)    "); printf("%d", (~1+1)); printf("\n");
//	printf("%s", "(1<<31)   "); printf("%d", (1<<31)); printf("\n");
//	printf("%s", "~(1<<31)  "); printf("%d", ~(1<<31)); printf("\n");
//	printf("%s", "~(1<<31) >> (n -1)  "); 
//		printf("%d", ~(1<<31) >> (3)); printf("\n");
		
//	printf("%s", "logicalShift(64, 4):  "); printf("%d", logicalShift(64, 4)); 
//	printf("\n");
//	printf("%s", "Standard shift 64 >> 4:    ");	
//	printf("%d", 64 >> 4); printf("\n");
	
	printf("%s", "logicalShift(-128, 4):  "); printf("%d", logicalShift(-128, 4)); 
	printf("\n");
	printf("%s", "Standard shift -128 >> 4:    ");	
	printf("%d", -128 >> 4); printf("\n");

	return 0;
}
