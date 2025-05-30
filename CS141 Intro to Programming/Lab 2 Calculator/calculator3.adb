-- Scott Felch
-- 3 October 2011
-- CSCI 141
-- Lab 2, Calculator 3
-- This program will build on Calculator2 to do basic calculations, and spit out an error message 
-- instead of crashing if the user enters an invalid operator, ignore spaces if the user puts in spaces 
-- before an integer or an operator, and will ask the user to try again if they enter an invalid digit or 
-- operator, instead of crashing.

-- Include Text_IO and Integer_Text_IO packages to use these features
with Ada.Text_IO, Ada.Integer_Text_IO; 
-- "Use" clause allows me to call features without using a fully qualified name
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure Calculator3 is
	First, Second, Result : Integer; 	-- The two numbers I'll be working with and the result they will produce
	Operator	:	Character; 	-- What math operation will be performed.
	DigitAValid	:	Boolean; 	-- Whether or not the user entered a valid digit for first number, Digit A
	DigitBValid	:	Boolean;	-- Whether or not the user entered a valid digit for second number, DIgit B
	OperatorValid	:	Boolean; 	-- Whether or not the user entered a valid operator

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

	-- Look_for_digit_A will check the next non-whitespace character and set DigitAValid to false if it's
	-- an invalid character and skip the rest of the input. 
	procedure Look_for_digit_A is
		-- Both of these variables will function the same as in Skip_spaces above.
		Next		: Character; 
		Endline		: Boolean; 
		NextValue	: Integer; -- Temp variable to hold the value of Character'Pos(Next) and compare it to values
					   -- of known valid integers.
		MinValue : constant integer := 48;	-- Lowest acceptable ASCII value for a digit is 48, which is 0
		MaxValue : constant integer := 57;	-- Highest acceptable ASCII value for a digit is 57, which is 9
	begin -- Look_for_digit_A begin
		Skip_spaces; -- Skip spaces to analyze the first non-whitespace character.
		Look_Ahead(Next, Endline);
		-- Analyze the ASCII value of Next to determine if it lies between the range of valid digits or not.
		-- If invalid, display error, set Valid to false, and skip to end of line.
		NextValue := Character'Pos(Next);
		-- Using ASCII table I know that the ASCII value of digits 0-9 are 48-57. If the ASCII value of the 
		-- given character doesn't fall in that range then I know it's an invalid character. 
		if NextValue >= MinValue and NextValue <= MaxValue then
			DigitAValid := true;
		elsif NextValue < MinValue or NextValue > MaxValue then
			DigitAValid := false;
			Skip_line; -- Digit A is invalid, no need to read any further in the line, program is starting over
		end if; -- End Digit A validation If block
	end Look_for_digit_A;
	
	-- Identical to above procedure but will be performing operations on Digit B
	procedure Look_for_digit_B is
		Next		: Character; 
		Endline		: Boolean; 
		NextValue	: Integer; -- Temp variable to hold the value of Character'Pos(Next) and compare it to values
					   -- of known valid integers
		MinValue : constant integer := 48;	-- Lowest acceptable ASCII value for a digit is 48, which is 0
		MaxValue : constant integer := 57;	-- Highest acceptable ASCII value for a digit is 57, which is 9
	begin -- Look_for_digit_B begin
		Skip_spaces; -- Skip spaces to analyze the first non-whitespace character.
		Look_Ahead(Next, Endline);
		-- Analyze the ASCII value of Next to determine if it lies between the range of valid digits or not.
		-- If invalid, display error, set Valid to false, and skip to end of line.
		NextValue := Character'Pos(Next);
		-- Using ASCII table I know that the ASCII value of digits 0-9 are 48-57. If the ASCII value of the 
		-- given character doesn't fall in that range then I know it's an invalid character. 
		if NextValue >= MinValue and NextValue <= MaxValue then
			DigitBValid := true;
		elsif NextValue < MinValue or NextValue > MaxValue then
			DigitBValid := false;
			Skip_line; -- Digit B is invalid, no need to read any further in the line, program is starting over
		end if; -- End Digit B validation if block
	end Look_for_digit_B;

	-- Look_for_operator checks to see if a valid operator has been input, which will set flag appropriately to allow
	-- the program to continue, or prompt user to start over.
	procedure Look_for_operator is
		-- Both of these variables will function the same as in Look_for_digit_A and Look_for_digit_B above
		Next 		: Character; 
		Endline 	: Boolean; 
	begin -- Look_for_operator begin
		Skip_spaces; -- Skip whitespace to analyze first actual character.
		Look_Ahead(Next, Endline);
		-- If Next is a valid operator, set OperatorValid to true, otherwise set flag to false and skip to end of line.
		if Next = '+' or Next = '-' or Next = '*' or Next = 'X' or Next = 'x' or Next = '/' then
			OperatorValid := true; 
		else  
			OperatorValid := false;
			Skip_line; -- Operator is invalid, no need to read any further in the line, program is starting over.
		end if; -- End Operator validation if block
	end Look_for_operator;

begin -- Calculator3 begin
	OperatorValid	:= false; 
	DigitAValid	:= false;
	DigitBValid	:= false;
	-- All 3 flags set to false by default, the following while loop will not allow the user to continue until valid
	-- information has been entered for all 3 required values.
	while not (DigitAValid = true and DigitBValid = true and OperatorValid = true) loop
		Put ("What are we going to calculate today? ");
		Look_for_digit_A;		
		-- This set of nested if statements will validate Digits and Operators one at a time. If any of them fail,
		-- it will exit the if block.
		if DigitAValid = true then
			Get (First);
			Look_for_operator;
			if OperatorValid = true then
				Get (Operator);
				Look_for_digit_B;
				if DigitBValid = true then
					Get (Second);
				elsif DigitBValid = false then
					Put_line ("Error: Invalid character for Digit B, not a number. Program rebooting..."); New_line;	
				end if; -- End Digit B Validation
			elsif OperatorValid = false then
				Put_line ("Error: Invalid character, not an operator. Program rebooting..."); New_line;
			end if; -- End Operator Validation
		elsif DigitAValid = false then
			Put_line ("Error: Invalid character for Digit A, not a number. Program rebooting..."); New_line;
		end if; -- End Digit A Validation
	end loop; -- End Validation loop
	
	-- If user enters a plus sign then addition is performed.
	if Operator = '+' then
		Result := First + Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;

	-- If user enters a minus sign then subtraction is performed.
	elsif Operator = '-' then
		Result := First - Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;

	-- If user enters a star or X then multiplication is performed.
	elsif Operator = '*' or Operator = 'x' or Operator = 'X' then
		Result := First * Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;

	-- If user enters a slash then division is performed.
	elsif Operator = '/' then
		Result := First / Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;
	end if; -- End math operations If block
	
	Put_line ("Welp, it's been fun, keep it real!!");
end Calculator3;
