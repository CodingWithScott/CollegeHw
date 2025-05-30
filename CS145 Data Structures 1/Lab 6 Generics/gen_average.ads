-- Scott Felch
-- 1 March 2012
-- CSCI 145, Lab 6
-- Generic Average Specification File. I don't really know what I'm doing but I'm just going to start putting ideas down on "paper".

generic
	type Item_Type is private;
	type Index_Type is (<>);
	type Array_Type is array (Index_Type range <>) of Item_Type;
	type Average_Type is private;
	
	-- Need to override math operators since they're undefined in generic form.
	with function "+"(Left : Item_Type; 	Right : Average_Type) return Average_Type;		-- This will be used for adding in the 3 Average functions
	with function "-"(Left : Average_Type;	Right : Average_Type) return Average_Type;		-- This will be used for subtracting a sum from a sum
	with function "/"(Left : Average_Type; 	Right : natural)      return Average_Type;		-- This will be used for dividing a sum by how many units there are
	
	-- Book = Item_Type
	-- Sum  = Average_Type
	
function gen_average(A : in Array_Type) return Average_Type;
