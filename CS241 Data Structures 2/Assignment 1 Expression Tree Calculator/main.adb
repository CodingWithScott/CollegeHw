-- Scott Felch
-- 12 October 2012
-- CSCI 241
-- Assignment 1. This program will read in a string of integers and operators then perform calculations on them using binary trees. See spec file for more details.

with Ada.Text_Io, Ada.Integer_Text_IO, Ada.Float_Text_IO, gen_tree, gen_tree, tree_expression;
--with Ada.Text_Io, Ada.Integer_Text_IO, gen_tree;
use  Ada.Text_Io, Ada.Integer_Text_IO, Ada.Float_Text_IO, tree_expression;

-- To do: Get Construct_ExpressionTree working
--			 Test every other procedure and function to see if they work, once Construct_expressiontree works

procedure main is

	--*************** Custom Data Types ***************--
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
	
	function Get(input : in string) return varying_string is -- Overloaded Get function to read in a string of any length and store it as a Varying_String
		temp	:	varying_string(1024);		 -- Varying string that can handle up to 1024 characters
	begin
		temp.length := input'length;
		for I in 1 .. temp.length loop
			temp.value(I) := input(I);
		end loop;
		return temp;
	end Get;
	
	function ToString(input : in varying_string) return string is	
	begin							-- Small function to convert from Varying_String to standard string, for procedures/functions expecting strings.
		return input.value(1..input.length);	
	end ToString;
	
	--*************** Custom Exceptions ***************--
	InvalidChars	:	exception;		-- Invalid data used for input, ie something other than numbers or operators
	InvalidDigits	:	exception;		-- Invalid data used for input, ie multiple digit numbers 
	InvalidParans	:	exception;		-- Invalid data used for input, ie non-matching parantheses

	--******************** Variables ******************--
	expression		:	varying_string(20);		-- Expression the program will be working with, should handle maximum of 20 chars since that's what a tree_string can handle.
													-- I ended up not using the tree_string data type, but 20 characters still sounds good.
	root_node		:	expression_node_ptr;	-- This will be the initial node to pass into Construct_ExpressionTree.
	result			:	float := 0.0;			-- Float which will hold the end result of the program.

	-- Validation procedure will raise exceptions if encountering invalid chars, parantheses errors, or multiple-digit numbers. It will also strip out any whitespace from the input string.
	procedure Validate is
		paran_ctr				:	integer := 0;
		left_parans				:	integer := 0;
		right_parans			:	integer := 0;
		prev_char_was_digit		:	boolean := false;
		space_ctr				:	natural := 0;
	begin 
		-- First remove all whitespace by shifting all elements of the string left by one slot. This loop is almost directly copied from one of my CSCI 141 assignments.
		-- Inner loop removes spaces one space at a time, outer loop resets the space_ctr to 0 and keeps doing more passes to ensure that multiple consecutive spaces are eliminated.
		for count1 in 1 .. expression.length loop
			for count in 1 .. expression.length loop
				if expression.value(count) = ' ' then
					expression.value(count .. (expression.length - 1)) := expression.value(count+1 .. expression.length);
					space_ctr := space_ctr + 1; 
				end if;
			end loop;
			expression.length := expression.length - space_ctr;	-- Then after the loop the length is decremented by however many spaces were counted.
			space_ctr := 0;
		end loop;
		expression.length := expression.length - space_ctr;	-- Then after the loop the length is decremented by however many spaces were counted.
		
		for i in 1 .. expression.length loop
			-- Checking for invalid characters
			case expression.value(i) is 					-- If character is a digit or an operator do nothing, just keep scanning
				when '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9' =>
					null;
				when '('|')'|'+'|'-'|'*'|'/'|'^' =>
					null;
				when others =>								-- If something other than the permitted digits and operators is encountered, raise exception.
					raise InvalidChars;
			end case;				

			-- Parantheses counting
			if expression.value(i) = '(' then 
				left_parans := left_parans + 1;
			elsif expression.value(i) = ')' then
				right_parans := right_parans + 1;
			end if;
			
			-- If a right paran ever comes before a left paran then this is an invalid expression.
			if right_parans > left_parans then 	
				raise InvalidParans;
			end if;
			
			-- Checking for multiple consecutive digits
			if (expression.value(i) in '0' .. '9') and prev_char_was_digit then					-- Current char is a digit, prev char was also digit, so raise exception
					raise InvalidDigits;
			elsif (expression.value(i) in '0' .. '9') and prev_char_was_digit = false then	-- Current char is a digit, prev char was not a digit, set digit flag to "on" and move on
					prev_char_was_digit := true;
			elsif (expression.value(i) = '(' or 															-- Current char is an operator, set digit flag to "off" and move on
				expression.value(i) /= ')' or 							
				expression.value(i) /= '+' or
				expression.value(i) /= '-' or
				expression.value(i) /= '*' or
				expression.value(i) /= '/' or
				expression.value(i) /= '^') then
					prev_char_was_digit := false;
			end if;
		end loop;
	
		-- If no parantheses are used, or a non-matching amount of left and right parans, then the expression is invalid.
		if (right_parans = 0) or (right_parans /= left_parans) then		
			raise InvalidParans;
		end if;
		
		put("Expression:         "); put(expression); new_line;
	end Validate;
	
begin -- Begin Calcmain
	Put(ASCII.ESC & "[2J");
	put_line("************************************************************************************************************");
	put_line("***                             NUMBER CRUNCHER 5000: eXXXtreme Edition!!                                ***");
	put_line("************************************************************************************************************"); new_line;

	put_line(" _____________________");
	put_line("|  _________________  |               Alright check it out, this program is going to perform");
	put_line("| |   eXXXtreme!!!  | |               calculations using binary trees. Are you ready?!?");
	put_line("| |_________________| |");
	put_line("|  ___ ___ ___   ___  |               (You're going to have to use single digit numbers and");
	put_line("| | 7 | 8 | 9 | | + | |                fully paranthesized parameters for now, though. I might fix it later.)");
	put_line("| |___|___|___| |___| |");
	put_line("| | 4 | 5 | 6 | | - | |");
	put_line("| |___|___|___| |___| |");
	put_line("| | 1 | 2 | 3 | | x | |");
	put_line("| |___|___|___| |___| |");
	put_line("| | . | 0 | = | | / | |");
	put_line("| |___|___|___| |___| |");
	put_line("|_____________________|");
	
	put_line("Ready...");
	put_line("SET...!!");
	put("ENTER EXPRESSION:   ");
	get_line(expression.value, expression.length);
	Validate;	-- Call the Validate procedure which will raise exceptions for invalid paranthesizing, multiple-digit numbers, invalid characters, and strip all spaces from input
	root_Node := Construct_ExpressionTree(expression.value, 1, expression.length);

	put_line("Pre-order traversal: ");
	Prefix_Notation(root_node); new_line;
	put_line("In-order traversal: ");
	Infix_notation(root_node); new_line;
	put_line("Post-order traversal: ");
	postfix_notation(root_node); new_line;
	
	result := Evaluate_Expression(root_node);
	Put("That evaluates to = "); Ada.Float_Text_IO.put(result, Aft => 3, Exp => 0);

exception
	when Event : InvalidParans =>
		put_line("ERROR: Ah shoot son, you got a problem with the parantheses. Check your number and order of parantheses and try it again!");	
	when Event : InvalidDigits =>
		put_line("ERROR: The program currently doesn't support multiple-digit numbers! My bad. It'll probably work in a future version. Try it again with numbers 0-9, okay?!");
	when Event : InvalidChars =>
		put_line("ERROR: Woah dude, that's number a number OR an operator!! I don't know WHAT that is! Check your input and give it another shot!");
end main;
