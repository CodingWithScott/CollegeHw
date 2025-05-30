// Scott Felch
// 22 April 2010
// CS 131, Keith Laidig
// Exercise 6-5
/* This program will accept a user input for an employee's hourly wage and number of hours worked during a week,
then calculate out total pay. */

#include <iostream>

float base_pay;							// The employee's hourly pay-rate.
float ot_hourly_payrate = 0;			/* The employee's overtime hourly pay-rate. Initialized to 0, in case no OT
					is worked, calculations won't be screwed up. */
float total_hours;						// Total number of hours worked for this pay period.
float ot_hours = 0;						// Number of hours worked overtime, above and beyond standard 40 hours.
float norm_hours;						// Number of normal hours worked, up to and including 40 hours.
float norm_pay;							// Amount of money earned during normal hours.
float ot_pay = 0;	/* Amount of money earned during overtime hours. Initialized to 0, in case no OT
					is worked, calculations won't be screwed up. */
float total_pay;						// Total amount of money earned.

int main()
{
	// First explain the purpose of the program to the user and get their base pay, and hours worked.
	std::cout << "This program will compute your paycheck for you.\n";
	std::cout << "Please enter your hourly payrate:   $";
	std::cin >> base_pay;
	std::cout << "Please enter the total number of hours worked:    ";
	std::cin >> total_hours;

	// Now come the calculations.
	ot_hours = total_hours - 40;			// Determines if any overtime has been worked.
	/* If the employee worked overtime, this statement determines pay for that period. Otherwise this section
	is skipped. */
	if (ot_hours > 0)
	{
		ot_hourly_payrate = base_pay * 1.5;		// Determine hourly overtime payrate.
		ot_pay = ot_hours * ot_hourly_payrate;	// Determine total overtime pay.
	}
	
	norm_hours = total_hours - ot_hours;
	norm_pay = base_pay * norm_hours;
	total_pay = norm_pay + ot_pay;

	// Now output the results
	std::cout << "\n\nTotal hours worked:\t\t" << total_hours << "\n";
	std::cout << "Normal hours worked:\t\t" << norm_hours << "\n";
	std::cout << "Overtime hours worked:\t\t" << ot_hours << "\n";
	std::cout << "Normal pay:\t\t\t$" << norm_pay << "\n";
	std::cout << "Overtime pay:\t\t\t$" << ot_pay << "\n\n";
	std::cout << "Total pay:\t\t\t$" << total_pay << "\n\n";

	return (0);
}