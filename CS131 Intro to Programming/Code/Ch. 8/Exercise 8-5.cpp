// Scott Felch
// 27 April 2010
// CS 131, Keith Laidig
// Exercise 8-5. This program will read in a character and then tell you if it is a vowel or a consonant.

#include <iostream>
#include <string>

char letter;		// The user input letter to be tested

int main()
{
	std::cout << "This program will tell you if a letter is a vowel or a consonant.\n";
	std::cout << "Please enter a letter:    ";
	std::cin >> letter;
	std::cout << "\n";

	// For the sake of making comparison easier, I'll make sure the letter is lowercase before the switch statement.
	letter = tolower(letter);

	// The letter is checked against each of the English vowels, if any of them match the program will output
	// confirmation of a vowel, otherwise it falls through to the default statement of the letter being a consonant.
	switch (letter)
	{
		case ('a'):
			std::cout << "That is a vowel! How exciting!\n\n";
			break;
		case ('e'):
			std::cout << "Oh boy, a vowel! I like vowels.\n\n";
			break;
		case ('i'):
			std::cout << "Gosh golly gee, a vowel! That's fun.\n\n";
			break;
		case ('o'):
			std::cout << "Oh good, it's a vowel! High five!\n\n";
			break;
		case ('u'):
			std::cout << "Yup, it's a vowel. Good job!\n\n";
			break;
		case ('y'):
			std::cout << "This letter is a vowel! Woohoo!\n\n";
			break;
		default:
			std::cout << "That letter is a consonant. Very disappointing... \n\n";
	}

	return 0;
}
