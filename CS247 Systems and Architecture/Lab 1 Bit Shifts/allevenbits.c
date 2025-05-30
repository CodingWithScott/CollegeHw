/* Test program for allEvenBits
  Returns 1 if all even-numbered bits are set to 1, odd bits can 
  be either 0 or 1.
  
  Max operations: 12
  Legal ops: ! ~ & ^ | + << >>
*/

int allEvenBits(int x) {
	/* Test values:
	-------------------------------------------
	Dec:	2863311530
	Bin:	10101010 10101010 10101010 10101010
	Hex:	0xAAAAAAAA

	Evens are all 1s	
	Dec:	4294967294
	Bin:	11111111 11111111 11111111 11111110
	Hex:	0xFFFFFFFE
	
	Evens are all 0s
	Dec:	1431655765
	Bin:	01010101 01010101 01010101 01010101
	Hex:	0x55555555
	*/

//	int mask = 1431655765;
	int	mask = (0x55 << 24) + (0x55 << 16) + (0x55 << 8) + (0x55);
//	printf("mask = "); printf("%d", mask); printf("\n");


	printf("%i", !((x & mask) ^ mask));

	return !((x & mask) ^ mask);
	
//    return 2;
}


int main(void) {
	printf("All even bits are set to 1:  "); 
	printf("%i", allEvenBits(2863311530)); printf("\n"); 

	return 0;
}
