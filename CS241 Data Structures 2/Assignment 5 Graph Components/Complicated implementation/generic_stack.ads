-- generic_stack.ads:  Ada generic package specification for stack
-- http://cs.fit.edu/~ryan/ada/programs/overview/generic_stack-ads.html

generic

	Stack_Size: in Integer;
	type Item_Type is private;

package Generic_Stack is

	type Stack_Type is private;
	procedure Push (Item: in Item_Type; Stack: in out Stack_Type);
	procedure Pop (Item: out Item_Type; Stack: in out Stack_Type);

private
	type Item_List_Type is array (1 .. Stack_Size) of Item_Type;

	type Stack_Type is record
		Top      : Integer range 0 .. Stack_Size := 0;
		Elements : Item_List_Type;
	end record;

end Generic_Stack;

