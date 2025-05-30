// Scott Felch
// 13 May 2010
// CS 131, Keith Laidig
/* Exercise 9-2. This program will accept two strings of any given length, and compare the 
two to see if string1 begins string2. It will return true if this is the case. */

#include <iostream>
#include <string>
using namespace std;

int main()
{
	string string1;			// The first string the user will enter
	string string2;			// The second string the user will enter
	bool does_it_begin;		// Bool indicating whether string1 begins string2 or not
	bool begins(string string1, string string2);	// Declaring that I'll use a function later

	// Explain the program to the user and get their input
	cout << "This program will compare two strings and tell you if the first string begins the second string.\n";
	cout << "Please enter string 1:   ";
	getline(cin, string1, '\n');
	cout << "Please enter string 2:   ";
	getline(cin, string2, '\n');

	// Pass both strings to the "begins" function for comparison
	does_it_begin = begins(string1, string2);

	// Output the results
	if (does_it_begin == true)
	{
		cout << "String 1 does begin string 2! Awesome!\n\n";
	}
	else if (does_it_begin == false)
	{
		cout << "String 1 is not the beginning of string 2. Sad. :(\n\n";
	}

	// Terminate program.
	return (0);
}

bool begins(string string1, string string2)
{
	int length1;					// Length of string1, in characters
	int length2;					// Length of string2, in characters
	int index = 0;					// Index to keep track of where I am in each string
	char current_char1;				// Current character being analyzed in string1
	char current_char2;				// Current character being analyzed in string2
	bool does_it_begin = false;		// Variable declaring whether or not string1 begins string2

	length1 = string1.length();
	length2 = string2.length();
	/* If string1 is longer than string2 then I know right away string1 doesn't begin string2,
	no need to test any further. */
	if (length1 > length2)
		does_it_begin = false;
	else
	{
		// Here I'll begin comparing the characters of each string one by one
		current_char1 = string1[index];
		current_char2 = string2[index];
		while (index < length1)
		{
			if (current_char1 == current_char2)
			{
				does_it_begin = true;
			}
			else if (current_char1 != current_char2)
			{
				does_it_begin = false;
			}
			index++;
			current_char1 = string1[index];
			current_char2 = string2[index];
		}
	}

	return does_it_begin;
}
