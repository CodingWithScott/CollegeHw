// Scott Felch
// 5 May 2010
// CS 131, Keith Laidig
/* Exercise 7-4. This program will add 8% sales tax to a given amount 
and then round the total price to the nearest penny. */

#include <iostream>


float initial_price;		// The initial price of an item the user will enter
float sales_tax;			// The sales tax which will be added to the purchase
float total_price;			// The price after sales tax

int main()
{
	// First I'll explain the purpose of the program to the user and gather input
	std::cout << "This program will calculate sales tax for you.\n";
	std::cout << "Enter the price of the item:    ";
	std:: cin >> initial_price;

	// Now perform calculations
	sales_tax = initial_price * 0.08;
	total_price = sales_tax + initial_price;

	
	// This section will perform the rounding
	total_price = total_price * 100;	/* Move the decimal two places to the right, 
			converting from dollars to pennies. */
	total_price = static_cast<int>(total_price);	/* Convert the amount to an int, 
			truncating any fractions of a penny. */
	total_price = total_price / 100.0;	// Put it back in dollars/cents form
	total_price = static_cast<float>(total_price);		// Convert back to float
	

	// Now output the results
	std::cout << "Okie dokie smokie, here's the rundown...\n";
	std::cout << "Initial price:\t$" << initial_price << "\n";
	std::cout << "Sales tax:\t$" << sales_tax << "\n";
	std::cout << "Total cost:\t$" << total_price << "\n\n";
	std::cout << "That's all she wrote!\n\n";

	// End program
	return 0;
}