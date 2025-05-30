// Implementation file for EmployeeClass.
// Implementation files contain actual functions, header file just contains prototypes
#include "EmployeeClass.h"

	Employee::Employee(string n, int id, string d, string j)	// Constructor which accepts name, ID number, dept, and job title
	{
		name = n;
		idNumber = id;
		dept = d;
		jobTitle = j;
	}
	Employee::Employee(string n, int id)	// Constructor which accepts name, ID number; dept and job title are blank
	{
		name = n;
		idNumber = id;
		dept = "";
		jobTitle = "";
	}
	Employee::Employee(int)	// Default constructor which accepts all blank entries
	{
		name = "";
		idNumber = 0;
		dept = "";
		jobTitle = "";
	}

void Employee::setName(string n)		// Set the employee's name
{	name = n;			}
void Employee::setID(int id)		// Set the employee's ID number
{	idNumber = id;		}
void Employee::setDept(string d)		// Set the employee's department
{	dept = d;			}
void Employee::setjobTitle(string j)	// Set the employee's job title
{	jobTitle = j;		}
