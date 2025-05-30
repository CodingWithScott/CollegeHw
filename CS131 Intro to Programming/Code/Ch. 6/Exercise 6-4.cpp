// Scott Felch
// 22 April 2010
// CS 131, Keith Laidig
// Exercise 6-4
/* A leap year is any year dvisible by 4, unless it is divisible by 100, but not 400. This program will accept
a user inputted year, and tell whether it's a leap year or not. */

#include <iostream>

int year;			// Variable to hold the user-defined year.
char is_it_a_leap;	// Variable to flag if the year is a leap year or not.

int main()
{
	// First I explain the purpose of the program to the user and gather their input (what year to calculate)
	std::cout << "This program is a quick way to determine if a year is a leap year or not.\n\n";
	std::cout << "Please enter a year:    ";
	std::cin >> year;

	/* Now perform some calculations using the year given by the user. Algorithm borrowed from Wikipedia.
	Source: http://en.wikipedia.org/wiki/Leap_year#Algorithm 
	Years used for testing purposes: http://kalender-365.de/leap-years.php */ 
	if (year % 400 == 0)
		is_it_a_leap = 'Y';
	else if (year % 100 == 0)
		is_it_a_leap = 'N';
	else if (year % 4 == 0)
		is_it_a_leap = 'Y';
	else
		is_it_a_leap = 'N';

	// Now that the calculations have been done, output the results.
	std::cout << "\n\n";
	if (is_it_a_leap == 'N')
		std::cout << "The year " << year << " is not a leap year, just the regular boring kind.\n\n";
	else
		std::cout << "The year " << year << " is a leap year, how exciting!\n\n";

	return (0);

}