// Scott Felch
// 28 April 2010
// CS 131, Keith Laidig
/* Exercise 8-7: This program will convert numbers to words, as a person would speak them,
and can handle all numbers from 0 to 100. Example: 13 is "thirteen", 100 is "one hundred". */

#include <iostream>

int user_number;		// Variable to hold the number the user enters
int tens_digit;			/* I'll use a seperate variable when analyzing each part of the user's number,
	this one will hold the tens digit. */
int ones_digit;			// This variable will hold the ones digit. 

int main()
{
	// First I'll explain to the user the purpose of the program and gather their input.
	std::cout << "This program will convert a number from digits to words.\n";
	std::cout << "Please enter a number from 0 to 100:    ";
	std::cin >> user_number;

	if 

	if (user_number % 100 == 1)