-- Scott Felch
-- 1 March 2012
-- CSCI 145, Lab 6
-- Generic Average Body File. This is a super simple function, it just reads through an array from beginning to end and sums up the data, then divides by how many items there are.

function Gen_Average (A : in Array_Type) return Average_Type is
--	Position 	:	Index_Type;
	Sum		:	Average_Type;
	Count		:	natural := 0;
begin
	-- I don't know how to initialize something to 0 in a generic without getting an error, but this has the same effect. There's probably a better way to do it, I don't know yet.
	sum := sum - sum;
	
	for I in A'range loop
		Sum := A(I) + Sum;
		count := count + 1;
	end loop;
	sum := sum / count;
	
	return Sum;
end Gen_Average;
