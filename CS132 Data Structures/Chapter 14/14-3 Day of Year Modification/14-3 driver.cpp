// Scott Felch
// Exercise 14-3, convert a number (1-365) to a Month/Day format (November 25)
//Some reference info...
/***********************************\
* Month		# of days  Days in year *
* --------------------------------  *
* January		31		1-31		*
* February		28		32-59		*
* March			31		60-90		*
* April			30		91-120		*
* May			31		121-151		*
* June			30		152-181		*
* July			31		182-212		*
* August		31		213-243		*
* September		30		244-273		*
* October		31		274-304		*
* November		30		305-334		*
* December		31		335-365		*
\***********************************/
#include <iostream>
#include "DayOfYear.h"
using namespace std;

int main()
{
	int user_num;	// User's number he enters
	cout << "Welcome to Date Converter 9000!\n";
	cout << "This program will convert a number (1-365) into a date.\n";
	cout << "Ready? Please enter a number:   ";
	cin >> user_num;
	// Make sure number is valid before proceeding
	if (user_num > 0 && user_num < 366)
	{
		DayYear A(user_num);
		A.print();

		cout << "Now to test the incrementors and decrementors...\n";
		A++;
		A.print();
		++A;
		A.print();
		A--;
		A.print();
		--A;
		A.print();
		cout << "It works! :D\n";
	}
	else if (user_num > 365 || user_num < 1)
		cout << "ERROR: Invalid number!\n";

	cout << "\nWelp, that was fun! Peace out brotato chip!\n";
	return 0;
}

/*	a blah1(400);
	a blah2(369);

	cout << blah1.puke() << "\n";
	cout << blah2.puke() << "\n";

	cout << (blah1++).puke() << "\n";
	cout << blah1.puke() << "\n";
	cout << (++blah2).puke() << "\n";
	cout << blah2.puke() << "\n";		*/
