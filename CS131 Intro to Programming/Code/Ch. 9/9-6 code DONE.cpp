// Scott Felch
// 14 May 2010
// CS 131, Keith Laidig
// Exercise 9-6. This program will scan a string for the character "-" and replace it with "_". 

#include <iostream>
#include <string>
using namespace std;

int main()
{
	string user_string;		// The string to be input by the user
	string character_replacer(string user_string);		// Declare that I'll be using another function later
	
	// First explain the program to the user and gather their input
	cout << "This program will replace hyphens with underscores.\n";
	cout << "Please enter a string:\n";
	getline(cin, user_string, '\n');

	// Now pass this string to the next function, which will do the character replacement
	user_string = character_replacer(user_string);
	cout << "\n";
	
	// And output the results
	cout << "Here is your string with all the hyphens converted to underscores:\n" << user_string << "\n\n";

	// Terminate program
	return (0);
}

string character_replacer(string user_string)
{
	int length;				// The length of the user's string, in characters
	int index = 0;				// Index to keep track of where I am in the string

	length = user_string.length();

	// Analyze the string one character at a time, replacing characters if necessary
	while (index < length)
	{
		if (user_string[index] == '-')
			user_string[index] = '_';
		index++;
	}
	
	// Return the modified string to main()
	return (user_string);
}