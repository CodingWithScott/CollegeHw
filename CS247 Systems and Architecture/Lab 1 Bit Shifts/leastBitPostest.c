/* Test program for leastBitPos(int x)
 * leastBitPos - return a mask that marks the position of the
 *               least significant 1 bit. If x == 0, return 0
 *   Example: leastBitPos(96) = 0x20
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2 
*/

int leastBitPos(int x) {
	return (x & (-x));
}



int main(void) {

	printf("Test value:  "); printf("%d", 8); printf("\n");
	printf("Least bit pos:  "); printf("%d", leastBitPos(8)); printf("\n");

	return 0;

}
