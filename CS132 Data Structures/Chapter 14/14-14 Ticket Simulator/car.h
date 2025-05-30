#ifndef CAR_H
#define CAR_H
#include <string>
using namespace std;

class Car
{
	private:
		int time_parked;	// Amount fo time parked in current spot
		string make;		// Make of car (BMW, Mercedes, Volkswagen, etc)
		string model;		// Model of car (3-series, SLK 350, Camry, etc)
		string license;		// License plate of the car
		string color;       // The car's color

	
	public:
		// constructors
		Car();					// Default constructor, receives time parked
		Car(int);				// Overlaoded constructor, receives time parked
		Car(int, string, string, string, string);	// Overlaoded constructor, receives all 5 fields of info
		Car(const Car &);		// Copy constructor

		//methods
		void setMake(string m)			// Specify the make of the car
			{ make = m; }
		void setModel(string m)			// Specify the model of the car
			{ model = m; }
		void setLicense(string m)		// Specify the license plate of the car
			{ license = m; }
		void setColor(string m)			// Specify the color of the car
			{ color = m; }

		int getTimeParked()		// return amount of time parked in spot
			{ return time_parked;}
		string getMake()				// Return the make of the car
			{return make;}
		string getModel()				// Return the model of the car
			{return model;}
		string getLicense()			// Return the license plate of the car
			{return license;}
		string getColor()				// Return the color of the car
			{return color;}
		 
		void print();					// print function

};

#endif