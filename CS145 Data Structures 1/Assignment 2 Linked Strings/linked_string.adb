-- Scott Felch
-- 20 February 2012
-- CSCI 145
-- Assignment 2, Linked String Package Body. This package will use linked lists to make a more useful version of Ada's built in string data type.

with Ada.Text_Io, Ada.Integer_Text_IO;
use  Ada.Text_Io, Ada.Integer_Text_IO;

package body linked_string is
	--**********************************************--
	--*************** Varying String ***************--
	--**********************************************--
	-- I'm puttin in this data type to make my Put statements a bit easier later on when outputting Lstrings
	type Varying_String (Maximum : Positive) is record	-- Custom data type to allow for strings of varying length, to get around Ada's stupid string restrictions.
		Length	:	natural;
		Value	:	String (1..Maximum);
	end record;
		
	procedure Put(input : in Varying_string) is		-- Overloaded Put statement for use with Varying_Strings, otherwise some garbage characters are printed.
	begin
		for I in 1 .. input.length loop
			put(input.value(I));
		end loop;
	end Put; 

	function ToString(input : in varying_string) return string is	
	begin							-- Small function to convert from Varying_String to standard string, for procedures/functions expecting strings.
		return input.value(1..input.length);	
	end ToString;
	
	--**********************************************--
	--**************** Linked String ***************--
	--**********************************************--
	function toLstring (input : string) return lstring is
		in_char		:	character;		-- Current character being read in from a string
		head		:	lstring_access;		-- Pointer to the head of the linked list
		curr		:	lstring_access;		-- Pointer to the current node being looked at
		new_node	:	lstring_access;		-- Most recently created node in the lstring
	begin -- Begin toLstring
		head := new lstring'(input(input'first), null);	-- Initialize head of linked list to be the first character of the string passed in
		curr := head;					-- Current is set to Head to begin with, will be incremented along the list as I go
		if input'length > 1 then			-- Make sure the string is longer than 1 character before attempting to enter the below loop
			for count in (input'first) .. input'length loop
				in_char := input(count);			-- Read in a character from the string
				new_node := new lstring'(In_char, null);	-- Create a new node containing that character, and a pointer to null
				curr.next := new_node;				-- "Next" pointer of the current node points to the node just created
				curr := new_node;				-- "Current" is now set to the most recently created node
			end loop;
		end if;
		return head.all;				-- .all indicates to point to the actual object, not just the pointer of the object
	end toLstring;
	
	function toString  (input : lstring) return string is
		lstringlength	:	natural := 1;		-- This will count out the length of the lstring in characters/nodes
		head		:	lstring_access;		-- Pointer to keep track of the first node in the lstring
		scan_ptr	:	lstring_access;		-- Pointer that will be used to scan through the lstring
		temp_string	:	varying_string(99999);	-- Temporary string to hold data before returning, can support up to 99999 characters

	begin -- Begin toString
		head := input.next;				-- Assign a pointer to keep track of the beginning of the list
		scan_ptr := input.next;				-- Scan pointer looks to see if there is another node or if this is the only node in the lstring
		if Scan_ptr.next = null then			-- If the pointer is null then it's a single node in the lstring, just return the data in the first node
			return character'image(head.data);	-- Have to use character'image to turn the character into a string
		else						
			lstringlength := Length(input);		-- Call Length to see how many nodes there are
			temp_string.length := lstringlength;	-- Assign length of the lstring to my varying_string
			for count in 1 .. lstringlength loop	-- Now that I know how many nodes there are I can scan through with a for loop and write each node's contents to the string
				temp_string.value(count) := scan_ptr.data;
				scan_ptr := scan_ptr.next;
			end loop;
		end if; -- End end-of-lstring test
				
		return temp_string.value(1 .. lstringlength);	-- Return a string slice of my varying_string, exactly the length of how many nodes there are
	end toString;
	
	procedure Get (output : out lstring) is
	begin -- Begin Get
		output := toLstring(get_line);		-- Call Get_Line on the string passed in, use the toLstring function to assign the lstring to new_lstring
	end Get;
	
	procedure Get (input : in file_type; output : out lstring) is
	begin -- Begin Get
		Set_Input(input);
		output := toLstring(get_line);
		while not end_of_file loop
			output := output & toLstring(get_line);
		end loop;
	end Get;
	
	procedure Put (input : in lstring) is
		Scan_ptr	:	lstring_access;		-- Pointer that will be used to scan through the lstring
	begin -- Begin Put
		Scan_ptr := Input.next;
		if Scan_ptr = null then				-- If first node pointer is null then it's an empty lstring, just do nothing and exit the procedure
			null;
		else						-- Otherwise continue with the Put procedure
			while Scan_Ptr /= null loop		-- Continue looping through until reaching Null, indicating end of linked list
				Put(Scan_Ptr.data);
				Scan_Ptr := Scan_Ptr.next;
			end loop;
		end if; -- End null Head checker
	end Put;

	procedure Put (output : out file_type; input : in lstring) is
		Scan_ptr	:	lstring_access;		-- Pointer that will be used to scan through the lstring
	begin -- Begin Put
--		Set_Output(output);				-- Procedure will function identical to the previous Put procedure, but this line redirects all output to the designated Output file
		Scan_ptr := Input.next;
		if Scan_ptr = null then				-- If first node pointer is null then it's an empty lstring, just do nothing and exit the procedure
			null;
		else						-- Otherwise continue with the Put procedure
			while Scan_Ptr /= null loop		-- Continue looping through until reaching Null, indicating end of linked list
				Put(output, Scan_Ptr.data);
				Scan_Ptr := Scan_Ptr.next;
			end loop;
		end if; -- End null Head checker
	end Put;
	
	procedure Put_Line (input : in lstring) is
		Scan_ptr	:	lstring_access;		-- Pointer that will be used to scan through the lstring
	begin -- Begin Put_line
		Scan_ptr := Input.next;
		if Scan_ptr = null then				-- If first node pointer is null then it's an empty lstring, just do nothing and exit the procedure
			null;
		else						-- Otherwise continue with the Put procedure
			while Scan_Ptr /= null loop		-- Continue looping through until reaching Null, indicating end of linked list
				Put(Scan_Ptr.data);
				Scan_Ptr := Scan_Ptr.next;
			end loop;
		end if; -- End null Head checker
		new_line;
	end Put_line;
	
	procedure Put_Line (output : out file_type; input  : in lstring) is
		Scan_ptr	:	lstring_access;		-- Pointer that will be used to scan through the lstring
	begin -- Begin Put_line
--		Set_Output(output);				-- Procedure will function identical to the previous Put procedure, but this line redirects all output to the designated Output file
		Scan_ptr := Input.next;
		if Scan_ptr = null then				-- If first node pointer is null then it's an empty lstring, just do nothing and exit the procedure
			null;
		else						-- Otherwise continue with the Put procedure
			while Scan_Ptr /= null loop		-- Continue looping through until reaching Null, indicating end of linked list
				Put(Output, Scan_Ptr.data);
				Scan_Ptr := Scan_Ptr.next;
			end loop;
		end if; -- End null Head checker
		new_line;
	end Put_line;

	
	function "&" (left  : lstring; right : lstring) return lstring is
		length1		:	natural := Length(left);	-- Length of left lstring
		length2		:	natural := Length(right);	-- Length of right lstring
		string1		:	string (1 .. length1);		-- String to hold left lstring
		string2		:	string (1 .. length2);		-- String to hold right lstring
		output		:	lstring;			-- Lstring to be outputted eventually
	begin -- Begin "&"
		string1 := toString(left);
		string2 := toString(right);
		output := ToLstring(string1 & string2);
		return output;
	end "&";
	
	procedure Copy (input : in lstring; output: out lstring) is
	begin -- Begin 
		-- When I started writing this procedure it was pointed out to me that I have been making every single procedure and function exponentially more difficult than it actually
		-- needs to be, and I don't have to reinvent the wheel for everything. So this is just one line, instead of the 60 lines it was going to be. All of my functions I write after this
		-- will also be stupidly short, since I don't want to write any more 60+ line functions.
		output := input;
	end Copy;
	
	function Slice (input : lstring; left  : integer; right : integer) return lstring is
		lstringlength	:	natural := Length(input);	-- Length of input lstring
		output		:	lstring;			-- Lstring to be outputted
		temp_string	:	string (1 .. lstringlength);	-- String to hold data temporarily
	begin -- Begin Slice
		temp_string := toString(input);
		output := toLstring(temp_string(left .. right));
		return output;
	end Slice;
	
	function "=" (left  : lstring; right : lstring) return boolean is
		length1		:	natural;	-- Length (in chars) of left lstring
		length2		:	natural;	-- Length (in chars) of right lstring
		scan_ptr1	:	lstring_access;	-- Pointer to scan through the left lstring, one char at a time
		scan_ptr2	:	lstring_access;	-- Pointer to scan through the right lstring, one char at a time
		curr_char1	:	character;	-- Current character being looked at in left string
		curr_char2	:	character;	-- Current character being looked at in right string
	begin -- Begin "="
		length1 := Length(left);
		length2 := Length(right);

		if length1 /= length2 then		-- If the two lstrings are not the same length then I can return false, they are not equal, without testing any further.
			return false;
		end if;
		
		if left.data /= right.data then		-- If data contained in the first element is not equal, return false, before going on to bother working with pointers at all.
			return false;
		end if;
		
		scan_ptr1 := left.next;			-- Initialize my two pointers that will read through the lstrings
		scan_ptr2 := right.next;
		
		for count in 1 .. length1 loop		-- Loop through each lstring one node at a time, comparing data in each node for equivalency
			curr_char1 := scan_ptr1.data;
			curr_char2 := scan_ptr2.data;
			if character'pos(curr_char1) >= 65 and character'pos(curr_char1) <= 90 then 	-- If curr_char1 is upper case... 
				curr_char1 := character'val(character'pos(curr_char1) + 32);		-- then I'll convert to lowercase, for dictionary comparison purposes.
			end if;
			if character'pos(curr_char2) >= 65 and character'pos(curr_char2) <= 90 then 	-- Same for curr_char2.
				curr_char2 := character'val(character'pos(curr_char2) + 32);
			end if;
			
			if curr_char1 /= curr_char2 then						-- If the characters are different, return false, otherwise continue looping
				return false;
			end if;
			scan_ptr1 := scan_ptr1.next;
			scan_ptr2 := scan_ptr2.next;
		end loop;

		return true;				-- If the function makes it all the way to here without returning false then the lstrings are identical
	end "=";
	
	function "<" (left  : lstring; right : lstring) return boolean is
		length1		:	natural;	-- Length (in chars) of left lstring
		length2		:	natural;	-- Length (in chars) of right lstring
		count_length	:	natural;	-- Will be set to whichever length is shorter
		scan_ptr1	:	lstring_access;	-- Pointer to scan through the left lstring, one char at a time
		scan_ptr2	:	lstring_access;	-- Pointer to scan through the right lstring, one char at a time
		curr_char1	:	character;	-- Current character being looked at in left string
		curr_char2	:	character;	-- Current character being looked at in right string
	begin -- Begin "<"
		length1 := Length(left);
		length2 := Length(right);
		if length1 < length2 then		-- Whichever length is shorter is how long my counter will go in the comparison loop below
			count_length := length1;
		elsif length1 >= length2 then		-- If length2 is shorter or they're equal, then length2 will be the count_length
			count_length := length2;
		end if;
		
		curr_char1 := left.data;
		curr_char2 := right.data;
		if character'pos(curr_char1) >= 65 and character'pos(curr_char1) <= 90 then 	-- If curr_char1 is upper case... 
			curr_char1 := character'val(character'pos(curr_char1) + 32);		-- then I'll convert to lowercase, for dictionary comparison purposes.
		end if;
		if character'pos(curr_char2) >= 65 and character'pos(curr_char2) <= 90 then 	-- Same for curr_char2.
			curr_char2 := character'val(character'pos(curr_char2) + 32);
		end if;
		if character'pos(curr_char1) > character'pos(curr_char2) then		-- If curr_char1 is greater than curr_char2, return false. 
			return false;
		elsif character'pos(curr_char1) < character'pos(curr_char2) then	-- If curr_char1 is less than curr_char2, return true. Otherwise if characters are identical, continue to loop through.
			return true;
		end if;
		
		scan_ptr1 := left.next;
		scan_ptr2 := right.next;
		for count in 1 .. count_length loop		-- Loop through each lstring one node at a time, comparing data in each node for equivalency
			curr_char1 := scan_ptr1.data;
			curr_char2 := scan_ptr2.data;
			if character'pos(curr_char1) >= 65 and character'pos(curr_char1) <= 90 then 	
				curr_char1 := character'val(character'pos(curr_char1) + 32);		
			end if;
			if character'pos(curr_char2) >= 65 and character'pos(curr_char2) <= 90 then 	
				curr_char2 := character'val(character'pos(curr_char2) + 32);
			end if;
			if character'pos(curr_char1) > character'pos(curr_char2) then		-- If curr_char1 is greater than curr_char2, return false. Otherwise, continue to loop below to read rest of lstrings.
				return false;
			elsif character'pos(curr_char1) < character'pos(curr_char2) then	-- If curr_char1 is less than curr_char2, return true. Otherwise if characters are identical, continue to loop through.
				return true;
			end if;
			scan_ptr1 := scan_ptr1.next;
			scan_ptr2 := scan_ptr2.next;
		end loop;
		-- If the loop finishes without returning true or false, then every character up to this point has been identical. If left is shorter, the statement is true. If it's longer or equal to right, statement is false.
		if length1 < length2 then		
			return true;
		end if;			
		return false;
	end "<";

	function ">" (left  : lstring; right : lstring) return boolean is
		length1		:	natural;	-- Length (in chars) of left lstring
		length2		:	natural;	-- Length (in chars) of right lstring
		count_length	:	natural;	-- Will be set to whichever length is shorter
		scan_ptr1	:	lstring_access;	-- Pointer to scan through the left lstring, one char at a time
		scan_ptr2	:	lstring_access;	-- Pointer to scan through the right lstring, one char at a time
		curr_char1	:	character;	-- Current character being looked at in left string
		curr_char2	:	character;	-- Current character being looked at in right string
	begin -- Begin ">"
		length1 := Length(left);
		length2 := Length(right);
		if length1 < length2 then		-- Whichever length is shorter is how long my counter will go in the comparison loop below
			count_length := length1;
		elsif length1 >= length2 then		-- If length2 is shorter or they're equal, then length2 will be the count_length
			count_length := length2;
		end if;
		
		curr_char1 := left.data;
		curr_char2 := right.data;
		if character'pos(curr_char1) >= 65 and character'pos(curr_char1) <= 90 then 	-- If curr_char1 is upper case... 
			curr_char1 := character'val(character'pos(curr_char1) + 32);		-- then I'll convert to lowercase, for dictionary comparison purposes.
		end if;
		if character'pos(curr_char2) >= 65 and character'pos(curr_char2) <= 90 then 	-- Same for curr_char2.
			curr_char2 := character'val(character'pos(curr_char2) + 32);
		end if;
		if character'pos(curr_char1) < character'pos(curr_char2) then		-- If curr_char1 is less than curr_char2, return false. 
			return false;
		elsif character'pos(curr_char1) > character'pos(curr_char2) then	-- If curr_char1 is greater than curr_char2, return true. Otherwise they must be equal and I need to continue testing rest of lstrings.
			return true;
		end if;
		
		scan_ptr1 := left.next;
		scan_ptr2 := right.next;
		for count in 1 .. count_length loop		-- Loop through each lstring one node at a time, comparing data in each node for equivalency
			curr_char1 := scan_ptr1.data;
			curr_char2 := scan_ptr2.data;
			if character'pos(curr_char1) >= 65 and character'pos(curr_char1) <= 90 then 	
				curr_char1 := character'val(character'pos(curr_char1) + 32);		
			end if;
			if character'pos(curr_char2) >= 65 and character'pos(curr_char2) <= 90 then 	
				curr_char2 := character'val(character'pos(curr_char2) + 32);
			end if;
			if character'pos(curr_char1) < character'pos(curr_char2) then		-- If curr_char1 is less than curr_char2, return false.  
				return false;
			elsif character'pos(curr_char1) > character'pos(curr_char2) then	-- If curr_char1 is greater than curr_char2, return true. Otherwise they're equal, continue to next character.
				return true;
			end if;
			scan_ptr1 := scan_ptr1.next;
			scan_ptr2 := scan_ptr2.next;
		end loop;
		-- If the loop finishes without returning true or false, then every character up to this point has been identical. If left is longer, the statement is true. If it's shorter or equal to right, statement is false.
		if length1 > length2 then		
			return true;
		end if;	
		return false;	
	end ">";
	
	function Length (input : lstring) return natural is
		temp		:	natural := 1;		-- This will count out the length of the lstring in characters/nodes
		scan_ptr	:	lstring_access;		-- Pointer that will be used to scan through the lstring
	begin -- Begin Length
		scan_ptr := input.next;
		while scan_ptr.next /= null loop		-- Scan through the linked list, increment length each node, quit when reaching the final node
			temp := temp + 1;
			scan_ptr := scan_ptr.next;
		end loop;
		return temp;					-- Return the number of nodes counted
	end Length;
end linked_string;
