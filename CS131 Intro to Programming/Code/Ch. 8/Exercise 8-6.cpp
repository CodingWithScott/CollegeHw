// Scott Felch
// 28 April 2010
// CS 131, Keith Laidig
/* Exercise 8-6: This program will convert numbers to words. Example: 895 results
in "eight nine five". */

#include <iostream>
#include <string>

int length_of_string = 0;		// A variable which will show the length of the string the user enters.
std::string user_string;		// The series of numbers the user will enter, as a string.
int counter = 0;				// A counter to be used in the for loop


int main()
{
	// First I'll explain to the user the purpose of the program and gather their input.
	std::cout << "This program will convert a number from digits to words.\n";
	std::cout << "Please enter a number:    ";
	std::getline(std::cin, user_string);
	
	// Now I'll compute the length of the string, to use as an index.
	length_of_string = user_string.length();
	
	/* This loop reads through the string one character at a time. Each pass through
	the loop spits out the appropriate word for the number. */
	while (counter < length_of_string)
	{
		switch (user_string[counter])
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
			// If the user enters something besides a number, a polite error displays.
			default:
				std::cout << "That's not a number, silly goose!\n";
		}
		/* Increment the counter and continue through the switch statement again, until reaching the 
		end of the string. */
		counter++;
	}

	std::cout << "\n\n";
	return 0;
}
