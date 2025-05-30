// Specification file for the Employee class, using constructors.
#ifndef EMPLOYEECLASS_H
#define EMPLOYEECLASS_H

#include <string>
using namespace std;

class Employee
{
	private:
		string name;		// Employee's name
		int idNumber;		// Employee's ID number
		string dept;		// Employee's department
		string jobTitle;	// Employee's job title

	public:
		Employee::Employee(string, int, string, string);	// Constructor which accepts name, ID number, dept, and job title
		Employee::Employee(string, int);	// Constructor which accepts name, ID number; dept and job title are blank
		Employee::Employee(int = 0);	// Default constructor which accepts all blank entries

		void setName(string);
		void setID(int);
		void setDept(string);
		void setjobTitle(string);
		string getName() const
		{	return name;		}
		int getID() const
		{	return idNumber;	}
		string getDept() const
		{	return dept;		}
		string getjobTitle() const
		{	return jobTitle;	}
	
};
#endif