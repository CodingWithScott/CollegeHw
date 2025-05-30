// Scott Felch
// 15 May 2010
// CS 131, Keith Laidig
/* Exercise 9-4. This program will take a character string and return a primitive hash code
by adding up the value of each character in the string. */

#include <iostream>
#include <string>
using namespace std;

int main()
{
	string user_string;		// The string the user will be entering
	int hash_value;		// Variable to hold the hash value
	int hash_maker(string user_string);		/* Declare that I'll be using 
	 another function later and it'll receive a string */

	// This part of the program tells the user what the program will do and gathers a string from them
	cout << "This program will generate a hash value for a string you type in.\n";
	cout << "Please enter a string:   ";
	getline(cin, user_string, '\n');

	// Pass the string to the next function which will determine a crude hash value
	hash_value = hash_maker(user_string);

	// Output the results 
	cout << "The hash value for that string is:    " << hash_value << "\n\n";

	// Terminate program
	return (0);
}

int hash_maker(string user_string)
{
	int length;				// Variable to hold how long the string is, in characters
	int index = 0;			// Variable to keep track of where I am in the string
	int hash_value = 0;		// Variable to hold the hash value which will be produced
	char current_char;		// Variable to hold the current character being analyzed 

	length = user_string.length();

	/* This while loop goes through the string and adds up the ASCII values for each character,
	returning a total value which is like a primitive hash code. */
	current_char = user_string[index];
	while (index < length)
	{
		hash_value = hash_value + int(current_char);
		index++;
	}
	return hash_value;
}