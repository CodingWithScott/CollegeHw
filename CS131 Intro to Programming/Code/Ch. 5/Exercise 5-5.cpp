// Scott Felch
// 13 April 2010
// CS 131, Keith Laidig
// Exercise 5-5
/* This program will accept a user input number of hours and minutes, and then output it as the total number of minutes.
For example, user will enter 1 hour 30 minutes, program will output 90 minutes. */

#include <iostream>

// I'll use floats in case the user enters partial minutes
float hours;		// Number of hours the user inputs
float mins;			// Number of minutes the user inputs
float totalmins;	// Total number of minutes which will be output

int main()
{
	// First I'll explain to the user the purpose of the program and gather input
	std::cout << "This program will convert hours and minutes to purely minutes.\n";
	std::cout << "Please enter the number of hours:   ";
	std::cin >> hours;
	std::cout << "Please enter the number of minutes:   ";
	std::cin >> mins;

	// Now perform the calculations
	totalmins = mins + (hours * 60.0);

	// And output the result
	std::cout << "That is a total of " << totalmins << " minutes.\n\n";

	return (0);
}