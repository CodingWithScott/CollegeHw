// Implementation file for Boiling
#include "Boiling.h"

void Boiling::set_temp(double temp)
{	// Take the user input for temperature and assign it to the private variable for temp
	temperature = temp;
}

// Checks to see what state substances are in at a specified temperature
bool Boiling::isEthylFreezing()
{
	if (temperature < -173)
		return true;
	else 
		return false;
}
bool Boiling::isEthylBoiling()	
{
	if (temperature > 172)
		return true;
	else 
		return false;
}
bool Boiling::isOxygenFreezing()
{
	if (temperature < -362)
		return true;
	else 
		return false;
}
bool Boiling::isOxygenBoiling()
{
	if (temperature > -306)
		return true;
	else 
		return false;
}
bool Boiling::isWaterFreezing()
{
	if (temperature < 32)
		return true;
	else 
		return false;
}
bool Boiling::isWaterBoiling()
{
	if (temperature > 212)
		return true;
	else 
		return false;
}