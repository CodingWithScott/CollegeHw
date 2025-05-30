#ifndef COP_H
#define COP_H
#include "Car.h"
#include "Meter.h"
#include "Ticket.h"
#include <string>
using namespace std;

class Cop
{
	private:
		string name;	// Officer's name
		int badge;		// Officer's badge number
		Ticket *ticket; // Pointer to a ticket
	
	public:
		// Default constructor
		Cop()
		{ name = ""; badge = 0; ticket = NULL; }

		//Overloaded constructor
		Cop(string n, int bn)
		{
			name = n;
			badge = bn;
			ticket = NULL;
		}
		// Copy constructor
		Cop(const Cop &cop2)
		{
			name = cop2.name;
			badge = cop2.badge;
			ticket = new Ticket(*cop2.ticket);
		}

		//		cop(string);		// Default constructor, sets default values for name and badge
		//cop(string, int);	// Better constructor, receives custom values for name and badge
		void setName(string n)		// Specify the officer's name
			{ name = n;}
		void setBadge(int n)	// Specify the officer's badge number
			{badge = n;}
		string getName()	// Return the officer's name
			{return name;}
		int getBadge()		// Return the officer's badge number
			{return badge;}

		// patrol function
		Ticket *patrol(Car, Meter);

		// print function
		void print();

};

#endif