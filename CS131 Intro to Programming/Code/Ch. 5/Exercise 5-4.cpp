// Scott Felch
// 13 April 2010
// CS 131, Keith Laidig
// Exercise 5-4
// This program will accept user input for kilometers, and then convert it to miles and output the result.

#include <iostream>

float kilos;		// Number of kilometers
float miles;		// Number of miles

int main()
{
	// First I'll explain the purpose of the program to the user and gather input
	std::cout << "This program will convert kilometers to miles for you.\n";
	std::cout << "Please enter the number of kilometers:   ";
	std::cin >> kilos;

	// Now I'll perform the calculation
	miles = kilos * 0.6213712;

	// And output the result
	std::cout << "That is " << miles << " miles.\n\n";

	return (0);
}