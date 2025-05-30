// Scott Felch
// 29 April 2010
// CS 131, Keith Laidig
// Midterm problem 1

#include <iostream>

long int dollars = 0;				// The user inputted initial amount of dollars to count
long int dollars_left = 0;		// The number of dollars remaining after decrementing each unit of time
long int SECONDS_PER_YEAR = 31104000;		// Number of seconds in a year
long int SECONDS_PER_MONTH = 2592000;		// Number of seconds in a month
long int SECONDS_PER_DAY = 86400;			// Number of seconds in a day
long int SECONDS_PER_HOUR = 3600;			// Number of seconds in an hour
long int SECONDS_PER_MINUTE = 60;			// Number of seconds in a minute
long int years = 0;					// Number of years it will take to count the money
long int months = 0;				// Number of months...
long int days = 0;					// Number of days...
long int hours = 0;					// Number of hours...
long int minutes = 0;				// Number of minutes...
long int seconds = 0;				// And number of seconds it will take to count the money.

int main()
{
	// First I'll explain the program to the user and gather input
	std::cout << "This program will tell you how long it takes to count a given amount of money,\n";
	std::cout << "assuming it takes 1 second to count 1 dollar.\n";
	std::cout << "How many dollars would you like to count?    ";
	std::cin >> dollars;
	std::cout << "\n";

	// Now I'll calculate how long this will take to count
	years = dollars / SECONDS_PER_YEAR;		// Count how many whole years it'll take to count
	dollars_left = dollars - (years * SECONDS_PER_YEAR);	// Determine how much money is left to still be counted
	months = dollars_left / SECONDS_PER_MONTH;	// Count how many whole months it'll take to count, etc...
	dollars_left = dollars_left - (months * SECONDS_PER_MONTH);
	days = dollars_left / SECONDS_PER_DAY;
	dollars_left = dollars_left - (days * SECONDS_PER_DAY);
	hours = dollars_left / SECONDS_PER_HOUR;
	dollars_left = dollars_left - (hours * SECONDS_PER_HOUR);
	minutes = dollars_left / SECONDS_PER_MINUTE;
	dollars_left = dollars_left - (minutes * SECONDS_PER_MINUTE);
	seconds = dollars_left;		// The remaining number of dollars will be less than 60, so no more math needed.	

	// Now output the results in a tidy fashion
	std::cout << "Wowie, that's a lot of money! Here's how long it will take to count...\n";
	std::cout << years << " years " << months << " months " << days << " days " << hours << " hours " << minutes << " minutes " << seconds << " seconds.\n\n";

	// End program
	return 0;
}