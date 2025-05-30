// Scott Felch
// 28 April 2010
// CS 131, Keith Laidig
/* Exercise 8-7: This program will convert numbers to words, as a person would speak them,
and can handle all numbers from 0 to 100. Example: 13 is "thirteen", 100 is "one hundred". */

#include <iostream>
#include <string>

int length_of_string = 0;		// A variable which will show the length of the string the user enters.
std::string user_string;		// The series of numbers the user will enter, as a string.
int counter = 0;				// A counter to be used in the for loop


int main()
{
	// First I'll explain to the user the purpose of the program and gather their input.
	std::cout << "This program will convert a number from digits to words.\n";
	std::cout << "Please enter a number from 0 to 100:    ";
	std::getline(std::cin, user_string);
	
	// Now I'll compute the length of the string, to use as an index.
	length_of_string = user_string.length();

	// If the user enters a number greater than 3 digits the program displays a polite error message and quits.
	if (length_of_string > 3)
		std::cout << "Sorry, that's not a valid number.";

	// If the user enters a 3 digit number greater than 100 the program displays the same error, and quits.
	if (length_of_string == 3)
		if (user_string[0] == 1 && user_string[1] == 0 && user_string[2] == 0)
			std::cout << "One hundred ";
		else
			std::cout << "Sorry, that's not a valid number.";
	/*  If the user enters a 2 digit number that begins with a 1, this switch will print out the full number. 
	(Ten, eleven, etc.) If the number is >= 20, it prints the tens prefix and moves on to the next 
	decimal place. */
	else if (length_of_string == 2)
	{
		switch (user_string[0])
		{
			case '1':
				if (user_string[1] == '0')
					std::cout << "ten ";
				else if (user_string[1] == '1')
					std::cout << "eleven ";
				else if (user_string[1] == '2')
					std::cout << "twelve ";
				else if (user_string[1] == '3')
					std::cout << "thirteen ";
				else if (user_string[1] == '4')
					std::cout << "fourteen ";
				else if (user_string[1] == '5')
					std::cout << "fifteen ";
				else if (user_string[1] == '6')
					std::cout << "sixteen ";
				else if (user_string[1] == '7')
					std::cout << "seventeen ";
				else if (user_string[1] == '8')
					std::cout << "eighteen ";
				else if (user_string[1] == '9')
					std::cout << "nineteen ";
				break;
				break;
			case '2':
				std::cout << "twenty ";
				break;
			case '3':
				std::cout << "thirty ";
				break;
			case '4':
				std::cout << "fourty ";
				break;
			case '5':
				std::cout << "fifty ";
				break;
			case '6':
				std::cout << "sixty ";
				break;
			case '7':
				std::cout << "seventy ";
				break;
			case '8':
				std::cout << "eighty ";
				break;
			case '9':
				std::cout << "ninety ";
				break;
		}

		/* This second switch will not execute if the tens digit is a 1, this prevents the program
		from displaying "eleven one" instead of "eleven". */
		if (user_string[0] != '1')
		{
			switch (user_string[1])
			{
			case '0':
				std::cout << "zero ";
				break;
			case '1':
				std::cout << "one ";
				break;
			case '2':
				std::cout << "two ";
				break;
			case '3':
				std::cout << "three ";
				break;
			case '4':
				std::cout << "four ";
				break;
			case '5':
				std::cout << "five ";
				break;
			case '6':
				std::cout << "six ";
				break;
			case '7':
				std::cout << "seven ";
				break;
			case '8':
				std::cout << "eight ";
				break;
			case '9':
				std::cout << "nine ";
				break;
			}
		}
	}

	// If the string entered is a single digit, this simple case executes.
	if (length_of_string == 1)
		switch (user_string[0])
		{
			case '0':
				std::cout << "zero ";
				break;
			case '1':
				std::cout << "one ";
				break;
			case '2':
				std::cout << "two ";
				break;
			case '3':
				std::cout << "three ";
				break;
			case '4':
				std::cout << "four ";
				break;
			case '5':
				std::cout << "five ";
				break;
			case '6':
				std::cout << "six ";
				break;
			case '7':
				std::cout << "seven ";
				break;
			case '8':
				std::cout << "eight ";
				break;
			case '9':
				std::cout << "nine ";
				break;
		}

		std::cout << "\n\n";

		return 0;
}
