-- Scott Felch
-- 2 February 2012
-- CSCI 145, Lab 3
-- This program will read in encryped text from an input file and then decrypt it using a Grid Cypher until it matches the provided plaintext file.

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions, Ada.Directories;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;

procedure Grid is
	-------------------- Exceptions ---------------------
	Not_Enough_Arguments	:	exception;		-- Exception which will be raised if user enters less than 3 command line arguments
	Too_Many_Arguments	:	exception;		-- Exception which will be raised if user enters more than 3 command line arguments
	Invalid_Arguments	:	exception;		-- Exception which will be raised if user enters unusable data for the command line arguments 
	
	--*************** Custom Data Types ***************--
	------------------- Varying String ------------------
	type Varying_String (Maximum : Positive) is record	-- Custom data type to allow for strings of varying length, to get around Ada's stupid string restrictions.
		Length	:	natural;
		Value	:	String (1..Maximum);
	end record;
		
	procedure Put(input : in Varying_string) is		-- Overloaded Put statement for use with Varying_Strings, otherwise some garbage characters are printed.
	begin
		for I in 1 .. input.length loop
			put(input.value(I));
		end loop;
	end Put; 
	
	function Get(input : in string) return varying_string is -- Overloaded Get function to read in a string of any length and store it as a Varying_String
		temp	:	varying_string(1024);		 -- Varying string that can handle up to 1024 characters
	begin
		temp.length := input'length;
		for I in 1 .. temp.length loop
			temp.value(I) := input(I);
		end loop;
		return temp;
	end Get;
	
	function ToString(input : in varying_string) return string is	
	begin							-- Small function to convert from Varying_String to standard string, for procedures/functions expecting strings.
		return input.value(1..input.length);	
	end ToString;
	
	----------------- Variables ------------------	
	min		:	positive;		-- The minimum grid width to be tried, as a positive integer.
	min_string	:	varying_string(10);	-- The minimum grid width to be tried, stored temporarily as a string in order to read from command line arguments, will be converted to a 
							-- positive integer. Can be up to 10 digits.
	max		:	positive;		-- The maximum grid width to be tried, as a positive integer.
	max_string	:	varying_string(10);	-- The maximum grid width to be tried, stored temporarily as a string in order to read from command line arguments, will be converted to a 
							-- positive integer. Can be up to 10 digits.
	cypher		:	file_type;		-- Variable to use for cypher input file.
	cypher_string	:	varying_string(150) ;	-- Varying_string to hold the data from the cypher input file. Longest input is 111 characters, will allow 150 just to be safe.
	curr_char	:	character;		-- Current character being analyzed in the cypher file.
	
	----------------- Procedures -----------------
	procedure Initialize is
	begin
		-- First I'll make sure user provided usable information in the command line arguments
		if Argument_Count > 3 then				-- Too many or too few arguments raises an exception, otherwise I continue to Argument_Count = 3	
			raise Too_Many_Arguments;
		elsif Argument_Count < 3 then		
			raise Not_Enough_Arguments;
		elsif Argument_Count = 3 then
			for count in 1 .. Argument(1)'length loop	-- Ada reads command line arguments as strings so I have to store the argument as a string before I can convert to a natural integer
				min_string.value(count) := Argument(1)(count);
			end loop;
			Get(min_string.value, min, min_string.length);	-- Read from String: min_string.value, store as Natural in: min, store length of min_string.value in min_string.length
			
			for count in 1 .. Argument(2)'length loop
				max_string.value(count) := Argument(2)(count);
			end loop;
			Get(max_string.value, max, max_string.length);	-- Read from String: max_string.value, store as Natural in: max, store length of max_string.value in max_string.length
			-- If something other than a usable number is entered for Argument 1 or 2, a Data_Error exception will be raised when the Get command is called
			
			if min > max then	-- If the minimum entered is less than maximum then a Data_Error will be raised
				raise Data_Error;
			end if;
			
			Open(cypher, in_file, Argument(3)); 	-- Will use Cypher as the variable referring to the cypher file
			cypher_string.length := integer(Ada.Directories.Size(Argument(3))) - 1;	-- The length of the input file (in characters) is stored in cypher_string
			
			for count in 1 .. (cypher_string.length) loop			-- The cypher is read into cypher_string char by char in this for loop
				Get(cypher, curr_char);						-- Have to subtract 1 from cypher_string.length or else it includes the EOF control character in the string
				cypher_string.value(count) := curr_char;
			end loop;

			put("Filename = "); put(Argument(3)); new_line;

		end if; -- End Argument_Count settings
	end Initialize;
	
	procedure Decode(width : in positive) is
		---------------- Varying 2-D Array ---------------
		type Varying_Array is array(Positive range <>, Positive range <>) of Character;
		curr_width	:	positive := width;				-- Current width of the 2 dimensional array, based on Width in the function call
		curr_length	:	positive := (cypher_string.length / width) + 1;	-- Current length allows for enough rows to fit all characters, may have a few empty cells
		char_counter	:	positive := 1;					-- Count how many characters have been read into the string
		remainder	:	natural := ((cypher_string.length) mod width);	-- The number of empty blank spots that will need to be on the bottom right of the grid
		short_column	:	boolean := false;				-- Flag to indicate whether current row is full size or short by 1 block
	begin
		declare 
			Matrix : Varying_Array(1..curr_length, 1..curr_width);
		begin
			Matrix := (others => (others => ' '));
			
			for Column in 1 .. curr_width loop		-- This will go through the cypher_string and put each letter into the array going left to right, top to bottom.
				if Column <= remainder then		-- The first few rows will be regular width, once those are done and I've moved to short rows, decrease the curr_width by 1
					short_column := false;		-- which will allow for the empty space on the far right side.
				else
					short_column := true;
				end if;
				
				if not short_column then
					for Row in 1 .. curr_length loop
						if char_counter < (cypher_string.length + 1) then
							Matrix(Row, Column) := cypher_string.value(char_counter); 
							char_counter := char_counter + 1;
						end if;
					end loop; 
				elsif short_column then			-- Once the rows which are 1 square shorter have been reached, only write from columns 1 to 5
					for Row in 1 .. (curr_length - 1) loop
						if char_counter < (cypher_string.length + 1) then
							Matrix(Row, Column) := cypher_string.value(char_counter); 
							char_counter := char_counter + 1;
						end if;
					end loop;
				end if; -- End Short_row check
			end loop; 

			char_counter := 1;				-- Reset char_counter to avoid printing out garbage characters
			for Row in 1 .. curr_length loop
				for Column in 1 .. curr_width loop
					if char_counter < (cypher_string.length + 1) and Matrix(Row, Column) /= ' ' then
						put(Matrix(Row, Column));
						char_counter := char_counter + 1;
					end if;
				end loop;
			end loop; 
		end; -- End Matrix declaration block
	end Decode;	
	
begin -- Begin Grid
	Initialize;			-- Set Min and Max widths, read in Cyphertext file
	for AttemptedWidth in min .. max loop	-- Attempt to decode using a range of guesses of what the width may be
		put("Grid width  "); put(AttemptedWidth, width => 2); put(": '");
		Decode(AttemptedWidth);	put("'"); new_line;
	end loop;

exception
	when Event : Not_Enough_Arguments =>
		Put_Line("Error: You didn't enter enough arguments! You need to have 3 command line arguments for the program to work.");
		put_line("Example: ./grid [Min] [Max] input.txt");
		put_line("GOOD: ./grid 3 5 input.txt");
		put_line("BAD:  ./grid input.txt");
	when Event : Too_Many_Arguments =>
		Put_Line ("Error: You entered too many arguments! You need to have 3 command line arguments for the program to work.");
		put_line("Example: ./grid [Min] [Max] input.txt");
		put_line("GOOD: ./grid 3 5 input.txt");
		put_line("BAD:  ./grid 3 5 8 input.txt");
	when Data_Error =>
		Put_Line("Error: One or more of your arguments didn't make any sense! Min and max have to be positive integers, and min must be less than max.");
		put_line("Example: ./grid [Min] [Max] input.txt");
		put_line("GOOD: ./grid 3 5 input.txt");
		put_line("BAD:  ./grid 7 4 input.txt");
		put_line("BAD:  ./grid potato 4 input.txt");
	when Name_Error =>
		Put_Line("Error: That file couldn't be found! Did you make a typo?");
end Grid;
