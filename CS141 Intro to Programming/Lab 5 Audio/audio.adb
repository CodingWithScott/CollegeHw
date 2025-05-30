-- Scott Felch
-- 1 November 2011
-- CSCI 141, David Bover
-- Lab 5, Statistical Analysis. This program will read in data from a series of text files containing data from audio clips, then output 6 
-- pieces of data about them: 1) the number of data values in a file, 2) the average of the data values, 3) the variance of the data values, 
-- 4) the average power of the data values, 5) the average magnitude, and 6) the number of zero crossings (number of times there is a 
-- change of sign between successive values. The program will then neatly output the statistical properties.

-- Include and use Text_IO and Integer_Text_IO packages to use these features without a fully qualified name
with Ada.Text_IO, Ada.Integer_Text_IO; 
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure Audio is
	type audval is digits 10;	-- Create a new type for handling the data in the files, which needs to be accurate up to 12 decimal places
	package Audval_IO is new Ada.Text_IO.Float_IO(audval);	-- Instantiate Float_IO able to handle type 'audval'
	use Audval_IO;	
	
	-- Values calculated as I go
	cur_val		:	audval;			-- Current value in a data file being analyzed	
	prev_val	:	audval	:= 0.0;		-- Previous value analyzed, for comparing zero crossings
	number_values	:	audval	:= 0.0;		-- Number of data values in an audio file
	sum_values	:	audval 	:= 0.0;		-- Sum of all data values in an audio file, or sum of all powers
	sum_squared	:	audval	:= 0.0;		-- Sum of every data value squared and put together (for use in variance)
	sum_mag		:	audval	:= 0.0;		-- Sum of absolute values of all the values in a file, or sum of all magnitudes
	zero_crossings	:	integer	:= 0;		-- Number of times there is a change of sign in successive values
	
	-- Values stored in slightly prettier versions, for outputting
	number_vals_integer	: integer 	:= 0;	-- Integer to output number_values in an integer format
		
	function CalcAverage (total : in audval; number_values : in audval) 
			return audval is 
		avg_value : audval := 0.0;		-- Average of all values
	begin	-- Begin Calculate Average
		avg_value := total / number_values;
		return avg_value;
	end CalcAverage;
	
	function CalcVariance (sum_squared : in audval; number_values : in audval; avg_value : in audval) 
			return audval is
			variance : audval;		-- Variable to hold the variance to be calculated and returned
	begin 	-- Beging Calculate Variance
		variance := (1.0 / number_values) * (sum_squared) - avg_value**2;
		-- Answer is returned in V^2 format, can't get square root to work properly here for some reason but Clark says V^2 is fine.
		return variance;
	end CalcVariance;
	
	function CalcAvgPower (sum_square : in audval; number_values : in audval) 
			return audval is
		avg_power : audval := 0.0;		-- Average power of all values, each value is squared
	begin -- Begin Calculate Average Power
		avg_power := (1.0 / number_values) * (sum_square);
		return avg_power;
	end CalcAvgPower;
	
	function CalcAvgMag (sum_mag : in audval; number_values : in audval)
			return audval is
		avg_magnitude : audval := 0.0;		-- Average magnitude of all values
	begin -- Begin Calculate Average Magnitude
		avg_magnitude := (1.0 / number_values) * sum_mag;
		return avg_magnitude;
	end CalcAvgMag;
		
		
begin -- Begin Audio
	New_line;
	put_line ("Feed me numbers, so that I may process them for you!  ");
	put_line ("OM NOM NOM NOM..."); New_line;
	
	-- This while loop will read in numeric values until the end of the file, to collect data
	while not end_of_file loop
		loop	-- I know that the Get command is going to raise an exception in one of the files so I'm enclosing it in a loop w/ exception handler
			begin -- Begin mini-exception handler block
				Get (cur_val);			-- Read in current value
				Skip_line;			-- Skip to next line, Float_IO doesn't know how to do that properly for some reason
				exit;				-- Exit loop if value was read in successfully
			exception 
				when others => 
				Put_line("Oh crap, something bad happened! I'm not totally sure what, but we're going to continue processing as normal, k?  ");	
				Skip_line;
			end; -- End mini-exception handler block
		end loop;

		sum_values := sum_values + cur_val;		-- Add current power to running total of values
		sum_mag := sum_mag + abs(cur_val);		-- Add current magnitude to running total of magnitude
		sum_squared := sum_squared + (cur_val ** 2);	-- Add square of current value to running total of sum squared

		if (prev_val < 0.0) and (cur_val > 0.0) then	-- Increment zero_crossing when going - to + 
			zero_crossings := zero_crossings + 1;
		elsif (prev_val > 0.0) and (cur_val < 0.0) then-- Increment zero_crossing when going + to -
			zero_crossings := zero_crossings + 1;
		end if;
		
		prev_val := cur_val;				-- Set prev_val to cur_val, so next iteration of loop will know what to compare against
		number_values := number_values + 1.0; 		-- Increment counter to keep track of number of values
	end loop; -- End loop when end of file is reached
	
	number_vals_integer := integer(number_values);
		
	Put_line ("Yum, those were some delicious numbers! Here's some fun facts about them..."); New_line;
	
	Put ("Number of data values:"); 
	Put (ASCII.ht); Put (ASCII.ht); Put (ASCII.ht); Put (ASCII.ht); 
	Put(number_vals_integer); New_line;
	
	Put ("Average of the data values:"); 
	Put (ASCII.ht); Put (ASCII.ht); 
	Put( CalcAverage(sum_values, number_values) ); New_line;
	
	Put ("Variance^2 of the data values:"); Put (ASCII.ht); Put (ASCII.ht);
	Put( CalcVariance(sum_squared, number_values, CalcAverage(sum_values, number_values))); New_line;
	
	Put ("Average power of the data values:"); Put (ASCII.ht); 
	Put( CalcAvgPower (sum_squared, number_values)); New_line;
	
	Put ("Average magnitude of the data values:"); 
	Put(ASCII.ht); 
	Put( CalcAvgMag(sum_mag, number_values)); New_line;
	
	Put ("Number of zero crossings:"); Put (ASCII.ht); Put (ASCII.ht); Put(ASCII.ht); 
	Put(zero_crossings); 
	New_line; New_line;
	
	Put ("Welp, it's been real, see ya later!!"); New_line; New_line;

end Audio;
