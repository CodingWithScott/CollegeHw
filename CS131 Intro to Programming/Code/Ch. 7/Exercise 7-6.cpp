// Scott Felch
// 5 May 2010
// CS 131, Keith Laidig
// Exercise 7-6. This program will take a series of numbers and count the positive and negative values.

#include <iostream>

float current_num;		/* Variable to hold the current number being entered by the user.
	It's a float just in case the user feels like entering a decimal. */
int pos_counter;		// Counter to keep track of the number of positive values.
int neg_counter;		// Counter to keep track of the number of negative values.
int counter;			// Counter to keep track of how many numbers were entered total.

int main()
{
	// First I'll tell the user what the program does and then tell the user what to do
	std::cout << "This program will count how many positive and negative values you enter. Are you ready?\n";
	std::cout << "Oh by the way, enter a 0 when you're done entering values.\n";

	// Get the initial value for current_num in order to enter the while loop.
	std::cout << "Enter a value:    ";
	std::cin >> current_num;
	while (current_num != 0.0)
	{
		/* User enters a value, program determines if it's positive or negative.
		Zero is neither positive nor negative, so it's a good value to use for
		an exit test. */
		std::cout << "Enter a value:    ";
		std::cin >> current_num;
		if (current_num < 0.0)
		{	neg_counter++;
			counter++;
		}
		else if (current_num > 0.0)
		{	pos_counter++;
			counter++;
		}
	}

	// Output the data acquired in a semi-organized fashion
	std::cout << "\nOkay, let's tally these numbers up!\n";
	std::cout << "Total number of values entered: " << counter << "\n";
	std::cout << "Positive numbers:\t\t" << pos_counter << "\n";
	std::cout << "Negative numbers:\t\t" << neg_counter << "\n";
	std::cout << "Cool man, welp see ya later!\n\n";

	// End program
	return 0;
}


	