// Scott Felch
// 29 April 2010
// CS 131, Keith Laidig
// Midterm problem #2

#include <iostream>

int bikes = 0;			// Number of motorcycles
float bike_toll = 0.0;	// Amount of tolls collected from motorcycles
int cars = 0;			// Number of cars
float car_toll = 0.0;	// Amount of tolls collected from cars
int trucks = 0;			// Number of trucks
float truck_toll = 0.0;	// Amount of tolls collected from trucks
int total_vehicles;		// Total number of vehicles passing through in a day
float total_toll;		// Running total of all tolls taken in
char vehicle_type;		// Current vehicle type passing through the tollbooth

int main()
{
	// First introduce the user to the program and tell them how to use it
	std::cout << "Welcome to Toll Master 3000!\n";
	std::cout << "To enter in a toll for a vehicle, type M for motorcycle, C for car,\n";
	std::cout << "or T for truck. Press Q to quit when you're done.\n\n";

	// Now gather data until user indicates they're done entering info
	std::cout << "Enter vehicle type:    ";
	std::cin >> vehicle_type;
	vehicle_type = toupper(vehicle_type);
	while (vehicle_type != 'Q')
	{
		if (vehicle_type == 'M')
			bikes++;
		else if (vehicle_type == 'C')
			cars++;
		else if (vehicle_type == 'T')
			trucks++;
		else
			std::cout << "Invalid entry, please try again\n";
		std::cout << "Enter vehicle type:    ";
		std::cin >> vehicle_type;
		vehicle_type = toupper(vehicle_type);
	}

	// Tally up the numbers
	bike_toll = bikes * 2.0;
	car_toll = cars * 5.0;
	truck_toll = trucks * 10.0;
	total_toll = bike_toll + car_toll + truck_toll;
	total_vehicles = bikes + cars + trucks;

	// And output all the information in a semi-neat fashion
	std::cout << "\nHere's the numbers for the day...\n\n";

	std::cout << "Motorcyces:\t\t" << bikes << "\n";
	std::cout << "Cars:\t\t\t" << cars << "\n";
	std::cout << "Trucks:\t\t\t" << trucks << "\n";
	std::cout << "Total vehicles:\t\t" << total_vehicles << "\n\n";

	std::cout << "Motorcycle tolls:\t$" << bike_toll << "\n";
	std::cout << "Car tolls:\t\t$" << car_toll << "\n";
	std::cout << "Truck tolls:\t\t$" << truck_toll << "\n";
	std::cout << "Total tolls:\t\t$" << total_toll << "\n";

	// End program.
	return 0;
}