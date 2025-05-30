// Specification file for the Time class, taken from textbook
#ifndef TIME_H
#define TIME_H

class Time
{
protected:
   int hour;
   int min;
   int sec;
public:
   // Default constructor
   Time() 
      { hour = 0; min = 0; sec = 0; }
   
   // Constructor
   Time(int h, int m, int s) 
      { hour = h; min = m; sec = s; }

   // Mutator functions, added by me. Why is the author's code formatted with spacebars and ugly?
   void setHour(int h)
   { hour = h; }
	void setMin(int m)
   { min = m; }
	void setSec(int s)
   { sec = s; }

   // Accessor functions
   int getHour() const
      { return hour; }

   int getMin() const
      { return min; }

   int getSec() const
      { return sec; }
};
#endif
