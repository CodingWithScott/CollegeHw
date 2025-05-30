type Integer_Array is array (Positive range <>) of Integer;
 
procedure Bubble_Sort (A : in out Integer_Array) is
	Finished : Boolean;
	Temp     : Integer;
begin
	loop
		Finished := True;
		for J in A'First .. A'Last-1 loop
			if A(J) > A (J+1) then
				Finished := False;
				Temp := A(J+1);
				A(J+1)) := A (J);
				A (J) := Temp;
			end if;
		end loop;

		exit when Finished;
	end loop;
end Bubble_Sort;
 
--  Example of usage:
with Ada.Text_IO; use Ada.Text_IO;
with Bubble_Sort;
procedure Main is
	type Arr is array (Positive range <>) of Integer;
	procedure Sort is new
		Bubble_Sort
			(Element => Integer,
				Index   => Positive,
				Arr     => Arr);
	A : Arr := (1, 3, 256, 0, 3, 4, -1);
begin
	Sort (A);
	for J in A'Range loop
		Put (Integer'Image (A (J)));
	end loop;
	New_Line;
end Main;
