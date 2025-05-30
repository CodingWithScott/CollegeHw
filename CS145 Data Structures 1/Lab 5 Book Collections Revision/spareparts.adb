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
