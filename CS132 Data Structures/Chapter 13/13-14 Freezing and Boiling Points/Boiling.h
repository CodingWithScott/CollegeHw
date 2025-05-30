// Specification file for the Boiling class
#ifndef BOILING_H
#define BOILING_H

class Boiling
{
	private:
		double temperature;	// Temperature of a given substance

	public:
		// There will be a series of bools that keep track of whether substances are boiling or freezing at a given temperature
		void set_temp(double temp);
		bool isEthylFreezing();	
		bool isEthylBoiling();	
		bool isOxygenFreezing();	
		bool isOxygenBoiling();	
		bool isWaterFreezing();	
		bool isWaterBoiling();
		

};
#endif