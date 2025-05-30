with Ada.Text_Io, linked_string, Ada.Command_line, Ada.Integer_Text_IO;
use  Ada.Text_Io, linked_string, Ada.Command_line, Ada.Integer_Text_IO;

procedure scott_test is
	input_string1	:	string (1 .. 5) := "aaaaa";
	input_string2	:	string (1 .. 4) := "bbbb";
	input2		:	string (1 .. 8);
	test_lstring1	:	lstring;
	test_lstring2	:	lstring;
	lstringlength	:	natural;
	input_file	:	file_type;
	output		:	file_type;
begin

--	test_lstring1 := toLstring(input_string1);
--	put("Your lstring:  "); put(toLstring(input_string1)); new_line;
--	Copy(toLstring(input_string1), test_lstring1);
--	Put("Test_lstring1:  "); put(test_lstring1);		
	Put(ToLstring(input_string1 & input_string2));
--	put("Please enter an lstring:  ");	
--	put("Using input.txt file"); new_line;
--	Open(input_file, in_file, "input.txt");
--	get(input_file, test_lstring2);	

	
--	test_lstring := toLstring(input_string);
--	put("String: "); put(input_string1); new_line;
--	put("Lstring: "); put(toLstring(input_string1)); new_line;
--	input2 := toString(toLstring(input_string));
--	put("Lstring to string: "); put(input2); new_line;
	
--	if toLstring(input_string1) = toLstring(input_string2) then
--		put("Holy moly, these Lstrings are identical!"); new_line;
--	else
--		put("Jiminy cricket, these Lstrings are different!"); new_line;
--	end if; 
--	
--	put_line("Lstring comparisons: ");
--	if toLstring(input_string1) < toLstring(input_string2) then		
--		put(input_string1); put(" < "); put(input_string2); new_line;
--	end if;
	
--	if toLstring(input_string1) > toLstring(input_string2) then		
--		put(input_string1); put(" > "); put(input_string2); new_line;	
--	end if;
--	
--	if toLstring(input_string1) = toLstring(input_string2) then		
--		put(input_string1); put(" = "); put(input_string2); new_line;
--	end if; new_line;
	
--	put_line("String comparisons: ");
--	if input_string1 < input_string2 then		
--		put(input_string1); put(" < "); put(input_string2); new_line;
--	elsif input_string1 > input_string2 then
--		put(input_string1); put(" > "); put(input_string2); new_line;
--	elsif input_string1 = input_string2 then
--		put(input_string1); put(" = "); put(input_string2); new_line;
--	end if; 

--	put("Character'pos('A') = "); put(character'pos('A')); new_line;
--	put("Character'val(65) = "); put(character'val(65)); new_line;
	
--	Create(Output, out_file, "output.txt");
--	Put(Output, toLstring(input_string));
--	Close(Output);

--	Put("Lstring length: "); 
--	lstringlength := Length(toLstring(input_string));
--	put(lstringlength);

end scott_test;
