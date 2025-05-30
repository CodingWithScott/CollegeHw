// Scott Felch
#include "Ticket.h"
#include "Meter.h"
#include "Car.h"
#include "Cop.h"
#include <iostream>
#include <string>
using namespace std;

int main()
{
	// Create a ParkingTicket pointer. If a parking ticket
    // is issued, this will point to it.
    Ticket *ticket = NULL;

	// Car has been parked for 65 minutes, it's a Toyota Camry with license 123ABC and it's red
	Car scottsCar(65, "Toyota", "Camry", "123ABC", "Red");		
	// Meter has been fed money for 65 minutes
	Meter meter1(60);
	// Officer Bruce Willis, badge number 12345 is on patrol today
	Cop mrCop("Bruce Willis", 12345);

	ticket = mrCop.patrol(scottsCar, meter1);		// Let the cop patrol
	if (ticket != NULL)
    {
       // Display the officer information.
      mrCop.print();
	  cout << "\n";

      // Display the ticket information.
      ticket->print();
	  cout << "\n";

      // We're done with the ticket, so delete it.
      delete ticket;
      ticket = NULL;
    }
    else
      cout << "No crimes were committed.\n";
	//ticket1.TimeOver();
	
	return 0;
}