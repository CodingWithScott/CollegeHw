-- Scott Felch
-- 10 November 2011
-- CSCI 141, Assignment 2 Roman Numeral Calculator
-- This is the front-end part of the Roman calculator, which will interact with the user. It calls Roman_IO to translate 

with Ada.Text_IO, Ada.Integer_Text_IO, Roman_IO, Ada.Exceptions;
use Ada.Text_IO, Ada.Integer_Text_IO, Roman_IO, Ada.Exceptions;

procedure Roman_Calculator is
	First, Second, Result : Roman_Numeral;	-- The first and second Roman_Numerals to be worked with, and the result
	Operator	:	character; 	-- What math operation will be performed.
	Valid		:	boolean;	-- Whether or not all values are okay to continue
	
	-- Skip_spaces finds the next non-whitespace character in a line, so a Get command can read a line
	-- without screwing up due to whitespace.
	procedure Skip_spaces is
		Next	: Character; 		-- The current character being analyzed in a line of text
		Endline : Boolean; 		-- Whether or not the current character is the end of the line
	begin 
		Endline := false;
		look_Ahead(Next, Endline);
		while Next = ' ' or Next=ASCII.ht or Endline = true loop
			if Endline = true then
				Skip_line;
			else
				Get(Next);
			end if;	
		look_Ahead(Next, Endline);
		end loop;
	end Skip_spaces;

	-- Look for an operator, so program can tell if it's currently looking at part of a Roman numeral still, or has reached the operator	
	procedure LookForOperator is
		Next	: Character; 		-- The current character being analyzed in a line of text
		Endline : Boolean; 		-- Whether or not the current character is the end of the line
	begin
		Skip_Spaces;
		Look_ahead (Next, Endline);
		Operator := Next;
		case Operator is
			when '+' => Valid := true;
			when '-' => Valid := true;
			when '*' => Valid := true;
			when '/' => Valid := true;
			when others =>
				Put_line ("The operator is not a valid operator. Please try again.");
				Valid := false;
				Skip_line;
			end case;
	end LookForOperator;
	
begin -- Begin Roman Calculator
	Valid := false;
	-- Valid is set to false to enter loop
	while Valid = false loop
		Put ("What are we going to calculate today? ");
		Valid := true; -- Valid is set to true, will be triggered back to false if it fails any of the following tests
		Skip_spaces;
		if Valid = true then
			roman_io.Get(First);
			Skip_spaces;
			LookForOperator;
			if Valid = true then
				Ada.Text_IO.Get (Operator);
				if Valid = true then
					Skip_spaces;
					roman_io.Get (Second);
				end if;
			end if;
		end if;
	end loop; -- End validation loop
	
	-- If all values were valid and passed validation loop, math is performed
	if Operator = '+' then
		Result := First + Second;
	elsif Operator = '-' then
		Result := First - Second;
	elsif Operator = '*' or Operator = 'x' or Operator = 'X' then
		Result := First * Second;
	elsif Operator = '/' then
		Result := First / Second;
	else
		Valid := false;
	end if; -- End math block
	
	-- Output results! 		
	Roman_IO.Put(First);
	Put (" " & Operator & " ");
	Roman_IO.Put(Second);
	Put (" = ");
	Roman_IO.Put(Result);
	
-- If something broke along the way, the exception handler here will yell at the user 
exception
	when Constraint_Error =>
		raise Roman_Numeral_Error with "Bro, that isn't a valid Roman numeral";
	when Event : Roman_Numeral_Error =>
		Put_Line (Exception_Message(Event));
end Roman_Calculator;
