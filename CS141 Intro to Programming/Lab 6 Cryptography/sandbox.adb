with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line,Ada.Exceptions;


procedure sandbox is
--	type string is array (Positive range <>) of character;
	max_length	: constant := 1024;
	lower_case 	: string (1 .. max_length);
	lower_length	: integer;
	upper_case 	: string (1 .. max_length);

	
	function toUpper(str : string) return string is
		ucString : string(str'range); -- Declare a mutable string of unbounded length, will be specified length based on inputted string
	begin -- Begin toUpper
		for n in str'range loop
			if str(n) in 'a'..'z' then -- If lower case character detected, replace with capitalized version
				ucString(n) := character'val(character'pos(str(n)) + character'pos('A') - character'pos('a'));
			else
				ucString(n) := str(n);
			end if;
		end loop; -- End loop reading through string
		return ucString;
	end toUpper;

begin 
	put ("Please enter a sentence:    ");
	get_line (Item => lower_case, Last => lower_length);
--get(lower_case);
	upper_case := toUpper(lower_case);
	put("After capitalizing, that string is:   ");
	--put(upper_case);

	for n in 1 .. lower_length loop
		put(upper_case(n));
	end loop;
		
	new_line;	new_line;	new_line;
	put ("the value of 'lower_length' is:    "); put(lower_length);

end sandbox;
