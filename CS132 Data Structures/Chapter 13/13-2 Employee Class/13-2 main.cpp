// Scott Felch
// 4 October 2010
// Assignment 13-2. Way too lazy to write the summary here right now.

// To do: build employees to test all the different constructor types

#include <iostream>
#include <string>
#include "EmployeeClass.h"
using namespace std;

int main()
{
	// Create 3 employees using one of the constructors I made, the 4th one is empty and demonstrates the default constructor
	Employee emp1("Susan Meyers", 47899, "Accounting", "Vice President");
	Employee emp2("Mark Jones", 39119, "IT", "Programmer");
	Employee emp3("Joy Rogers", 81774, "Manufacturing", "Engineer");
	Employee emp4(5);	/* If I don't put anything in the ()s, the code won't compile. However if I do put something,
				it doesn't seem to impact the outputted data in any way, so I just put a 5 cuz I like the number 5. */

	// Output the data for each employee
	cout << "Employee 1:\n";
	cout << "Name:  " << emp1.getName() << endl;
	cout << "ID Number:  " << emp1.getID() << endl;
	cout << "Department:  " << emp1.getDept() << endl;
	cout << "Job title:  " << emp1.getjobTitle() << "\n\n";
	
	cout << "Employee 2:\n";
	cout << "Name:  " << emp2.getName() << endl;
	cout << "ID Number:  " << emp2.getID() << endl;
	cout << "Department:  " << emp2.getDept() << endl;
	cout << "Job title:  " << emp2.getjobTitle() << "\n\n";

	cout << "Employee 3:\n";
	cout << "Name:  " << emp3.getName() << endl;
	cout << "ID Number:  " << emp3.getID() << endl;
	cout << "Department:  " << emp3.getDept() << endl;
	cout << "Job title:  " << emp3.getjobTitle() << "\n\n";

	cout << "Employee 4:\n";
	cout << "Name:  " << emp4.getName() << endl;
	cout << "ID Number:  " << emp4.getID() << endl;
	cout << "Department:  " << emp4.getDept() << endl;
	cout << "Job title:  " << emp4.getjobTitle() << "\n\n";
	return 0;
}
		