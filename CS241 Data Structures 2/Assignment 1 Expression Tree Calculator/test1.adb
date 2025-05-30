-- Scott Felch
-- 12 October 2012
-- CSCI 241
-- Testing Trim() function

with Ada.Text_Io, Ada.Integer_Text_IO;
use  Ada.Text_Io, Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure test1 is
	test_string : string (1..20) := "   34567890123457   ";
	
--	function Trim(Input : string) return string is
--	begin
--		if Input(1) = ' ' then
--			return Trim(Input(2 .. (Input'Length)));
--		elsif Input(Input'Length) = ' ' then
--			return Trim(Input(1 .. (Input'Length-1)));
--		else
--			return Input;
--		end if;
--	end Trim;

--	function Trim_Leading_Spaces(Input : string) return string is
--	begin
--		if Input(1) = ' ' then
--			return Input(2 .. Input'Length);
--		else
--			return Input;
--		end if;
--	end Trim_Leading_Spaces;
	
	
begin
	Put("Original:  "); put(test_string); new_line;
   Put("Left  '" & Trim (test_string, Left) & "'"); new_line;
   Put("Right '" & Trim (test_string, Right) & "'"); new_line;
   Put("Both  '" & Trim (test_string, Both) & "'"); new_line;
   
end test1;
