-- Scott Felch
-- 17 November 2011
-- CSCI 141, Bover
-- Lab 6, Cryptography, Part 2.
-- This program is to read data in from two text files, one will have the proportional percentages of the letter based on 3 data files, which was determined using program Part 1. (The output of Part 1 
-- is the input of Part 2.) The second text file will have the proportional percentages of the letters in a given Cipher text file. The program will use an algorithm to figure out which letter cipher shift
-- produces the smallest difference in proportional difference. 

-- Ada.Command_Line allows me to use the function Argument_Count, which returns how many arguments have been entered after the executable name in the command line.
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;

procedure Decrypto is
	-- Types I'll be working with
	type data is delta 0.001 range 0.0 .. 100000.000; 		-- Fixed point data type, allow room for up to 100,000 characters to be read in (provided files are ~6500)
	package data_IO is new Fixed_IO(data);
		use data_IO;
	subtype Alphabet is character range 'A' .. 'Z';			-- Subtype of Character which includes only capital letters
	type letter_counter is array (Alphabet) of data; 		-- Set up a type of array of fixed point numbers, using capital A-Z as the index
	
	-- Variables I'll be working with
	Vanilla			:	letter_counter;			-- Array of fixed-point data numbers, holds the frequency data of plaintext file
	Chocolate		:	letter_counter;			-- Array of fixed-point data numbers, holds the frequency data of cipher file
	MagicLetter		:	character;			-- The letter which will be the decryption key for the cipher
	
	-- Exceptions I'll be using
	Invalid_Argument_Count	:	exception;			-- User didn't specify the correct amount (2) of text files for input
	
	procedure Populate is 						-- Populate Vanilla and Chocolate with data from input text files
		Freq		:	file_type;			-- Variable to work with the frequencies output of plaintext
		CipherFreq	:	file_type;			-- Variable to work with the frequencies output of the cipher text
	begin -- Begin Populate
		Open (Freq, In_File, Ada.Command_Line.Argument(1));	-- First file passed in is going to be the plaintext frequency file
		Open (CipherFreq, In_File, Ada.Command_Line.Argument(2));-- Second file passed in is going to be the cipher frequency file
		
		Set_Input(Freq); 					-- Set default input to specific text file, otherwise the get command in the for loop just sits there like a retard and does nothing
		while not end_of_file loop				-- While loop verifies end of file hasn't been reached
			for counter in Alphabet loop			-- For loop populates the array with the information from the text file
				get (vanilla(counter));	
			end loop; -- End A-Z loop
		end loop; -- End end_of_file checking loop
		Close (Freq);

		Set_Input(CipherFreq); 					-- Workaround for a bug, see above
		while not end_of_file loop				-- Same functionality as above
			for counter in Alphabet loop
				get(Chocolate(counter));
			end loop; -- End A-Z loop
		end loop; -- End end_of_file checking loop
		Close (CipherFreq);
	end Populate;
	
	procedure Decode is
		j		:	character;			-- Subscript J, defined as (i + shift) mod 26
		index		:	integer;			-- Index which is going to be used for calculating J as Shift changes
		Diff		:	data := 0.000;			-- Difference of the magnitudes being compared for one given offset
		SmallestDiff	:	data := 100000.000;		-- Smallest difference of all the magnitudes compared, after computing all offsets
	begin -- Begin Decode
		for shift in 0 .. 25 loop				-- This loop calculates the differences for all the different shifts
			for i in Alphabet loop				-- This loop calculates the total difference of values for one given offset (or "shift")
				index := character'pos(i) - 65;
				j := character'val(((index + shift) mod 26) + 65);
				Diff := Diff + abs(vanilla(i) - chocolate(j));
			end loop;
			if Diff < SmallestDiff then			-- If this is the smallest recorded difference yet, keep track of the magnitude of difference
				SmallestDiff := Diff;			-- And record the letter of offset as teh "Magic Number"
				MagicLetter := character'val(character'pos('A') + shift);	
			end if;
			Diff := 0.000;
		end loop;						-- End check for all Shifts loop
	end Decode;
	
	procedure Output is
	begin -- Begin Output
		Put ("The encryption key is:"); Put(ASCII.ht); Put(MagicLetter);
	end Output;

begin -- Begin Decrypto
	if Ada.Command_Line.Argument_Count /= 2 then 			-- Ensure program is being launched correctly with the proper input files before doing anything else
		raise Invalid_Argument_Count;
	else
		Populate;						-- Populate the arrays with values 
		Decode;							-- Perform comparisons
		Output;							-- Print it and bask in the glory of the correct answer
	end if; -- End Argument_Count exception checker

exception
 	when Name_Error => put("File not found!! :(");
	when Event : Invalid_Argument_Count => 
		Put_Line("Bro, you didn't give me the right number of arguments! Program terminating...");
end Decrypto;
