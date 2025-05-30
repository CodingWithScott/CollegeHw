
mutable			:		string(1 .. 20);

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
