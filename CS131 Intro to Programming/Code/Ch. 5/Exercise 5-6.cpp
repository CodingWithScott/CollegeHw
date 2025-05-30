// Scott Felch
// 13 April 2010
// CS 131, Keith Laidig
// Exercise 5-6
/* This program will accept a user input integer for a number of minutes, and then output the total
hours and minutes. For example, 90 minutes -> 1 hour 30 minutes. */

#include <iostream>

int totalmins;		// Total number of minutes the user inputs
int hours;			// Number of hours to be output
int mins;			// Number of minutes to be output

int main()
{
	// First I'll explain the purpose of the program to the user and gather input
	std::cout << "This program will convert a bunch of minutes to hours and minutes.\n";
	std::cout << "Please enter a bunch of minutes:   ";
	std::cin >> totalmins;

	// Here I'll perform the calculation 
	hours = totalmins / 60;
	mins = totalmins % 60;

	// And output the result
	std::cout << "That is a total of " << hours << " hours " << mins << " minutes.\n\n";

	return(0);
}