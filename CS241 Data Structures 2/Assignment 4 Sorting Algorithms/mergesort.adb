with Ada.Text_IO, Ada.Integer_Text_IO;  
use Ada.Text_IO, Ada.Integer_Text_IO;
 
 -- Still need to add intermediate step printing
 
procedure Mergesort is
	type Integer_Array is array (Positive range <>) of Integer;
	A : Integer_Array := (17, 3, 4, 9, 18, 26, 8, 6, 15);
	
	recursive_counter	:	integer := -1;
	
	procedure Print(A : in integer_array) is
	begin
		for I in A'Range loop
			Put (Integer'Image (A (I)) & "   ");
		end loop;
		new_line;
	end Print;
 
   -----------
   -- Merge --
   -----------
   function Merge(Left, Right : Integer_Array) return Integer_Array is
      Result : Integer_Array(Left'First..Right'Last);
      Left_Index : positive := Left'First;
      Right_Index : positive := Right'First;
      Result_Index : positive := Result'First;
   begin
      while Left_Index <= Left'Last and Right_Index <= Right'Last loop
         if Left(Left_Index) <= Right(Right_Index) then
            Result(Result_Index) := Left(Left_Index);
            Left_Index := positive'Succ(Left_Index); -- increment Left_Index
         else
            Result(Result_Index) := Right(Right_Index);
            Right_Index := positive'Succ(Right_Index); -- increment Right_Index
         end if;
         Result_Index := positive'Succ(Result_Index); -- increment Result_Index
      end loop;
      if Left_Index <= Left'Last then
         Result(Result_Index..Result'Last) := Left(Left_Index..Left'Last);
      end if;
      if Right_Index <= Right'Last then
         Result(Result_Index..Result'Last) := Right(Right_Index..Right'Last);
      end if;
      return Result;
   end Merge;
 
   ----------
   -- Sort --
   ----------
	function Sort (Item : Integer_Array) return Integer_Array is
		Result : Integer_Array(Item'range);
		Middle : positive;
	begin
		recursive_counter := recursive_counter + 1;
		if recursive_counter > 0 then
			put("Recursive call:   "); put(recursive_counter); new_line;
			print(Item);
		end if;
		
		if Item'Length <= 1 then
			return Item;
		else
			Middle := positive'Val((Item'Length / 2) + positive'Pos(Item'First));
			if Middle mod 2 /= 0 then
				Middle := Middle + 1;
			end if;
			declare
				Left : Integer_Array(Item'First..positive'Pred(Middle));
				Right : Integer_Array(Middle..Item'Last);
			begin
				for I in Left'range loop
					Left(I) := Item(I);
				end loop;
				for I in Right'range loop
					Right(I) := Item(I);
				end loop;
				Left := Sort(Left);
				Right := Sort(Right);
				Result := Merge(Left, Right);
			end;
				return Result;
		end if;
	end Sort;
   
begin
	Put(ASCII.ESC & "[2J");
	put_line("***************************************");
	put_line("***     Merge Sort Demonstration    ***");
	put_line("***************************************"); 

	put_line("Initial:  "); 
	Print(A); new_line;

	put_line("Intermediate:  "); 
	A := Sort (A);
	new_line; 
   
	put_line("Final:  "); 
	Print(A); new_line;
end Mergesort;
