-- Scott Felch
-- 29 October 2012
-- CSCI 241
-- Assignment 2. This program will accept insertion, deletion, and print requests of an AVL tree of positive integers from standard console input. I don't think it would be any harder to make it handle 
-- numbers <= 0 but that's what the assignment spec asks for so that's how it is.

with Ada.Text_Io, Ada.Integer_Text_IO, Ada.Float_Text_IO, search_avl;
use  Ada.Text_Io, Ada.Integer_Text_IO, Ada.Float_Text_IO;

-- TO DO: 
-- 1. Learn how AVL trees work.
-- 2. Learn insertion, deletion, rotation, and searching algorithms.
-- 3. Build packages and implement algorithms in them.
-- 4. ???
-- 5. A+, great job!!

-- Search_AVL to do:
-- Figure out how to handle deleting root node

procedure avlmain is

	----------------- Necessary procedures for instantiating the Search_AVL package ---------------------
    procedure Put_Int( X: Integer ) is
    begin
    	Put(x, width => 2);
	end Put_Int;
	
	----------------- Instantiate the Search_AVL package -----------------------------
	package Binary_AVL_Tree is new search_avl(integer, "<", Put_Int);
	use Binary_AVL_Tree;

					--#################################################--
					--############### Custom Data Types ###############--
					--#################################################--
	------------------- Varying String ------------------
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
	
					--#################################################--
					--############### Custom Exceptions ###############--
					--#################################################--
	AllDone				:	exception;		-- Program is done running, raise an exception and exit in style.
	InvalidAction		:	exception;		-- Invalid data input for the action, ie wrong letter or too many letters
	InvalidNumber		:	exception;		-- Invalid data input for the number, ie 0 or negative numbers.
	InsufficientInput	:	exception;		-- User specified Insert or Delete as an action, but didn't enter a value to Insert/Delete
	StringOverflow		:	exception;		-- String is bigger than 10 characters, way too big a number to put in the tree!
	
	
					--#################################################--
					--################# I/O Variables #################--
					--#################################################--
	initial		:		varying_string(1024);			-- Initial readin of input from user, will raise an exception if they enter a string more than 10 chars. That's just WAY too big of a number.
	command 	:		varying_string(10);				-- Input from user, will get the whole line and then extract the action and number from it. 10 characters will be enough to allow for huge numbers and lots of spaces.
	action	 	: 		character := '#';				-- Command for input from user, should be a letter I (insert), D (delete), P (print), or E (exit). Will initialize as a # sign, for error checking purposes.
	number		:		integer := 0;					-- If user selects I or D then user will also be prompted for number to be inserted or deleted from tree, which will be stored in this variable. 
	
	-- ######################################################################
	-- ######################## MAIN DEAL RIGHT HERE!! ######################
	-- ######################################################################
	The_Tree	:		Search_Tree;				-- The Big Ol' Tree I'll be working with in the program
	
	
	-- This procedure will validate that the input data is valid and then assign values to Action and Number.
	procedure Validate is
			space_ctr	:	natural := 0;					-- Space counter to be used in the whitespace removal loop.

		function ToUpper (input : character) return character is
		begin
		-- If character is a lower case letter, subtract 32 from its ASCII value to make it upper case...
		if character'pos(input) in 97 .. 122 then
			return character'val(character'pos(input) - 32);
		-- ...otherwise just return the character untouched.
		else
			return input;
		end if;
		end ToUpper;

	begin -- Begin Validate
		if initial.length > 10 then							-- If the user entered a string longer than 10 chars throw an exception and quit. 
			raise StringOverflow;
		else												-- Otherwise pass the data from initial holding variable to permanent variable.
			command.length := initial.length;
			for count in 1 .. initial.length loop
				command.value(count) := initial.value(count);
			end loop;
		end if;
	
		-- First remove all whitespace by shifting all elements of the string left by one slot. This loop is almost directly copied from one of my CSCI 141 assignments.
		-- Inner loop removes spaces one space at a time, outer loop resets the space_ctr to 0 and keeps doing more passes to ensure that multiple consecutive spaces are eliminated.
		for CountOuter in 1 .. command.length loop
			for count in 1 .. command.length loop
				if command.value(count) = ' ' then
					command.value(count .. (command.length - 1)) := command.value(count+1 .. command.length);
					space_ctr := space_ctr + 1; 
				end if;
			end loop;
			command.length := command.length - space_ctr;	-- Then after the loop the length is decremented by however many spaces were counted.
			space_ctr := 0;
		end loop;
		command.length := command.length - space_ctr;		-- Then after the loop the length is decremented by however many spaces were counted.

		command.value(1) := ToUpper(command.value(1));		-- Convert command to an upper case letter since I think it makes all the subsequent If statements look more neat
	
		-- The user's input string should now consist of only a letter, and optionally a number (P and E will be just a letter, I and D will be accompanied by a number). Ie, 'P' or 'i20'.
		if command.value(1) = 'I' or command.value(1) = 'D' or 	command.value(1) = 'P' or command.value(1) = 'E' then	
			action := command.value(1);						-- If user enters a valid action, store the first char of Command in Action
		else
			raise InvalidAction;							-- If a number or an unacceptable character has been entered as the first character then raise an exception.
		end if;
		
		-- If user uses the Insert or Delete command but doesn't specify a value to add/delete then raise an exception. 
		if (action = 'I' or action = 'D') and command.length = 1 then
			raise InsufficientInput;
		end if;
	
		if command.length > 1 then
			-- Next I'm going to scan through and make sure that the only remaining characters are a positive number. If anything other than digits is encountered then I'll throw an exception.
			for count in 2 .. command.length loop
				if command.value(count) not in '0' .. '9' and command.value(count) /= '-' then
					raise InvalidNumber;
				end if;
			end loop;
			-- If I've got past the above for loop then the only remaining char(s) in this string is the valid number I'm going to store and put in a node, so I'll convert from string to integer and store the value.
			number := Integer'Value(command.value(2 .. command.length));
		end if;
	end Validate;
	
begin -- Begin AVLMain
	put_line("Alright check it B, get this.... this program is going to build an AVL tree, insert nodes, delete nodes, search for nodes, WHATEVER. It's gonna be MAD TIGHT, yo!");
	put_line("Possible input:   (i=insert, d=delete, p=print, e=exit)");
	put("Tell me what to do:   "); 
	get_line(initial.value, initial.length);
	Validate;
	
	Make_Empty(The_Tree);		-- Hand in an empty Search_Tree called The_Tree, and Make_Empty will 
	
	while action /= 'E' loop
		if action = 'I' then
			put("Inserting "); put(number, 1); put(" into the tree now"); new_line;
			Insert(number, The_Tree);
		elsif action = 'D' then
			put("Deleting "); put(number, 1); put(" from the tree now"); new_line;
			Delete(number, The_Tree);
		elsif action = 'P' then
			print_tree(The_Tree);
		end if;
		
		put("Tell me what to do:   "); 
		get_line(initial.value, initial.length);
		
		Validate;
	end loop;
	
--	new_line; put_line("It's been real, it's been fun, it's been real fun. Peace out brotato chip!!");	
	raise AllDone;
	
exception
	when Event : AllDone =>
		new_line; put_line("It's been real, it's been fun, it's been real fun. Peace out brotato chip!!");	
	when Event : InvalidAction =>
		new_line; put_line("ERROR: Woah dude, there's something wrong with your command you're asking me to do! Enter I, D, P or E.");
	when Event : InsufficientInput =>
		new_line; put_line("ERROR: Bro if you're going to tell me to insert or delete a node that's fine, but you have to tell me what value to insert or delete. Please try again.");
	when Event : InvalidNumber =>
		new_line; put_line("ERROR: What are you trying to do?! That's definitely not a valid number. Enter a whole number and try again.");	
	when Event : StringOverflow =>
		put_line("ERROR: Your input was way too big! No can do buckaroo. 10 characters maximum.");
	when Event : Binary_AVL_Tree.Item_Not_Found =>
		put_line("ERROR: I want to delete that node but it doesn't exist.");
end avlmain; 
