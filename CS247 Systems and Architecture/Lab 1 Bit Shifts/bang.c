// http://www.dreamincode.net/forums/topic/103945-bang-using-only-bitwise-operators/


int bang(int x) {
	int invx = ~x;					//if x==0, then -1
	int negx = invx + 1;			//if x==0, then 0
	//if x was 0, then MSB is 1, so MSB>>31 & 1 = 1
	return ((~negx & invx)>>31) & 1; 
}
