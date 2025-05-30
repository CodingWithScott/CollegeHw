with Ada.Text_IO, Ada.Integer_Text_IO;  
use Ada.Text_IO, Ada.Integer_Text_IO;
 
 -- Still need to add intermediate step printing
 
procedure Quicksort is
   type Integer_Array is array (Positive range <>) of Integer;
   A : Integer_Array := (17, 3, 4, 9, 18, 26, 8, 6, 15);
   
   	procedure Print is
	begin
		for I in A'Range loop
			Put (Integer'Image (A (I)) & "   ");
		end loop;
		new_line;
	end Print;
	
	procedure Sort (Item : in out Integer_Array) is
	 
	   procedure Swap(Left, Right : in out Integer) is
		  Temp : Integer := Left;
	   begin
		  Left := Right;
		  Right := Temp;
	   end Swap;
	 
	   Pivot_Index : positive;
	   Pivot_Value : Integer;
	   Right       : positive := Item'Last;
	   Left        : positive := Item'First;
	 
	begin
	   if Item'Length > 1 then
		  Pivot_Index := positive'Val((positive'Pos(Item'Last) + 1 + 
										positive'Pos(Item'First)) / 2);
		  Pivot_Value := Item(Pivot_Index);
	 
		  Left  := Item'First;
		  Right := Item'Last;
		  loop
			 while Left < Item'Last and then Item(Left) < Pivot_Value loop
				Left := positive'Succ(Left);
			 end loop;
			 while Right > Item'First and then Item(Right) > Pivot_Value loop
				Right := positive'Pred(Right);
			 end loop;
			 exit when Left >= Right;
			 Swap(Item(Left), Item(Right));
			 if Left < Item'Last and Right > Item'First then
				Left := positive'Succ(Left);
				Right := positive'Pred(Right);
			 end if;
		  end loop;
		  if Right > Item'First then
			 Sort(Item(Item'First..positive'Pred(Right)));
		  end if;
		  if Left < Item'Last then
			 Sort(Item(Left..Item'Last));
		  end if;
	   end if;
	end Sort;
 
begin
 
   -- Print(Weekly_Sales);
   -- Ada.Text_Io.New_Line(2);
   -- Sort_Days(Weekly_Sales);
   -- Print(Weekly_Sales);
   
   	Put(ASCII.ESC & "[2J");
	put_line("***************************************");
	put_line("***     Quick Sort Demonstration   ***");
	put_line("***************************************"); 

	put_line("Initial:  "); 
	Print; new_line;

	put_line("Intermediate:  "); 
	Sort (A);
	new_line; 
   
	put_line("Final:  "); 
	Print; new_line;
 
end Quicksort;