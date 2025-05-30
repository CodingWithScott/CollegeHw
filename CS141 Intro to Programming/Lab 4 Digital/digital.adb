-- Scott Felch
-- 25 October 2011
-- CSCI 141
-- Lab 4, Digital Clock Display. This program will accept a user inputted integer and display it graphically like a digital clock.
-- It can handle negative numbers but does not handle scaling.

-- Include and use Text_IO and Integer_Text_IO packages to use these features without a fully qualified name
with Ada.Text_IO, Ada.Integer_Text_IO; 
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure Digital is
	user_number	: integer;		-- The number the user will enter to be converted
	subtype Digit is integer range 0 .. 9;	-- Define a subtype called Digit, which will be used to define the 3x3 patterns
	type zone is (top, middle, bottom);	-- Type to indicate top, middle, or bottom zone of a Digit
	negative : boolean;			-- A flag set to indicate whether the user's number is negative or not, and thus handle output accordingly

	procedure Output (thisDigit : in Digit; thisZone : in Zone) is 
		-- This procedure generates the information which will be passed to Display to be displayed on the screen
		function TopLeft (thisDigit : in Digit ) return character is
		begin	-- Begin TopLeft, it will always return a space. I just like having a function for it.
			return ' ';
		end TopLeft;

		function TopMiddle ( thisDigit : in Digit ) return character is
		begin	-- Begin TopMiddle, which returns different values for different digits
			case thisDigit is
			when 0 | 2 | 3| 5 | 6 | 7 | 8 | 9 => return '_';
			when 1 | 4 => return ' ';
			end case;
		end TopMiddle;

		function TopRight ( thisDigit : in Digit ) return character is
		begin	-- Begin TopRight, always returns a space.
			return ' ';
		end TopRight;

		function MiddleLeft ( thisDigit : in Digit ) return character is
		begin	-- Begin MiddleLeft
			case thisDigit is
			when 0 | 4 | 5 | 6 | 8 | 9 => return '|';
			when 1 | 2 | 3 | 7 => return ' ';
			end case;
		end MiddleLeft;

		function MiddleMiddle ( thisDigit : in Digit ) return character is
		begin	-- Begin MiddleMiddle
			case thisDigit is
			when 2 | 3 | 4 | 5 | 6 | 8 | 9 => return '_';
			when 0 | 1 | 7 => return ' ';
			end case;
		end MiddleMiddle;

		function MiddleRight ( thisDigit : in Digit ) return character is
		begin	-- Begin MiddleRight
			case thisDigit is
			when 0 | 1 | 2 | 3 | 4 | 7 | 8 | 9 => return '|';
			when 5 | 6 => return ' ';
			end case;
		end MiddleRight;

		function BottomLeft ( thisDigit : in Digit ) return character is
		begin	-- Begin BottomLeft
			case thisDigit is
			when 0 | 2 | 6 | 8 => return '|';
			when 1 | 3 | 4 | 5 | 7 | 9 => return ' ';
			end case;
		end BottomLeft;

		function BottomMiddle ( thisDigit : in Digit ) return character is
		begin	-- Begin BottomMiddle
			case thisDigit is
			when 0 | 2 | 3 | 5 | 6 | 8 | 9 => return '_';
			when 1 | 4 | 7 => return ' ';
			end case;
		end BottomMiddle;

		function BottomRight ( thisDigit : in Digit ) return character is
		begin	-- Begin BottomRight
			case thisDigit is
			when 0 | 1 | 3 | 4 | 5 | 6 | 7 | 8 | 9 => return '|';
			when 2 => return ' ';
			end case;
		end BottomRight;
	begin -- Begin Output, which zone I'm currently in determines what row of text to output
		if thisZone = top then
			Put(TopLeft (thisDigit));
			Put(TopMiddle (thisDigit));
			Put(TopRight (thisDigit));
			Put(' ');
		elsif thisZone = middle then
			Put(MiddleLeft (thisDigit));
			Put(MiddleMiddle (thisDigit));
			Put(MiddleRight (thisDigit));
			Put(' ');
		elsif thisZone = bottom then
			Put(BottomLeft (thisDigit));
			Put(BottomMiddle (thisDigit));
			Put(BottomRight (thisDigit));
			Put(' ');
		else -- This should never happen
			Put ("Something broke!"); New_line;
		end if;
	end Output;

	procedure Display ( Number : in natural; Part : in zone ) is -- This is the procedure that displays all the information on the screen
		function DigitCount (Number : in natural) return natural is
			-- This function will use integer division to divide the number away until it's 0, to determine
			-- how many digits the number is.
			number_copy	: integer;	-- Copy of the Number passed in which I can modify and work with
			counter 	: integer := 1; -- Counter to determine how many times a loop has been done, and thus how many digits are present
		begin -- Begin DigitCount
			number_copy := Number;
			while number_copy >= 10 loop
				counter := counter + 1;
				number_copy := number_copy / 10;
			end loop;
			return counter;
		end DigitCount;

		function NthDigit (Number, Position : in natural) return Digit is
		-- This function uses modulus division and integer division to return a specific digit within the Number
		begin -- Begin NthDigit
			return (Number mod 10 ** Position) / 10 ** (Position - 1);	
		end NthDigit;

	begin -- Begin Display
		-- This loop begins outputting the top row of digits left most digit to right, then upon subsequent iterations
		-- (see line 147) the middle and bottom rows. 
		for n in reverse 1 .. DigitCount (Number) loop
			Output( NthDigit(Number, n), Part);
		end loop;
		New_line;
	end Display;

begin -- Begin Digital
	put("This program will display a number in digital clock format, up to 9 digits."); New_line;
	put("Please enter a number you wish to display all fancy-like:  ");
	get (user_number);

	if user_number < 0 then		
	-- If user enters a negative number, I'll make note of it to output a negative sign below, 
	-- then change user's number back to positive.					 
		negative := true;
		user_number := abs (user_number);
	end if;
	-- This loop will call Display, passing it the user's number and zone. It'll iterate 3 times, through Top, Middle, and Bottom.
	for thisZone in zone loop
		if negative = true and thisZone = top then
			put ("   ");
		elsif negative = true and thisZone = middle then
			put ("__ ");
		elsif negative = true and thisZone = bottom then
			put ("   ");
		end if;
		Display (user_number, thisZone);
	end loop;

end Digital;
