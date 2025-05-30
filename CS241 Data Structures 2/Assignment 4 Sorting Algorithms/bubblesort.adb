with Ada.Text_IO, Ada.Integer_Text_IO;  
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure BubbleSort is
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
		Finished 	:	Boolean;
		pass	 	:	integer := 1;
		N			:	integer := A'length;	-- Number of times to loop through, decreases by 1 each time you loop through
		
		procedure Swap(Left, Right : in out integer) is
			TempElement :	Integer := Left;
		begin
			Left := Right;
			Right := TempElement;
		end Swap;
	begin
		loop
			put("Pass "); put(pass, 2); Put(":"); new_line;

			Finished := True;
			for index in 1 .. N-1 loop
--					put(ASCII.ht); put(ASCII.ht); 
--					put("Comparing:  "); put(A(index), 2); put(", "); put(A(index+1), 2); new_line;
				if A (index) > A (index+1) then
--					put(ASCII.ht); put(ASCII.ht); put("Shifting performed:  ");	
--					put(A(index), 2); put(" >"); put(A(index+1), 2); new_line; new_line;
					Swap(A(index), A(index+1));
					Finished := False;
--					Print;
				end if;
				Print;
			end loop;
--			Put("Pass "); put(pass, 2); put_line(" finished.");
			pass := pass + 1;
			N := N - 1;
			exit when Finished;
		end loop;
	end Sort;

begin
	Put(ASCII.ESC & "[2J");
	put_line("***************************************");
	put_line("***     Bubble Sort Demonstration   ***");
	put_line("***************************************"); 

	put_line("Initial:  "); 
	Print; new_line;

	put_line("Intermediate:  "); 
	Sort (A);
	new_line; 
   
	put_line("Final:  "); 
	Print; new_line;
end BubbleSort;
