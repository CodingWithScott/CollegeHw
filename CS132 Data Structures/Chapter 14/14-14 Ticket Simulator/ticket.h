#ifndef TICKET_H
#define TICKET_H
#include "Car.h"
#include "Meter.h"

// Constant for the base fine.
const double BASE_FINE = 25.0;
   
// Constant for the additional hourly fine.
const double HOURLY_FINE = 10.0;

class Ticket
{
	private:
		Car ticketed_car;			// Pointer to a ticketed car which hasn't been assigned yet
		//meter* ticketing_meter;		// Pointer to a ticketing meter which hasn't been assigned yet
		int time_overparked;		// Minutes illegally parked
		double amount_fined;		// Double to store the parking ticket fine
	    void setAmountFined();		// Calculate how much the fine is
	
	public:
		// Default Constructor
		Ticket();
	    // Overloaded Constructor
	    Ticket(Car, int);
	    // Copy constructor
	    Ticket(const Ticket &);

		void setCar(Car c)
		{
			ticketed_car = c;
		}

		void setMinutes(int t)
		{
			time_overparked = t;
		}
		
		double getFine() const
		{
			return amount_fined;
		}

		Car getCar() const
	    {
			return ticketed_car;
	    }

		void print();			// Print amount of time overdue
};

#endif