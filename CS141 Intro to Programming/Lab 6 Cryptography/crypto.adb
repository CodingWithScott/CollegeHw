-- Scott Felch
-- 15 November 2011
-- CSCI 141, Bover
-- Lab 6, Cryptography, Part 1.
-- This program is to read data from one or more data files, count the number of occurrences of each letter and output the proportional frequency of each letter.

-- Ada.Command_Line allows me to use the function Argument_Count, which returns how many arguments have been entered after the executable name in the command line.
-- For example, when running "./letter_count Data1.txt Data2.txt Data3.txt" Argument_Count will return the value 3.
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;

procedure Crypto is 
	-- Types I'll be working with
	type data is delta 0.001 range 0.0 .. 100000.0; 		--Floating point data type, allow room for up to 100,000 characters to be read in (provided files are ~6500)
	package data_IO is new Fixed_IO(data);
		use data_IO;
	subtype capital_letter is character range 'A' .. 'Z';		-- Subtype of Character which includes only capital letters
	type letter_counter is array (capital_letter) of data; 		-- Set up a type of array of fixed point data types, using capital A-Z as the index

	-- Variables I'll be working with
	Input			:	file_type;			-- Variable to work with the input text files		
	Output			:	file_type;			-- Variable to work with the output text file
	char_count		:	data := 0.0;			-- Count of the total number of characters in the data file
	current_char		:	character;			-- Current character being analyzed
	letter_occurrences 	:       letter_counter := (others => 0.0);-- Array of letter_counter type to keep track of occurences of all the letters in the input text file
	
	-- Exceptions I'll be using
	Invalid_Argument_Count	:	exception;			-- User didn't specify any text files to open
	
	-- This function will read in a character and return the capitalized version of the character.
	function toUpper(char : character) return character is
		ucChar : character;	-- Mutable version of the inputted character, to return the capitalized version
	begin -- Begin toUpper
		if char in 'a'..'z' then -- If lower case character detected, replace with capitalized version
			ucChar := character'val(character'pos(char) + character'pos('A') - character'pos('a'));
		else
			ucChar := ucChar;
		end if;
		return ucChar;
	end toUpper;
	
	procedure Accumulate (Filename : in string) is
		--Variables for Look_ahead to function
		Next		: Character; 
		Endline		: Boolean; 
	begin
		Open (Input, In_File, Filename);		-- Open text file passed in by command line, text file being opened depends on how many iterations through program have been done
		Set_Input(Input); 				-- Set default input to my custom file variable type, program won't ever expect anything from keyboard, won't require parameters for while not end_of_file, etc
		while not end_of_file loop 			-- Loop continuously until hitting end of file, exit statement at the bottom of this loop
			Look_ahead(next, endline);
			if endline then				-- If an endline is encountered, skip over it
				skip_line;
			else 					-- If not end of line, proceed to process data
				get(current_char);
				if current_char in 'a'..'z' then -- If lower case character detected, capitalize it, increment char_counter, and increment appropriate section of array
					current_char := toUpper(current_char);
					char_count := char_count + 1.0;
					letter_occurrences(current_char) := letter_occurrences(current_char) + 1.0;
				elsif current_char in 'A'..'Z' then -- If current_char is already a capital letter, increment appropriate section of Letter_Occurrences array and increment char_counter
					letter_occurrences(current_char) := letter_occurrences(current_char) + 1.0;
					char_count := char_count + 1.0;
				else				-- If current_char is not a letter, don't do anything
					char_count := char_count + 0.0;
				end if; -- End character verification if statement
			end if; -- End end_of_line if block
		end loop; 	-- End End_of_file loop
		Close(Input);	-- Close input file before exiting program
	end Accumulate;
	
	procedure Print is
		percent	: data;		-- Proportion of the letter in all of the text file
	begin
		for n in character range 'A' .. 'Z' loop
			Percent := (letter_occurrences(n) / char_count);
			put(Percent);
			New_line;
		end loop;
	end Print;
	
begin -- Begin Crypto

	if Ada.Command_Line.Argument_Count = 0 then 	-- Ensure program is being launched correctly with an input file before doing anything else
		raise Invalid_Argument_Count;
	else
		for I in 1 .. Ada.Command_Line.Argument_Count loop	-- Loop through the program once per input text file
			Accumulate(Ada.Command_Line.Argument(I));	-- Call the Accumulate function to analyze each text file sequentially
		end loop;
	end if; -- End Argument_Count validation
	
	Print; -- Output results to text file

exception
	when Name_Error => put("File not found!! :(");
	when Event : Invalid_Argument_Count => 
		Put_Line("Bro, you didn't include any arguments! Program terminating...");
end Crypto;
