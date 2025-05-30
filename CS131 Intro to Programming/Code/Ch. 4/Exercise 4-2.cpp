// Scott Felch
// 8 April 2010
// CS 131, Keith Laidig
// Exercise 4-2
/* This program will print out a block E using asterisks (*), where the E is 7
characters high and 5 characters wide. */

#include <iostream>

/* For the sake of busy work, rather than typing in all the characters at once,
I'll declare a variable to hold the character '*', and then repeatedly output
that variable to make the cool little shape I want below.*/
char st = '*';

int main()
{
	std::cout << st << st << st << st << st << '\n';
	std::cout << st << st << st << st << st << '\n';
	std::cout << st << st << '\n';
	std::cout << st << st << st << st << '\n';
	std::cout << st << st << '\n';
	std::cout << st << st << st << st << st << '\n';
	std::cout << st << st << st << st << st << "\n\n";
	return (0);
}