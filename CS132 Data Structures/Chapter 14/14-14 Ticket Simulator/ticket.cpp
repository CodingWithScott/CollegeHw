#include "Ticket.h"
#include <iostream>
#include <iomanip>
using namespace std;

//ticket::ticket(car& offending_car, meter& tattling_meter)	// Default constructor
//{
//	ticketed_car = &offending_car;		// Assign address (on the right) to the pointer (on the left)
//	ticketing_meter = &tattling_meter;
//}
//
//void ticket::TimeOver()
//{
////	ticketing_meter->getTime()
//	cout << "Time purchased:   " << ticketing_meter->getTime() << "\n";
//	cout << "Time parked:    " << ticketed_car->getTimeParked() << "\n";
//}
//
//double setAmountFined()
//{
//	// Calculate the amount of fine. $25 for <= 1 hour, $10 hour after that
//	if (

// Default constructor
Ticket::Ticket()
{   
   time_overparked = 0;
   amount_fined = 0.0;
}

Ticket::Ticket(Car aCar, int min)
{
   ticketed_car = aCar;
   time_overparked = min;
      
   // Calculate the fine.
   setAmountFined();
}

Ticket::Ticket(const Ticket &ticket2)
{
   ticketed_car = ticket2.ticketed_car;
   amount_fined = ticket2.amount_fined;
}

//   This method calculates the amount of the parking fine.
void Ticket::setAmountFined()
{
   // Get the time parked in hours.
   double hours = time_overparked / 60.0;
      
   // Get the hours as an int.
   int intHours = static_cast<int>(hours);
      
   // If there was a portion of an hour, round up.
   if ((hours - intHours) > 0)
      intHours++;
      
   // Assign the base fine.
   amount_fined = BASE_FINE;
      
   // Add the additional hourly fines.
   amount_fined += (intHours * HOURLY_FINE);
}
void Ticket::print()
{
   // Print car information.
   ticketed_car.print();
   
   // Print ticket information.
   cout << "Ticket Information:\n";
   cout << "\tMinutes in violation: " << time_overparked << endl;
   cout << "\tFine: $ " << setprecision(2) << fixed
        << showpoint << amount_fined << endl;
}