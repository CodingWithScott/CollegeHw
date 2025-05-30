#ifndef METER_H
#define METER_H
#include <iostream>
using namespace std;

class Meter
{
	private:
		int time_purchased;				// Number of minutes purchased
	
	public:
		Meter()							// Default constructor
			{time_purchased = 0;}
		Meter(int t)					// Overloaded constructor, passed the number of minutes parked
			{time_purchased = t;}

		int getTime()					// Return amount of time purchased
			{ return time_purchased;}

		void setMinutesPurchased(int t)	// Set time purchased
			 { time_purchased = t; }

		// Print methods
		void print()
		{ 
			cout << "Meter Information:\n";
			cout << "\tMinutes Purchases: "
				 << time_purchased << endl;
		}
};








#endif