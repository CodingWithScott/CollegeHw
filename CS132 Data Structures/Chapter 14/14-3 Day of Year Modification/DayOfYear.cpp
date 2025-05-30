#include "DayOfYear.h"
#include <iostream>
#include <string>
using namespace std;

const int DayYear::days_in_month[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
const int DayYear::total_days[12] = { 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
const string DayYear::name_of_month[12] = { "January", "February", "March", "April", "May", "June", 
	"July", "August", "September", "October", "November", "December" };

DayYear::DayYear()	// Default constructor, not used in this program
{
	days = 1;
}

DayYear::DayYear(int user_integer)		
{
	/* Constructor, which is passed user's selected day. Constructor creates a class which stores
	the day in a private variable. */
	int count = 0;
	days = user_integer;
	//cout << "At the beginning of DayYear(), days = " << days << endl;
}
/*
DayYear::DayYearCon(const a &original)		// Copy constructor, not used in this program
{
	DayYear dy = original.i;
}*/

void DayYear::print()		// Print function, passed "user_days" by the constructor
{
	int count = 0;	// Counter used in while loop
	int DayOfMonth = 0;	// What day of the month the DayOfYear corresponds to
	string month = "";	// String that will hold the name of the month
	// While loop is used to determine what month the DayOfYear falls in
	//while (days >= total_days[count])
	while (count < 12)
	{
		if (days <= total_days[count])
		{
			month = name_of_month[count];
			if (count == 0)
			{
				DayOfMonth = days;
				break;
			}
			else
			{
				DayOfMonth = days - total_days[count - 1];
				break;
			}
		}
		count++;
	}
	/*else if (days < total_days[0])
	{
		DayOfMonth = days;
		month  = name_of_month[0];
	}*/
	// Output the results
	cout << "The date you've entered is " << month << " " << DayOfMonth << endl;
}

DayYear DayYear::operator ++()	// Overloading prefix incrementor
{
	++days;
	return *this;
}

DayYear DayYear::operator ++(int)	// Overloading postfix incrementor
{
	DayYear temp = *this;
	++days;
	return temp;
}

DayYear DayYear::operator --()	// Overloading prefix incrementor
{
	--days;
	return *this;
}

DayYear DayYear::operator --(int)	// Overloading postfix incrementor
{
	DayYear temp = *this;
	--days;
	return temp;
}