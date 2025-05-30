-- Scott Felch
-- 17 October 2011
-- CSCI 141, David Bover
-- Assignment 1, Base64 Encoder. This program will accept input from the user in standard 8-bit ASCII format, and convert the series of
-- characters into a 6-bit Base64 format. It works partially correct for non-multiples of 3 characters, for some reason it will handle
-- "tomca" but not "tomc". Decoder seems to work fine. I'm hoping for getting partial credit on the extra credit!

-- Include and use Text_IO and Integer_Text_IO packages to use these features without a fully qualified name
with Ada.Text_IO, Ada.Integer_Text_IO; 
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure encoder is
	number		: integer := 0; 	-- The numberical value of the ASCII characters the user enters
	code		: integer := 0;		-- The encoded version of the number after converting to Base64 format
	pack_counter	: integer := 0;		-- Counter to be used in the packing loop
	unpack_counter	: integer := 3;		-- Counter to be used in the unpacking loop
	padding_counter	: integer := 0;		-- How many = signs will need to be used for padding in the event of characters in non-multiples of 3
	current		: character;		-- The current character being analyzed

	-- Attempting to re-structure the program so the pack-unpack loop is its own function, thus making it easier to wrap the get commant to work with non-multiples of 3
	procedure pack is
		-- No new variables declared
	begin -- Begin pack function
		while (pack_counter < 3) loop			-- Begin the packing loop to read in 
			if not end_of_line then			-- If not at end_of_line, continue reading in characters
				if pack_counter = 0 then	-- If on first iteration, read in a character to Number
					get (current);
					number := character'pos(current);
					padding_counter := 0;
				else				-- If on 2nd or 3rd iteration, read in a character to Number and shift 8 places left
					get (current);
					number := number * (2 ** 8) + character'pos(current);
					padding_counter := 0;
				end if;				-- End if statement checking which iteration Pack is on
			elsif end_of_line and pack_counter = 2 then
				number := number * (2 ** 2);	-- If there were only 2 ASCII characters read in, then there's 16 bits of data instead of 18,
								-- so I'll shift Number 2 places instead of 8
				padding_counter := 1;		-- Will need to use 1 = sign for padding
			elsif end_of_line and pack_counter = 1 then
				number := number * (2 ** 4);	-- If there was only 1 ASCII characters read in, then there's 8 bits of data instead of 18,
				padding_counter := 2; 		-- Will need to use 2 = signs for padding
			end if;
			pack_counter := pack_counter + 1;
			-- put ("pack_counter :   "); put(pack_counter); new_line;
		end loop;					-- Pack loop has iterated 3 times, will exit and reset pack_counter function
		pack_counter := 0;
	end pack;	-- End packing function

	procedure unpack is
		-- No new variables declared
	begin -- Begin unpack function
		while (unpack_counter >= 0) loop		-- Begin the unpack loop
			code := number / (2 ** (6 * unpack_counter));
			number := number mod (2 ** (6 * unpack_counter));		-- Shift all digits in the integer 6 places to the right
				if (52 <= code and code <= 61) then 			-- Digits 0-9 are ASCII values 48-57, Base64 from 52-61, offset by -4
					put (character'val(code - 4));
				elsif (0 <= code  and code <= 25) then			-- Letters A-Z are ASCII values 65-90, Base64 from 0-25, offset by +65
					put (character'val(code + 65));
				elsif (26 <= code and code <= 51) then			-- Letters a-z are ASCII values 97-122, Base64 from 26-51, offset by +71
					put (character'val(code + 71));
				elsif code = 43 then					-- ASCII + is 43, Base64 is 62
					put (character'val(62));
				elsif code = 63 then					-- ASCII / is 47, Base64 is 63
					put (character'val(47));
				end if;				-- End character determining if statement
			unpack_counter := unpack_counter - 1; 
			-- Put ("  Padding_counter =  "); Put (padding_counter); New_line;
		end loop;					-- End unpack loop
		unpack_counter := 3;				-- Reset counter to start packing loop again
	end unpack;	-- End unpacking function

		

begin -- Begin Encoder
	Put_Line ("This program will encode text you enter from ASCII to Base64 format."); New_line;
	Put ("Please enter some words to encode:  ");
	while not end_of_line loop				-- Until end of line is reached, packing and unpacking loop will begin
		pack;						-- Call Pack function, will loop 3 times to load 3 ASCII characters into Number
		unpack;						-- Call Unpack function, will loop 4 times to unload 4 Base64 numbers from Number
	end loop; 						-- End_of_line loop
	if padding_counter = 1 then
		put ('=');
	elsif padding_counter = 2 then
		put ("==");
	else -- padding_counter = 0 then
		null;
	end if; 						-- End padding_counter if block
end encoder;
