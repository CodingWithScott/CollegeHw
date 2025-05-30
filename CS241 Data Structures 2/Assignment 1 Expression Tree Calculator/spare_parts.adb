-- Scott Felch
-- 12 October 2012
-- CSCI 241
-- Spare parts file

with Ada.Text_Io, Ada.Integer_Text_IO, gen_tree, tree_expression;
use  Ada.Text_Io, Ada.Integer_Text_IO;

-- To do: figure out how to create a node


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
	
	
	
	function Construct_ExpressionTree (Expression_String : String; First, Last : Natural) return Expression_Node_Ptr is
		paran_ctr		:		natural := 0;
		tempnode		:		Expression_Node_Ptr;
		tempstring		:		string(1 .. 1) := " ";
	begin
		-- Ada.Text_io.Put_Line("Pretend the tree was constructed");
		for count in First .. Last loop
			case Expression_String(count) is
				when '1' .. '9' => 	-- Base case: current char is a number. Return a leaf node with only the number as data and L and R pointers are null
					tempstring := expression_string(count..count);
					return Binary_Expression_Tree.Create_Node(tempstring, null, null);
				when '(' =>	paran_ctr := paran_ctr + 1;		-- ( will increment the paran counter
				when ')' =>	paran_ctr := paran_ctr - 1;		-- ) will decrement the paran counter
				when others =>				-- If character is not a digit or a paran then I know it's an operator
					if paran_ctr = 1 then
						-- If paran counter is at 1 then I know I've hit a dominant operator and make a new parent node. Left child is everything left of operator, right child is everything right of operator.
						return Binary_Expression_Tree.Create_Node(expression_string, Construct_ExpressionTree(expression_string, First+1, count-1), Construct_ExpressionTree(expression_string, Count+1, Last-1));
					end if;
			end case;
		end loop;
--		return null;
	end Construct_ExpressionTree;
	
	
	mutable			:		string(1 .. 20);	-- Global string variable will be used in Construct_ExpressionTree
	procedure AssignMutable(original_string : string) is
	begin
		-- This procedure just takes the original expression string, which will be passed in from Main, and assign it to Mutable, which is a global variable in this package
		mutable := original_string;
	end AssignMutable;
	
	
	-- Chris Koos gave me the idea for how this function works so mine will probably be pretty similar to his.
function Construct_ExpressionTree (Expression_String : String; First, Last : Natural) return Expression_Node_Ptr is
	new_node			:		expression_node_ptr;			-- This node will be constructed each time the function is called
	new_record		:		guts;								-- A record containing default dummy values for number and operator
	tempstring		:		string(1 .. 1) := " ";
	LeftPut			:		boolean := false;							-- Has left operand been processed already?
	RightPut			:		boolean := false;							-- Has right operand been processed already?
	OperPut			:		boolean := false;							-- Has operater been processed already?
begin
	-- Ada.Text_io.Put_Line("Pretend the tree was constructed");
	
	for count in 1 .. mutable'last loop
		case mutable(count) is
			when mutable(count) = '#' =>		-- # sign indicates a character has already been processed, will just continue to next character
				null;
			when = '(' =>
				mutable(count) := '#';
				Set_Left_Child(new_node, Construct_ExpressionTree(mutable, count, last));
			when in '1' .. '9' =>
				tempstring := mutable(count .. count);				-- Assign current char to be a 1-char string called tempstring, will be used to convert from string to integer and store in record
				new_record.number := Integer'value(tempstring); -- New_record.number is now an integer value instead of a string
				if LeftPut = false and RightPut = false then
					Set_Data(new_node, new_record);					-- Put the digit (stored in new_record) into the new_node
					LeftPut := true;
				elsif LeftPut = true and RightPut = false then	-- Put the digit (stored in new_record) into the new_node's right child
					Set_Right_Child(new_node, new_record));
					RightPut := true;
				end if;
				mutable(count) := '#';									-- Regardless of what steps were followed above, set current char to # and move on
			when '+'|'-'|'*'|'/'|'^' =>
				tempstring := mutable(count .. count);				-- Assign current char to be a 1-char string called tempstring, will be stored 
				new_record.operator := tempstring;						-- Put operator into the new_node
				OperPut := true;
				mutable(count) := '#';
				Set_Data(new_node, new_record);						-- Put the operator (stored in new_record) into new_node
				Set_Right_Child(new_node, Construct_ExpressionTree(mutable, count, last));
			when ')' =>														-- Reaching a right paran means I'm done with this sub-expression
				LeftPut  := false;
				OperPut  := false;
				RightPut := false;
		end case;
		
	end loop;

	return null;
end Construct_ExpressionTree;

procedure spare_parts is
	expression	:	varying_string(1024);
	int			:	integer;						-- This will be used for converting from original expression_string to integer
	Next			:	character;					-- Next and Endline are used with the LookAhead procedure built into ADA. 
	Endline		:	boolean;						-- Next is the next character in the string, Endline is checking if EOL has been hit.
	
begin
	put_line("This program is going to perform calculations using binary trees."); 
	put_line("You have to use single digit numbers and fully paranthesized parameters for right now, okay? I might fix it later."); 
	put("Enter your expression:  ");
	get_line(expression.value, expression.length);
	
--	for i in 1 .. expression.length loop
	while not end_of_line loop
		case expression.value(i) is 
			when '(' =>
--				create a new node
				lookahead(next, endline);
					if next = '1'..'0'				-- Not sure if this is how you write it, but you get the idea
						node.left.data := next;
						node.data := current;
						
			when '1'..'0' => 
				
				
		end case;
	end loop;
