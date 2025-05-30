// Scott Felch
// 12 May 2010
// CS 131, Keith Laidig
/* This program will accept a user input for an array of numbers, pass the 
array to a function which will return the highest value, and output the results. */

#include <iostream>
using namespace std;

int main()
{
	int the_array[10] = {1, 3, 5, 12, 69, 187, 420, 1337, 9999, 1024};	// The array the function will be analyzing
	int biggest_num;		// Variable to hold the biggest number in the array
	int biggest(int the_array[10]);		/* Declares that later in the program I'll be calling a function called
		"biggest" */

	// Explain the program to user
	cout << "This program will tell you what the highest number in an array is.\n";
	cout << "The array currently contains the numbers:   ";
	for (int index = 0; index < 10; index++)
	{
		cout << the_array[index] << ", ";
	}
	cout << endl;


	// Call the next function to do the calculations
	biggest_num = biggest(the_array);

	// Output results
	cout << "The biggest number in that array is " << biggest_num << "\n\n";

	// Terminate program
	return (0);
}

int biggest(int the_array[10])
{
	int biggest_num;		// Variable to hold the biggest number
	//int current_num;			// Variable to hold the current number being looked at
	int index;					// Variable to keep track of where I currently am in the array

	// Begin by assuming the first number in the array is the biggest
	biggest_num = the_array[0];
	// Analyzes each value in the array sequentially to see if it's bigger than the current biggest_num
	for (index = 0; index < 10; index++)
	{
		if (the_array[index] > biggest_num)
			biggest_num = the_array[index];
	}
	return biggest_num;
}