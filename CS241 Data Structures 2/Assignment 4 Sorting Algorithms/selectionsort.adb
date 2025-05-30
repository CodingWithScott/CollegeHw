with Ada.Text_IO, Ada.Integer_Text_IO;  
use Ada.Text_IO, Ada.Integer_Text_IO;
 
procedure SelectionSort is
	type Integer_Array is array (Positive range <>) of Integer;
	A : Integer_Array := (17, 3, 4, 9, 18, 26, 8, 6, 15);
   
   	procedure Print is
	begin
		for I in A'Range loop
			Put (Integer'Image (A (I)) & "   ");
		end loop;
		new_line;
	end Print;
   
   procedure Sort (A : in out Integer_Array) is
      Min  : Positive;
      Temp : Integer;
   begin
      for I in A'First..A'Last - 1 loop
         Min := I;
         for J in I + 1..A'Last loop
            if A (Min) > A (J) then
               Min := J;
            end if;
         end loop;
         if Min /= I then
            Temp    := A (I);
            A (I)   := A (Min);
            A (Min) := Temp;
         end if;

		for count in A'first..A'last loop
			put(A(count), 2); put("   ");
		end loop;
		new_line;
      end loop;
   end Sort;

begin
	Put(ASCII.ESC & "[2J");
	put_line("******************************************");
	put_line("****** Selection Sort Demonstration ******");
	put_line("******************************************"); 

	put_line("Initial:  "); 
	Print; new_line;

	put_line("Intermediate:  "); 
	Sort (A);
	new_line; 
   
	put_line("Final:  "); 
	Print; new_line;
end SelectionSort;
