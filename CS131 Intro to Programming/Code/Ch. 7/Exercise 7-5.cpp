// Scott Felch
// 8 May 2010
// CS 131, Keith Laidig
/* Exercise 7-5. This program will tell whether a number if prime or not. I already wrote
it once but then erased the file cuz I'm dumb, so this is a rewrite. Oops. */

#include <iostream>

int number;			// The number the user will enter to test for primality
int is_prime;		// Variable to store whether the number is prime or not, using 0 or 1.
int divisor;	/* Dividing number which will be testing the user's number, and incremented 
			through the while loop. */

int main()
{
	// First explain the purpose of the program to the user and gather input
	std::cout << "This program will tell you if a number is prime or not! Are you ready?\n";
	std::cout << "Enter the number you'd like to test:    ";
	std::cin >> number;
	std::cout << "\n";

	/* First I'll set is_prime to true. If the user's number is prime, it will 
	pass all of the tests below. Otherwise, one of the tests will trigger is_prime
	to be false. */
	is_prime = 1;
	// If a number is 1 or 2 it is prime, I can quit testing here.
    if (number < 3)
	{    
		is_prime = 1;
	}
    // Even numbers are not prime, I can quit testing here.
	else if (number % 2 == 0)
	{
		is_prime = 0;
	}
    else
	{
		divisor = 3;	/* Initialize divisor as 3, since I've already done the 
		previous two test. */
		/* This loop checks all numbers from 3 to the user's number and checks
		for even division. */
        while (divisor < number)
		{
            if (number % divisor == 0)
			{
				is_prime = 0;
				break;
			}
			else
				divisor++;
		}
	}

	// Output the results and a pretty message
	if (is_prime == 0)
		std::cout << "Aw man, that's not a prime number. Disappointing!\n\n";
	else if (is_prime == 1)
		std::cout << "Alright cool, you got a prime number there!\n\n";

	// End program
	return 0;
}
