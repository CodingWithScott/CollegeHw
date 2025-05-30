

generic
	type Item_Type is private;
	type Index_Type is (<>);
	type Array_Type is array (Index_Type range <>) of Item_Type;
	with function "<"(Item1, Item2 : in Item_type) return boolean;
	
procedure gen_sort(A : in out Array_Type);

