-- Scott Felch
-- 4 November 2011
-- CSCI 141, Dr David Bover
-- Assignment 2, Roman Numberal Calculator
-- Roman_IO Body. Will handle Get and Put functions for numbers in Roman numeral format, and do error checking to ensure
-- all numbers are in an acceptable format, following principles of Roman numerals. 

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Exceptions;

package body Roman_IO is
	Next : 			character;		-- The current character being analyzed
	Endline	:		boolean; 		-- Whether or not Next is the end of the line
	
	-- Validate whether or not a valid Roman numeral has been entered
	function ValidRoman (Char : in Character) return boolean is
	begin -- Begin ValidRoman
		case Char is 
			when 'I'|'i'|'V'|'v'|'X'|'x'|'L'|'l'|'C'|'c'|'D'|'d'|'M'|'m'=> 	return true;
			when others => 							return false;
		end case;
	end ValidRoman;
	
	-- RomanToDecimal converts the various Roman integers into standard decimal integers
	function RomanToDecimal (RomanInteger : in character) return integer is
	begin -- Begin RomanToDecimal
		case RomanInteger is
			when 'I' | 'i' => return 1; 
			when 'V' | 'v' => return 5;
			when 'X' | 'x' => return 10; 
			when 'L' | 'l' => return 50; 
			when 'C' | 'c' => return 100; 
			when 'D' | 'd' => return 500; 
			when 'M' | 'm' => return 1000; 
			when others =>	-- This will never happen
				raise Roman_Numeral_Error with ("Uh oh, not a valid character!");
		end case;
	end RomanToDecimal;
	
	-- If the Get function detects an operator it knows the end of a Roman numeral has been hit, and will exit the loop
	function OperatorDetected return boolean is
     	begin -- Begin OperatorDetected
	     	Look_ahead(Next, EndLine);
	    	if EndLine = true then
			return true; 
		end if;
		case Next is
			when 'I'|'i'|'V'|'v'|'X'|'x'|'L'|'l'|'C'|'c'|'D'|'d'|'M'|'m' => return false;
			when others => return true; 
		end case; 
	end OperatorDetected; 
	 
	-- Overloaded Get function, reads in characters and outputs a Roman_Numeral
	procedure Get (Value : out Roman_Numeral) is 
	-- Procedure for Getting in a Roman numeral, logic shamelessly stolen from Clark Rinker's in-class demonstration
		CurrentChar	: character;		-- Current character being analyzed
		CurrVal		: integer := 0;		-- Numerical value of current character
		NextChar	: character;		-- Next character to be analyzed
		NextVal		: integer := 0;		-- Numerical value of next character to be analyzed
		PrevVal1	: integer := 0;		-- Numerical value of previous character
		PrevVal2	: integer := 0;		-- Numerical value of prev-previous character
		PrevVal3	: integer := 0;		-- Numerical value of prev-prev-previous character
		Total		: integer := 0;		-- The total value all the individual Roman digits put together
		ValidRomanNum	: boolean;		-- Flag indicating if Roman numeral entered is valid
		
	begin --begin Get
		-- Check for valid Roman numeral before continuing into the following loop
		Look_ahead(NextChar, Endline);
		if ValidRoman(NextChar) = false then
			raise Roman_Numeral_Error with ("Uh oh, not a valid character!");
		else	-- Roman Numeral is valid, enter the next loop		
			while not OperatorDetected loop
				Get(CurrentChar);
				ValidRomanNum := ValidRoman(CurrentChar);	-- Call ValidRoman to verify current character is an acceptable character. 
				CurrVal := RomanToDecimal(CurrentChar);
				-- Check for series of 4 repeated characters (Rule 2 in the assignment documentation)
				if CurrVal = PrevVal1 and PrevVal1 = PrevVal2 and PrevVal2 = PrevVal3 then
					raise Roman_Numeral_Error with ("Dang it, you can't have a sequence of more than 3 repeated digits! Bummer...");
				-- Check for subtracting powers of 10 (Rule 5)
				elsif PrevVal1 < CurrVal and PrevVal1 = 5 then
					raise Roman_Numeral_Error with ("Aw shoot, your subtraction digit has to be a power of 10! Sorry bro.");
				elsif PrevVal1 < CurrVal and PrevVal1 = 50 then
					raise Roman_Numeral_Error with ("Dude, the subtraction digit here isn't a power of 10! Ugh.");
				elsif PrevVal1 < CurrVal and PrevVal1 = 500 then
					raise Roman_Numeral_Error with ("Oops... it broke. Your subtraction digit has to be a power of 10 or it no worky.");
				-- Check for subtracting a number that is more than 10 times greater
				elsif PrevVal1 * 10 < CurrVal and PrevVal1 /= 0 then
					raise Roman_Numeral_Error with ("Uh oh, your subtraction digit is too small!");
				-- Don't subtract a number from a sequence of repeated digits of greater value
				elsif PrevVal1 = CurrVal and PrevVal1 > PrevVal3 and PrevVal2 /= CurrVal and PrevVal2 /= 0 and PrevVal3 /= 0 then
					raise Roman_Numeral_Error with ("Hold on, that's an invalid sequence of digits!");
				   
				elsif CurrVal > PrevVal1 and PrevVal1 /= 0 then
					Look_ahead(NextChar, Endline);
					NextVal := RomanToDecimal(NextChar);
					if NextVal = CurrVal then
						raise Roman_Numeral_Error with ("You can't subtract from a series of multiple digits of higher value, man!");
					else 
						Total := Total + CurrVal - 2 * PrevVal1;
					end if; -- End subtraction from multiple repeating greater digits check
				else Total := Total + CurrVal;
				end if; -- End every other error check
				-- Shift all the digits left
				PrevVal3 := PrevVal2;
				PrevVal2 := PrevVal1;
				PrevVal1 := CurrVal;
			end loop; -- End OperatorDetected loop

			if Total = 0 then
				raise Roman_Numeral_Error with "Bro, your roman numeral is empty!";
			else 
				Value := Total;
			end if;
			if Value < 1 or Value > 3999 then
				raise Roman_Numeral_Error with "This falls outside the realm of Roman numerals, brotato chip.";
			end if;
		end if; -- End ValidRoman check
	end Get; -- End Get
	
	-- Overloaded Put statement converts a Roman_Numeral data type to a standard decimal integer and prints to screen
	procedure Put (Value : in Roman_Numeral) is
		Total		: integer;	-- The mutable version of Value which I can work with
	begin -- Begin Put
		Total := Value;		-- Assign the inputted value to Total so I can work with it
		-- Process outputting 1000s place
		while Total / 1000 > 0 loop
			Total := Total - 1000;
			Put ('M');
		end loop;
		-- Process outputting 500s place	
		while Total / 500 > 0 loop
			if Total >= 900 then
				Put ("CM");
				Total := Total - 900;
			elsif 900 > Total and Total >= 500 then
				Put ('D');
				Total := Total - 500;
			end if;
		end loop;
		-- Process outputting 100s place	
		while Total / 100 > 0 loop
			if Total >= 400 then
				Put ("CD");
				Total := Total - 400;
			elsif 400 > Total and Total >= 100 then
				Put ('C');
				Total := Total - 100;
			end if;
		end loop;
		-- Process outputting 50s place	
		while Total / 50 > 0 loop
			if Total >= 90 then
				Put ("XC");
				Total := Total - 90;
			elsif 90 > Total and Total >= 50 then
				Put ('L');
				Total := Total - 50;
			end if;
		end loop;
		-- Process outputting 10s place	
		while Total / 10 > 0 loop
			if Total >= 40 then
				Put ("XL");
				Total := Total - 40;
			elsif 40 > Total and Total >= 10 then
				Put ('X');
				Total := Total - 10;
			end if;
		end loop;
		-- Process outputting 5s place	
		while Total / 5 > 0 loop
			if Total = 9 then
				put ("IX");
				Total := Total - 9;
			else
				put ('V');
				Total := Total - 5;
			end if;
		end loop;
		-- Process outputting 1s place	
		while Total > 0 loop
			if Total = 4 then
				put ("IV");
				Total := Total - 4;
			else
				Put ('I');
				Total := Total - 1;
			end if;
		end loop;
	end Put;
end Roman_IO; -- End Roman_IO body
