-- Scott Felch
-- 12 October 2012
-- CSCI 241
-- Tree_expression package body

with Gen_Tree, Ada.Numerics.Generic_Elementary_Functions, Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings, Ada.Strings.Fixed;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Strings, Ada.Strings.Fixed;

PACKAGE body Tree_Expression IS
	package Float_Functions 		 is new Ada.Numerics.Generic_Elementary_Functions (Float_Type => Float);
	use Float_Functions;

	-- I originally got an idea for an algorithm similar to this from Milo Price but couldn't get it to work properly, Chris Koos and mentor Tim helped me fine tune it into this.
	function Construct_ExpressionTree (Expression_String : String; First, Last : Natural) return Expression_Node_Ptr is
		paran_ctr		:		natural := 0;
		tempguts		:		guts;
	begin
		-- Base case: it's a digit, construct a leaf node containing a digit and nothing else.
		if Expression_String(First) in '1' .. '9' then 	-- Base case: current char is a number. Return a leaf node with only the number as data and L and R pointers are null
			tempguts.number := integer'value(expression_string(first..first));	-- Take single char from expression_string, convert to integer, store in tempguts record 
			return Binary_Expression_Tree.Create_Node(tempguts, null, null);	-- Return a new node holding the tempguts record
		end if;
		
		-- Recursive case: it's a paran or an operator, increment paran_ctr or recursively call Construct with data left and right of the operator
		for count in First .. Last loop
			case Expression_String(count) is
				when '(' =>	paran_ctr := paran_ctr + 1;		-- ( will increment the paran counter
				when ')' =>	paran_ctr := paran_ctr - 1;		-- ) will decrement the paran counter
				when '+' | '-' | '*' | '^' | '/' =>
					if paran_ctr = 1 then					-- If paran counter is at 1 then I know I've hit a dominant operator and make a new parent node. Left child is everything left of operator, right child is everything right of operator.
						tempguts.operator := Expression_String(count);
						return Create_Node(tempguts, Construct_ExpressionTree(expression_string, First+1, count-1), Construct_ExpressionTree(expression_string, Count+1, Last-1));
					end if;
				when others =>	-- Should never happen, but ADA compiler gets mad if I don't have it here.
					null;
			end case;
		end loop;
		return null;	-- Should also never happen.
	end Construct_ExpressionTree;

	--######################################################################################################
	--# These traversal procedures are basically verbatim reproductions of pseudocode given to us in class #
	--######################################################################################################	
	-- Recursive pre order traversal, Parent -> Left -> Right
	procedure Prefix_Notation  (Node : Expression_Node_Ptr) is
	begin
		if Get_Data(Node).operator = '#' then	-- If operator is default placeholder, then this is a number node and need to output the number data field
			put(Get_Data(node).number, width => 2);
		else 	-- If operator is something other than default placeholder, then this is an operator node, need to output the operator.
			put(" "); put(Get_Data(node).operator); put(" ");
		end if;	
		
		if get_left_child(node) /= null then		-- Check there is a left_child before trying to print something, otherwise get Constraint error.
			Prefix_Notation(Get_Left_Child(Node));
		end if;
		if get_right_child(node) /= null then		-- See above.
			Prefix_notation(Get_Right_Child(Node));
		end if;
	End Prefix_Notation;

	-- Recursive in order traversal, Left -> Parent -> Right	
	procedure Infix_Notation   (Node : Expression_Node_Ptr) is
	begin
		if get_left_child(node) /= null then
			put("(");								-- Infix_notation requires ( to be printed before every time descending down a tree to the left
			Infix_Notation(Get_Left_Child(Node));
		end if;
		
		if Get_Data(Node).operator = '#' then	-- If operator is default placeholder, then this is a number node and need to output the number data field
			put(Get_Data(node).number, width => 2);
		else 	-- If operator is something other than default placeholder, then this is an operator node, need to output the operator.
			put(" "); put(Get_Data(node).operator); put(" ");
		end if;	
		
		if get_right_child(node) /= null then	
			Infix_Notation(Binary_Expression_Tree.Get_Right_Child(Node));
			put(")");	-- Infix_notation requires ) to be printed after everty time ascending up from a tree from the right
		end if;
	end Infix_Notation;

	-- Recursive post order traversal, Left -> Right -> Parents	
	procedure Postfix_Notation (Node : Expression_Node_Ptr) is
	begin
		if get_left_child(node) /= null then	-- Check there is a left_child before trying to print something, otherwise get Constraint error.
			Postfix_Notation(Get_Left_Child(Node));
		end if;

		if get_right_child(node) /= null then	-- See above.
			Postfix_Notation(Get_Right_Child(Node));
		end if;
		
		if Get_Data(Node).operator = '#' then	-- If operator is default placeholder, then this is a number node and need to output the number data field
			put(Get_Data(node).number, width => 2);
		else 	-- If operator is something other than default placeholder, then this is an operator node, need to output the operator.
			put(" "); put(Get_Data(node).operator); put(" ");
		end if;	
	End Postfix_Notation;

	-- Recursive evaluate expression function, using in_order traversal.
	function Evaluate_Expression (Input : Expression_Node_Ptr) return Float is
	begin
		if Get_Data(Input).operator = '#' then		-- Base case: This node is a digit, return just the float of the value in it
			return float(Get_Data(input).number);
		else										-- Recursive case: This node is an operator, recursively call Evaluate_Expression with left and right children of operator as operands
			case Get_Data(Input).operator is 
				when '+' => return (Evaluate_Expression (Get_Left_Child(Input)) + Evaluate_Expression (Get_Right_Child(Input)));
				when '-' => return (Evaluate_Expression (Get_Left_Child(Input)) - Evaluate_Expression (Get_Right_Child(Input)));
				when '*' => return (Evaluate_Expression (Get_Left_Child(Input)) * Evaluate_Expression (Get_Right_Child(Input)));
				when '/' => return (Evaluate_Expression (Get_Left_Child(Input)) / Evaluate_Expression (Get_Right_Child(Input)));
				when '^' => return (Evaluate_Expression (Get_Left_Child(Input)) ** Evaluate_Expression (Get_Right_Child(Input)));
				when others =>
					return 0.0; -- This should never happen, since any other input other than the above operators will already have been filtered out before this point. ADA requires an "others" case though or it throws a fit.
			end case;
		end if;
	end Evaluate_Expression;
end Tree_Expression;
