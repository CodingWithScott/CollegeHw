#ifndef MILTIME_H
#define MILTIME_H
#include "Time.h"
#include <iostream>
using namespace std;

class MilTime : public Time
{
	private:
		int milHours;		// Time in 24-hour format. For example, 1:00pm is 1300, 4:30pm is 1630, etc
		int milSeconds;		// Seconds in standard format
	public:
		MilTime();			// Default constructor
		MilTime(int, int);	// Overloaded constructor, will be passed hours and secs in military format
		void setTime(int, int);	/* Accepts arguments to be stored in milHours and milSeconds, and stored
				in the hours, mins, and sec variables of the Time class. */
		int getHour();		// Return the hour in military format
		int getStandHr();	// Return the hour in standard format
		void print();		// Print out contents of MilTime object in military format
		void printStd();	// Print out contents of MilTime object in standard format
};
#endif