#include "Car.h"
#include <iostream>
using namespace std;

// Default Constructor
Car::Car()
{
   make = "";
   model = "";
   color = "";
   license = "";
   time_parked = 0;
}

Car::Car(int time_par)			// Overloaded constructor with time parked
{
	time_parked = time_par;
}

// Better constructor, receives time parked, make, model, and license plate
Car::Car(int time_par, string ma, string mo, string li, string col)		
{
	time_parked = time_par;
	make = ma;
	model = mo;
	license = li;
	color = col;
}

// Copy constructor
Car::Car(const Car &car2)
{
   make = car2.make;
   model = car2.model;
   color = car2.color;
   license = car2.license;
   time_parked = car2.time_parked;
}

// print function
void Car::print()
{
   cout << "Car Information:\n";
   cout << "\tMake: " << make << endl;
   cout << "\tModel: " << model << endl;
   cout << "\tColor: " << color << endl;
   cout << "\tLicense Number: " << license << endl;
   cout << "\tMinutes Parked: " << time_parked << endl;
}