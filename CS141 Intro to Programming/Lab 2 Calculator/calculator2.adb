-- Scott Felch
-- 3 October 2011
-- CSCI 141
-- Lab 2, Calculator 2
-- This program will build on Calculator1 to do basic calculations, and spit out an error message 
-- (instead of crashing) if the user enters an invalid operator, and it will (new feature) ignore 
-- spaces if the user puts in spaces before an integer or the operator. 

-- Include Text_IO and Integer_Text_IO packages to use these features
with Ada.Text_IO, Ada.Integer_Text_IO; 
-- "Use" clause allows me to call features without using a fully qualified name
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure Calculator2 is
	First, Second, Result : Integer; -- The two numbers I'll be working with and the result they will produce.
	Operator : Character; -- What math operation will be performed.
	Valid : Boolean; -- Whether or not the user entered a valid statement.

	-- A procedure called Skip_spaces defined within the Calulator2 procedure
	procedure Skip_spaces is
		Next : Character; -- The current character being analyzed in a line of text
		Endline : Boolean; -- Whether or not the current character is the end of the line
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

begin -- Calculator2 begin
	Valid := false; -- Valid is set to false by default, it will be changed to true if user enters a usable operator.
	Put ("What are we going to calculate today? ");
	Get (First);
	Skip_spaces;
	Get (Operator);
	Get (Second);

	-- If user enters a plus sign then addition is performed
	if Operator = '+' then
		Valid := true;
		Result := First + Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;

	-- If user enters a minus sign then subtraction is performed
	elsif Operator = '-' then
		Valid := true;
		Result := First - Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;

	-- If user enters a star or X then multiplication is performed
	elsif Operator = '*' or Operator = 'x' or Operator = 'X' then
		Valid := true;
		Result := First * Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;

	-- If user enters a slash then division is performed
	elsif Operator = '/' then
		Valid := true;
		Result := First / Second;
		Put (First, Width=>0);
		Put (' ');
		Put (Operator);
		Put (' ');
		Put (Second, Width=>0);
		Put (" = ");
		Put (Result, Width=>0);
		New_Line;
	end if;

	-- If user enters something other than the above characters an error is displayed
	if Valid = false then
		Put ("Sorry ");
		Put (Operator);
		Put (" is an invalid operator."); 
		New_Line;
		Put ("Please use +, -, *, or /");
		New_Line;
		Put ("Program shutting down...");
	end if;

end Calculator2;
