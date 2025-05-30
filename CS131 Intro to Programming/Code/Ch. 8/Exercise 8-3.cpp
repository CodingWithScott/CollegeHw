// Scott Felch
// 27 April 2010
// CS 131, Keith Laidig
/* Exercise 8-3. This program will compute the average of 'n' number of values. */

#include <iostream>

float current_num = 1.0;		// Current value being entered.
float total = 0.0;				// Total value of numbers so far.
float counter = 0.0;			// Counter of how many numbers have been entered.
float average = 0.0;			// The results of the calculation.

int main()
{
	// First I'll explain to the user the purpose of the program, and give instructions on how to exit.
	std::cout << "This program will calculate the average of some numbers for you." << "\n" << "Enter \"0\" to exit at any time." << "\n\n";
	/* current_num is initialized at 1.0, to allow it to enter the while loop. However the user changes current_num to the value of their
	choice prior to current_num being used in any calculations, so accuracy is not affected. */
	while (current_num != 0)
	{
		std::cout << "Please enter a number:    ";
		std::cin >> current_num;
		total = current_num + total;
		counter = counter + 1.0;
	}
	// Counter still gets incremented one last time on the last iteration of the while loop, I'll decrement it by 1 here to ensure accuracy.
	counter--;
	// Now that I'm done gathering numbers, I'll compute the average and output the result.
	average = total / counter;

	std::cout << "\nYou entered " << counter << " numbers.\n";
	std::cout << "The average value is: " << average << "\n\n";

	return 0;
}