// Scott Felch
// 16 May 2010
// CS 131, Keith Laidig
/* Exercise 9-3. This program will have a function count(number, array, length) that will count the 
number of times "number" appears in "array". The array has "length" elements. The function
should be recursive. */

#include <iostream>
using namespace std;

int main()
{
	int number = 1000;					// Number I'll be counting occurrences of
	int num_count = 0;					// How many occurrences there are of "number"
	int length = 10;					// How many elements are going to be in the array
	int user_array[10] = {2, 4, 6, 8, 100, 1000, 1000, 1000, 3, 9}; /* The array I'll be working with
		initialized with some values to test against. */
	int rec_count(int number, int user_array[], int length);	// Declare that I'll be using a function later on
	
	/* First I'll explain to the user what the program does. I won't actually fill the array
	with numbers of the user's choice, since the assignment doesn't call for that and it would
	just be adding an extra level of tediousness. */
	cout << "This program will tell you how many times a number occurs in an array\n"; 

	// Call the num_count function to do the proper calculations
	num_count = rec_count(number, user_array, length);

	// Output the results
	cout << "The full array is:   " << user_array << endl;
	cout << "The number you're looking for is:   " << number << endl;
	cout << "That number occured " << num_count << " times" << endl;

	return (0);
}

//int count(int number,  int user_array[], int length)
//{
//	int index = 0;		// An index to read through the array
//	int num_count = 0;		// Variable which holds how many occurrences there are of "number"
//
//	// Runs through the array 
//	while (index < length)
//	{
//		// Check if the first element in the array is equal to "number", increment num_count if necessary
//		if (user_array[index] == number)
//			num_count++;
//		index++;
//	}
//
//	// After calculating how many occurrences there are of "number", return that count value to main to be outputted
//	return num_count;
//}

int rec_count(int number, int user_array[], int length)
{
	int counter = 0;
	if (length == 0)
	{
		return 0;
	}
	else if (user_array[(length - 1)] == 0)
	{
		counter++;
	}
	return (counter + rec_count(number, user_array, (length - 1)))
}

	