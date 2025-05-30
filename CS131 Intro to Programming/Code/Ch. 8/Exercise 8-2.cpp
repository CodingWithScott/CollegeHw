// Scott Felch
// 27 April 2010
// CS 131, Keith Laidig
/* Exercise 8-2. This program will calculate total resistance of a resistor network. 
The user will input each resistor and its strength, the program outputs the results. */

#include <iostream>

float total_res = 0.0;		// Total amount of resistance.
float inv_total_res = 0.0;	// The inverse of the total resistance.
float counter = 0.0;		/* Count the number of resistors added to the system. It's
	setup as a float since it will be used in floating point division at the end. */
float current_res = 0.0;	// The value of the current resistor being added.

int main()
{
	// First I'll explain the purpose of the program to the user, and gather input.
	std::cout << "This program will calculate the total resistance of a resistor network." << "\n";

	/* The while loop will execute an infinite number of times until the user enters 
	a negative number. It's not possible to have a negative resistance, so this makes a 
	good exit test. */
	while (true)
	{
		if (current_res < 0.0)
			break;
		counter++;
		total_res = total_res + (1.0 / current_res);
		std::cout << "Please enter in the resistance in Ohms (or any negative number to quit):   ";
		std::cin >> current_res;
	}

	counter--;

	// Calculate the inverse of the total resistance and output the results.
	inv_total_res = 1.0 / total_res;

	std::cout << "You entered " << counter << " resistors." << "\n";
	std::cout << "They have a total resistance of " << (1.0 / total_res) << " Ohms." << "\n\n";

	return (0);
}
