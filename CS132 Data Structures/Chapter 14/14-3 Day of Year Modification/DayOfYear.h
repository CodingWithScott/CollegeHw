#ifndef DAYOFYEAR_H
#define DAYOFYEAR_H
#include <string>
using namespace std;

class DayYear
{
	private:
		int days;
		static const int days_in_month[12];
		static const int total_days[12];
		static const string name_of_month[12];
	public:
		DayYear();	// Default constructor, not really used for anything
		DayYear(int ni);				// constructor, passes new i
		// DayYear DayYearCon(const DayYear&);		// Copy constructor, not used in this program
		void print();		// Function that will output calculated data
		DayYear operator ++();	// Overloading prefix incrementor
		DayYear operator ++(int);	// Overloading postfix incrementor
		DayYear operator --();	// Overloading prefix decrementor
		DayYear operator --(int);	// Overloading postfix decrementor
};
#endif