-----------------------------------------------------------------------
--  Ropes.String_Impl package spec
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

--  A String_Impl is a Rope_Impl that contains a simple string.
--  String_Impls are managed by a pointer to the underlying string. (As
--  opposed to embedding the string in the String_Impl object.

with Ropes.Concat_Impl;
use  Ropes.Concat_Impl;

private package Ropes.String_Impl is

	--  Future: Max_Small_String is the maximum size for a small string.
	--  A small string is embedded in the String_Impl rather than being
	--  pointed to by the impl. This constant is exposed to allow test
	--  programs to know the size.
	Max_Small_String : constant Natural := 8;

	type String_Impl is abstract new Ropes.Rope_Impl with null record; 
	
--	type Small_String_Impl is new Ropes.String_Impl with record
	type Small_String_Impl is new String_Impl with record
		S : String (1 .. Max_Small_String);
	end record;
	
	--  See Ropes.ads for these procedures
	
	------------------------------------------------------
	-- 				Small String Methods				--
	------------------------------------------------------
	overriding
	procedure Dispose (R : access Small_String_Impl);

	overriding
	function Element (Source : Small_String_Impl; Index : Positive) return Character;

	overriding
	procedure To_String (Source : access constant Small_String_Impl;
						 Target : in out String; Start : in Positive);
	
	
	--------------------------------------------------------------
	-- My additions for Part 2, step 3 (continued below)
	--------------------------------------------------------------
	
 	overriding
	function "&" (Left : string; Right : access Small_String_Impl) 
		return Rope_Impl_Access;
	overriding 
	function "&" (Left : access Small_String_Impl; Right : string) 
		return Rope_Impl_Access;
	--------------------------------------------------------------
	--------------------------------------------------------------
	
	overriding
	function Slice (Source : access Small_String_Impl;
					Low : Positive; High : Positive)
	  return Rope_Impl_Access;

	--  Impl_Text_Contents returns a string which is a copy of the underlying
	--  string.
	overriding
	function Impl_Text_Contents (R : access constant Small_String_Impl) return String;
	
	
--	type Large_String_Impl is new Ropes.String_Impl with record
	type Large_String_Impl is new String_Impl with record
		S : String_Access;
	end record;
	
	------------------------------------------------------
	-- 			  Large String Methods					--
 	--  	(Identical to original String_Impl)			--
   	------------------------------------------------------
	overriding
	procedure Dispose (R : access Large_String_Impl);

	overriding
	function Element (Source : Large_String_Impl; Index : Positive) return Character;

	overriding
	procedure To_String (Source : access constant Large_String_Impl;
						 Target : in out String; Start : in Positive);
					
					
	--------------------------------------------------------------
	-- My additions for Part 2, step 3 (continued)				--
	--------------------------------------------------------------
	
	
	-- Are these supposed to return Ropes or Rope_Impl_Access? I was getting errors with Rope
	-- and changed it to Rope_Impl_Access and got rid of those but now I have more errors.
	-- I'm not sure if I'm actually making progress or not.
	
	overriding
	function "&" (Left : string; Right : access Large_String_Impl)
		return Rope_Impl_Access;
	overriding 
	function "&" (Left : access Large_String_Impl; Right : string) 
		return Rope_Impl_Access;
	--------------------------------------------------------------
	--------------------------------------------------------------


	overriding
	function Slice (Source : access Large_String_Impl;
					   Low : Positive; High : Positive)
	  return Rope_Impl_Access;

	--  Impl_Text_Contents returns a string which is a copy of the underlying
	--  string.
	overriding
	function Impl_Text_Contents (R : access constant Large_String_Impl) return String;

	package Make is

		--  Make_String_Impl makes a copy of Source and returns a String_Impl
		--  which contains or references the copy. Make_String_Impl returns a
		--  null pointer if Source has zero length.
		function Make_String_Impl (Source : in String) return Rope_Impl_Access;
	
	end Make;

	--  Expose Make_String_Impl as part of the parent package.
	function Make_String_Impl (Source : in String) return Rope_Impl_Access
		renames Make.Make_String_Impl;

end Ropes.String_Impl;
