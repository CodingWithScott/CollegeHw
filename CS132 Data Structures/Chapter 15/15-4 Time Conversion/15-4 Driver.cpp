// Scott Felch
// 30 October 2010
#include "MilTime.h"
#include "Time.h"
#include <iostream>
#include <iomanip>
using namespace std;

int main()
{
	int user_hours;					// Integer to hold hours entered by user, in military time
	int user_secs;					// Integer to hold seconds entered by user 
	bool hours_valid = false;		// Bool to make sure "user_hours" is valid, between 0 and 2359.
	bool secs_valid = false;		// Bool to make sure "user_secs" is valid, between 0 and 59.
	cout << "This program will convert a time from military time to standard time.\n";
	cout << "For example, 16:20 becomes 4:20\n";

	cout << "Please enter hours in military format:\t";
	cin >> user_hours;
	// Validation makes sure proper data is added for hours, user can't continue unless data is valid
	if (user_hours > 0 && user_hours < 2400)
		hours_valid = true;
	while(hours_valid == false)
	{
		cout << "That's an invalid time. Please enter hours in military format,\n";
		cout << "from 0000 to 2359.\n";
		cout << "Enter time:   ";
		cin >> user_hours;
		if (user_hours > 0 && user_hours < 2400)
			hours_valid = true;
	}
	cout << "Please enter seconds:\t";
	cin >> user_secs;
	// Validation makes sure proper data is added for secs, user can't continue unless data is valid
	if (user_secs >= 0 && user_secs < 60)
		secs_valid = true;
	while(secs_valid == false)
	{
		cout << "That's an invalid time. Please enter seconds from 0 to 59\n";
		cout << "Enter time:   ";
		cin >> user_secs;
		if (user_secs >= 0 && user_secs < 60)
			secs_valid = true;
	}

	// Creates a MilTime object called time_for_fun
	MilTime time_for_fun(user_hours, user_secs);
	cout << "\n";
	time_for_fun.print();		// Print results in military format
	cout << "\n";
	time_for_fun.printStd();	// Print results in standard format
	cout << "\n\n";
	/* "printStd" still outputs the standard form weird, like 9:0:43 instead of 09:00:43. 
	Setprecision only works on decimals, not sure how to get it to output properly but I'm running 
	out of time and moving on to the next problem. */
	return 0;
}