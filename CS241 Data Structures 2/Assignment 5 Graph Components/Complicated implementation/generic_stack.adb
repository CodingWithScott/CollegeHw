-- generic_stack.adb:  Ada generic package implementation for stack
-- http://cs.fit.edu/~ryan/ada/programs/overview/generic_stack-adb.html

package body Generic_Stack is

	procedure Push (Item: in Item_Type; Stack: in out Stack_Type) is
	begin
		Stack.Top := Stack.Top + 1;
		Stack.Elements (Stack.Top) := Item;
	end Push;

	procedure Pop (Item: out Item_Type; Stack: in out Stack_Type) is
	begin
		Item := Stack.Elements (Stack.Top);
		Stack.Top := Stack.Top - 1;
	end Pop;

end Generic_Stack;

