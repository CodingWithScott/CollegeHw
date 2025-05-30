-- Scott Felch
-- 20 October 2011
-- CSCI 141
-- Decoder program, will undo everything the Encoder program does and convert the Base64 gibberish back into ASCII English.
-- Decoder functions perfectly as far as I can tell, Encoder is still only partially capable of handling non-multiples of 3.

-- Include and use Text_IO and Integer_Text_IO packages to use these features without a fully qualified name
with Ada.Text_IO, Ada.Integer_Text_IO; 
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure decoder is
	code		: integer := 0;		-- The original encoded Base64 version of the number
	modcode		: integer := 0;		-- Modified version of Base64 code to work with
	number		: integer := 0; 	-- The decoded ASCII version of the Base64 characters
	pack_counter	: integer := 0;		-- Counter to be used in the packing loop, will count from 0 to 3
	unpack_counter	: integer := 3;		-- Counter to be used in the unpacking loop, will count from 2 to 0
	current		: character;		-- The current character being analyzed

begin -- Begin Decoder
	Put_Line ("This program will decode text from Base64 to ASCII format."); New_line;
	Put ("Please enter your string to decode:  ");
	
	while not end_of_line loop						-- Until end of line is reached, packing and unpacking loop will begin
		while (pack_counter < 4) loop					-- Begin the packing loop to read in 
			get (current);
			-- This if block does the conversion from Base64 back to ASCII, using the inverses of the
			-- values used in the Encoding program. If the current character is in the ASCII range of digits 0-9, then I subtract
			-- the ASCII value of 0 to bring the value to the beginning of ASCII index, then add the Base64 offset.
			if (current in '0' .. '9') then 		-- Digits 0-9 are ASCII values 48-57, Base64 from 52-61, offset by -4
				modcode := character'pos(current) - character'pos('0') + 52;
			elsif (current in 'A' .. 'Z') then		-- Letters A-Z are ASCII values 65-90, Base64 from 0-25, offset by +65
				modcode := character'pos(current) - character'pos('A');
			elsif (current in 'a' .. 'z') then		-- Letters a-z are ASCII values 97-122, Base64 from 26-51, offset by +71
				modcode := character'pos(current) - character'pos('a') + 26;
			elsif character'pos(current) = 62 then		-- ASCII + is 43, Base64 is 62
				modcode := 43;
			elsif character'pos(current) = 63 then		-- ASCII / is 47, Base64 is 63
				modcode := 47;
			elsif current = '=' then			-- If a padding character is encountered, modcode is a 0 so no math will be performed with it
				modcode := 0;
			end if; -- End if block of Base64 -> ASCII conversion
		
			--If it's in the first 3 iterations of the loop it will pack in a value
			-- to Number and shift the value 6 digits left, if it's in the final iteration it will just pack in 6 digits to Number.
			if pack_counter = 0 then	
				number := number + modcode;
			else
				number := number * (2 ** 6) + modcode;
			end if; -- End if block within the pack_counter = 0 loop
			pack_counter := pack_counter + 1;
		end loop;
		pack_counter := 0;

		while (unpack_counter >= 0) loop				-- Begin the unpack loop
			code := number / (2 ** (8 * unpack_counter));		-- Read in a 8-bit value in ASCII format
			number := number mod (2 ** (8 * unpack_counter));	-- Shift all digits in the integer 8 places to the right
			put (character'val(code));
			unpack_counter := unpack_counter - 1; 
		end loop;							-- End unpack loop
		unpack_counter := 3;						-- Reset counter to start packing loop again
	end loop; 								-- End_of_line loop
end decoder;
