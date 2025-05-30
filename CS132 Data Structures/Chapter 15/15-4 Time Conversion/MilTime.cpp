#include "MilTime.h"
#include <iostream>
#include <iomanip>
using namespace std;

MilTime::MilTime()	
{	// Default constructor, sets time to 0000 hours and 00 seconds
	milHours = 0000;
	milSeconds = 0;
}

MilTime::MilTime(int mh, int ms) : Time()
{	// Overloaded constructor, accepts arguments for hours and seconds in military format
	milHours = mh;
	milSeconds = ms;
	if (milHours <= 1259)
		// Sets the hours variable in Time. The (milHours % 100) drops the trailing 2 digits, ie 1159 becomes 11
		Time::setHour(milHours % 100);
	else if(milHours >= 1300)
		// Sets the hours variable in Time. The ((milHours-1200)%100) drops the trailing 2 digits and 
		// converts to standard format, ie 1659 becomes 4
		Time::setHour((milHours - 1200) % 100);
	/* This next part will take just the minutes from the milHours variable, by subtracting the hours part
	until the value is 59 or less. A temporary variable "temp_mh" is used to avoid changing the original 
	milHours value. */
	int temp_mh = milHours;
	while(temp_mh > 59)
		temp_mh = temp_mh - 100;
	if (temp_mh >= 0 && temp_mh < 60)
		Time::setMin(temp_mh);
	// This part sets the seconds
	Time::setSec(milSeconds);
}

void MilTime::setTime(int mh, int ms)	
{	/* Accepts arguments to be stored in the milHour and milSeconds variable, then converts
	them to standard time and stores it in the hours, mins and secs variables of the Time class */
	milHours = mh;
	milSeconds = ms;
}

int MilTime::getHour()
{	// Returns the hour in military format
	return milHours;
}

int MilTime::getStandHr()
{
	int standHr;	// Variable to hold standard format temporary variable
	if (milHours <= 1200)	// If time in military format is already noon or less, no reason to subtract 12
		standHr = milHours / 100;	// Divide by 100 to isolate just the hour part (Ie, 400 becomes 4)
	else if (milHours > 1200 && milHours < 2400)
		standHr = (milHours - 1200) / 100;	/* Subtract 1200 to get to standard format (Ie 1700 becomes 500) 
							Divide by 100 to isolate just the hour part (Ie, 400 becomes 4)	)*/
	// Return calculated value
	return standHr;
}

void MilTime::print()
{	// Print out the contents of the MilTime class in military format
	cout << "Military format:\n";
	cout << "Hours:\t\t\t" << milHours << "\n";
	cout << "Seconds:\t\t" << milSeconds << "\n";
}

void MilTime::printStd()
{	// Print out the contents of the MilTime class in standard format
	cout << "Standard format:\t";
	cout << setprecision(2) << getStandHr() << ":" << getMin() << ":" << getSec();
}