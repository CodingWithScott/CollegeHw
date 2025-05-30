with Ada.Text_IO, Ada.Integer_Text_IO;  
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure InsertionSort is
	type Integer_Array is array(Natural range <>) of Integer;
	A : Integer_Array := (17, 3, 4, 9, 18, 26, 8, 6, 15);
	
	procedure Print is
	begin
		for I in A'Range loop
			Put (Integer'Image (A (I)) & "   ");
		end loop;
		new_line;
	end Print;
	 
	procedure Sort(A : in out Integer_Array) is
		First : Natural := A'First;
		Last  : Natural := A'Last;
		Value : Integer;
		J     : Integer;
	begin
		for I in (First + 1)..Last loop
			Value := A(I);
			J := I - 1;
	
			while J in A'range and then A(J) > Value loop
				A(J + 1) := A(J);
				J := J - 1;
			end loop;
	
			A(J + 1) := Value;
			
			for I in A'Range loop
				Put (Integer'Image (A (I)) & "   ");
			end loop;
			new_line;
		end loop;
	end Sort;
	
begin
	Put(ASCII.ESC & "[2J");
	put_line("******************************************");
	put_line("****** Insertion Sort Demonstration ******");
	put_line("******************************************"); 
	
	put_line("Initial:  "); 
	Print; new_line;

	put_line("Intermediate:  "); 
	Sort (A);
	new_line; 
   
	put_line("Final:  "); 
	Print; new_line;
end InsertionSort;
