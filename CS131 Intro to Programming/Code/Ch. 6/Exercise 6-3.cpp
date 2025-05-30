// Scott Felch
// 22 April 2010
// CS 131, Keith Laidig
// Exercise 6-3
/* This program will calculate out the number of pennies, nickels, dimes and quarters necessary
to make change for a given amount of money less than $1.00. Like a Coinstar machine but in your
computer! */

#include <iostream>

// All of the variables are ints, to allow for integer division.
int pennies;		// Number of pennies.
int nickels;		// Number of nickels.
int dimes;			// Number of dimes.
int quarters;		// Number of quarters.
int goldcoins;		// Number of those gold Sacagawea dollar things.
int num_of_cents;	// Amount of money to be calculated, in cents.

int main()
{
	// First I explain the purpose of the program to the user and gather their input.
	std::cout << "This program will calculate out the easiest way to make change for some money. \n";
	std::cout << "Please enter the number of cents you have:    ";
	std::cin >> num_of_cents;

	// Next will be a series of integer division and modulus division statements to calculate
	// the number of each type of coins. The first statement determines the number of coins of that
	// type, the second statement determines the number of cents remaining.
	goldcoins = num_of_cents / 100;
	num_of_cents = num_of_cents % 100;
	
	quarters = num_of_cents / 25;
	num_of_cents = num_of_cents % 25;

	dimes = num_of_cents / 10;
	num_of_cents = num_of_cents % 10;

	nickels = num_of_cents / 5;
	num_of_cents = num_of_cents % 5;

	// At this point there's no further division left to do, however many cents are leftover will be all pennies.
	pennies = num_of_cents;

	// Now I will output the results of the program.
	std::cout << "\nOh boy that's a lot of coins! Here's what you've got... \n\n";
	std::cout << "Sacagawea dollars:\t\t" << goldcoins << "\n";
	std::cout << "Quarters:\t\t\t" << quarters << "\n";
	std::cout << "Dimes:\t\t\t\t" << dimes << "\n";
	std::cout << "Nickels:\t\t\t" << nickels << "\n";
	std::cout << "Pennies:\t\t\t" << pennies << "\n\n";

	return (0);
}