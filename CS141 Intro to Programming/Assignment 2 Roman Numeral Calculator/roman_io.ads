-- Roman_IO.ads
--
-- specification for roman numeral IO
--
-- David Bover, WWU Computer Science, November, 2011


package Roman_IO is

	-- 3999 (MMMCMXCIX) is the largest number that can be expressed 
	-- with the 7-character roman numeral system
	-- there is no zero or negative numbers in roman numerals	
	subtype Roman_Numeral is integer range 1 .. 3999;

	-- exception raised by procedure Get when unable to interpret a sequence of
	-- characters as a valid number in roman numerals
	Roman_Numeral_Error: exception;
	
	-- get the decimal value of roman numeral input	
	procedure Get (Value : out Roman_Numeral);

	-- display a decimal number in roman numerals	
	procedure Put (Value : in Roman_Numeral);

end Roman_IO;
