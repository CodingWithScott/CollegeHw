// Scott Felch
// 12 May 2010
// CS 131, Keith Laidig
/* Exercise 9-1. This program will count the number of words in a string. I'll 
define a "word" as a group of characters separated from other groups of characters
by a space. */

#include <iostream>
#include <string>
using namespace std;

int word_counter(string user_string)
{
	bool in_word = false;		// This flag tells if I'm currently in a word
	char current_char;			// Whatever letter or number I'm currently at
	int index = 0;				// Index to keep track of where I am in the string
	int length;					// Length of string in characters
	int num_of_words = 0;		// The number of words counted in the string

	length = user_string.length();
	current_char = user_string[index];
	while (index < length)
	{
		/* Not currently in a word and the current char is not a space, I just hit a new word.
		The word counter is incremented, index continues on. */
		if (current_char != ' ' && in_word == false)
		{
			num_of_words++;
			in_word = true;
			index++;
		}
		/* Already in a word, current char is not a space, no need to increment word counter,
		increment just the index. */
		else if (current_char != ' ' && in_word == true)
		{
			index++;
		}
		/* Not currently in a word, current char is a space, no need to do anything except
		increment the index. */
		else if (current_char == ' ' && in_word == false)
		{
			index++;
		}
		/* Currently in a word and encounter a space, it is the end of the word. Set in_word
		to false, increment index. */
		else if (current_char == ' ' && in_word == true)
		{
			index++;
			in_word = false;
		}
		current_char = user_string[index];
	}
	return (num_of_words);
}

int main()
{
	string user_string;		// This is the string the user is going to enter
	int num_of_words = 0;	// The number of words in the string
	int length = 0;			// Length of the string in chars

	// First I'll explain to the user the purpose of the program and gather input
	cout << "Enter a sentence and I'll tell you how many words there are!\n";
	cout << "Enter your sentence:    ";
	getline(cin, user_string, '\n');
	cout << "\n\n";

	// First determine how long the string is
	length = user_string.length();
	cout << "length of string is: " << length << '\n';

	// Now pass this information to another function which performs the calculation
	num_of_words = word_counter(user_string);

	// And output the results
	cout << "That string has...\n";
	cout << "Characters:\t" << length << '\n';
	cout << "Words:\t" << num_of_words << '\n';

	return (0);
}