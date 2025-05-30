-- Scott Felch
-- 21 February 2012
-- CSCI 145
-- Assignment 2, Linked String Specification. This package will use linked lists to make a more useful version of Ada's built in string data type.

with Ada.Text_Io, Ada.Integer_Text_IO;
use  Ada.Text_Io, Ada.Integer_Text_IO;

package linked_string is
	-- This specification file is a table of contents for the functionality of the Lstring data type
	lstring_length	: constant := 1;			-- Maximum length of lstring, I'm using 1 because it sounds 100x easier to me
	
	type lstring is limited private;
	type lstring_access is limited private;			-- Definition of lstring is to be defined below
	
	function toLstring (input : string)  return lstring;	-- Pass in a regular string, convert to an Lstring and return Lstring
	function toString  (input : lstring) return string;	-- Pass in a linked string, convert to a standard string and return standard string

	procedure Get (output : out lstring);			-- Read an lstring as the entire line from standard input (without the end of line character).
	procedure Get (input : in file_type; 			-- Given a parameter of type Ada.Text_IO.File_type, read an lstring as an entire line from the
		      output : out lstring);			-- file represented by that File_type parameter (without the end of line character).
		      
	procedure Put (input  : in lstring); 			-- Output an lstring to standard output.
	procedure Put (output : out file_type;			-- Output an lstring to a text file
		      input   : in lstring);			
		      
	procedure Put_Line (input  : in lstring);		-- Output an lstring to standard output, followed by a new line.
	procedure Put_Line (output : out file_type;		-- Output an lstring to a text file, followed by a new line.
			    input  : in lstring);		

	function "&" (left    : lstring;			-- A binary operator to concantenate two lstring values, producing a third lstring value.
		      right   : lstring) return lstring;	
	procedure copy (input : in lstring;			-- This replaces the := operator for the limited private type. Given a source lstring, copies that lstring to a target lstring.
			output: out lstring);

	function slice (input : lstring;			-- Given an lstring and start and finish positions in that lstring, return an lstring which is a slice of the original lstring.
			left  : integer;			-- For example, if lstr is an lstring variable, Slice(lstr, 5, 12) is an lstring containing the 5th through 12th characters of lstr.
			right : integer) return lstring;
			
	function "=" (left  : lstring; 				-- A binary operator to compare two lstring values for equality.
		      right : lstring) return boolean;		
	function "<" (left  : lstring;				-- A binary operator to compare two lstring values and return true if the first lstring would come before the second lstring value, 
		      right : lstring) return boolean;		-- in dictionary order, and return false otherwise.
	function ">" (left  : lstring;				-- A binary operator to compare two lstring values and return true if the first lstring would come after the second lstring value, 
		      right : lstring) return boolean;		-- in dictionary order, and return false otherwise.		
	function Length (input : lstring) return natural;	-- Return the length (number of characters) in an lstring.
	
private
	type lstring_access is access lstring;			-- Declaring a type of pointer that corresponds with lstring_records
	
	type lstring is record
		data	:	character;
		next	:	lstring_access := null;
	end record;
end linked_string;
