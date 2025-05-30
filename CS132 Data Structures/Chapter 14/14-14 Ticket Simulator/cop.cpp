#include "Car.h"
#include "Meter.h"
#include "Ticket.h"
#include "Cop.h"
#include <iostream>
using namespace std;

// The patrol function looks at the number of
// minutes a car has been parked and the number
// of minutes purchased. If the minutes parked is
// greater than the minutes purchased, a pointer
// to a Ticket object is returned. Otherwise
// the function returns NULL.
Ticket* Cop::patrol(Car car, Meter meter)
{
   // Get the minutes parked over the amount purchased.
   int illegalMinutes = car.getTimeParked() - 
                meter.getTime();
      
   // Determine whether the car is illegally parked.     
   if (illegalMinutes > 0)
   {
      // Yes, it is illegally parked.
      // Create a ParkingTicket object.
      ticket = new Ticket(car, illegalMinutes);
   }
      
   // Return the ticket, if any.
   return ticket;
}
// print function
void Cop::print()
{
   cout << "Police Officer Information:\n";
   cout << "\tName: " << name << endl;
   cout << "\tBadge Number: " << badge << endl;
}
