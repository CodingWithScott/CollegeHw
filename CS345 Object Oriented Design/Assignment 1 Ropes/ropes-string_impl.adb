-----------------------------------------------------------------------
--  Ropes.String_Impl package bpdy
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

package body Ropes.String_Impl is


	------------------------------------------------------
	-- 				Small String Methods				--
	------------------------------------------------------
	
	-- Dispose is just a null method, there's no such thing as "disposing" a string
	overriding
	procedure Dispose (R : access Small_String_Impl) is
	begin
		null;
	end Dispose;

	overriding
	function Element (Source : Small_String_Impl; Index : Positive)
		return Character is
	begin
		pragma Assert (Index <= Source.S'Length);
		return Source.S (Index);
	end Element;

	overriding
	procedure To_String (Source : access constant Small_String_Impl;
						 Target : in out String; Start : in Positive) is
	begin
		Target (Start .. Start + Source.Length - 1) := 
--			Source.S (Start .. Start + Source.Length - 1);
			Source.S (1 .. Source.Length);
--		Target (1 .. Source.Length) := Source.S (1 .. Source.Length);
	end To_String;
	
 	overriding
	function "&" (Left  : string; 
				  Right : access Small_String_Impl) return Rope_Impl_Access is
	begin
		if (Left'Length + Right.Length) > Max_Small_String then
			Inc_Ref_Count(Right);
			return Make_Concat_Impl(Make_String_Impl(Left), Rope_Impl_Access(Right));
		else -- If total length is < 8
			return Make_String_Impl(Left & Right.S(1 .. Right.Length));			
		end if;
--		return To_Rope(Left & Right.S);
	end "&";
	
	
	overriding 
	function "&" (Left : access Small_String_Impl;
	 			 Right : string) return Rope_Impl_Access is
	begin
		if (Left.Length + Right'Length) > Max_Small_String then
			Inc_Ref_Count(Left);
			return Make_Concat_Impl(Rope_Impl_Access(Left), Make_String_Impl(Right));
		else -- If total length is < 8
			return Make_String_Impl(Left.S(1 .. Left.Length) & Right);
		end if;
	end "&";

	overriding
	function Slice (Source : access Small_String_Impl;
					   Low : Positive; High : Positive) return Rope_Impl_Access is
	begin
		pragma Assert (Low <= High and High <= Source.Length);
		if Low = 1 and High = Source.Length then
			Inc_Ref_Count (Source);
			return Rope_Impl_Access (Source);
		end if;
		return Make_String_Impl (Source.S (Low .. High));
	end Slice;

	overriding
	function Impl_Text_Contents (R : access constant Small_String_Impl)
		return String is
	begin
		return " " & R.S;
	end Impl_Text_Contents;
   	------------------------------------------------------

	------------------------------------------------------
	--   Large String Methods							--
 	--   Identical to original String_Impl				--
   	------------------------------------------------------
	overriding
	procedure Dispose (R : access Large_String_Impl) is
	begin
		Free (R.S);
	end Dispose;

	overriding
	function Element (Source : Large_String_Impl; Index : Positive)
		return Character is
	begin
		pragma Assert (Index <= Source.S'Length);
		return Source.S (Index);
	end Element;

	overriding
	procedure To_String (Source : access constant Large_String_Impl;
						 Target : in out String; Start : in Positive) is
	begin
		Target (Start .. Start + Source.Length - 1) := Source.S.all;
--	  Target (1 .. 8) := Source.S.all;
	end To_String;
	
	
	--------------------------------------------------------------
	-- My additions for Part 2, step 5 (continued below)
	--------------------------------------------------------------
 	overriding
	function "&" (Left  : string; 
				  Right : access Large_String_Impl) return Rope_Impl_Access is
	begin
		Inc_Ref_Count(Right);
		return Make_Concat_Impl(Make_String_Impl(Left), Rope_Impl_Access(Right));
	end "&";
	
	overriding 
	function "&" (Left : access Large_String_Impl;
	 			 Right : string) return Rope_Impl_Access is
	begin
		Inc_Ref_Count(Left);
		return Make_Concat_Impl(Rope_Impl_Access(Left), Make_String_Impl(Right));		
	end "&";
	--------------------------------------------------------------
	--------------------------------------------------------------

	overriding
	function Slice (Source : access Large_String_Impl;
					Low : Positive; High : Positive)
		return Rope_Impl_Access is
	begin
		pragma Assert (Low <= High and High <= Source.Length);
		if Low = 1 and High = Source.Length then
			Inc_Ref_Count (Source);
			return Rope_Impl_Access (Source);
		end if;
		return Make_String_Impl (Source.S (Low .. High));
	end Slice;

	overriding
	function Impl_Text_Contents (R : access constant Large_String_Impl)
		return String is
	begin
		return " " & R.S.all;
	end Impl_Text_Contents;
	------------------------------------------------------
	
	
	--------------------------------------------------------------
	-- My additions for Part 2, step 5 (continued)
	--------------------------------------------------------------

	package body Make is
		-- This function is going to accept a string and return either a Small_String_Impl
		-- or Large_String_Impl. Need to code logic that will determine......

		-- (6 weeks later...) determine what? I have no idea. Does this section work?
		function Make_String_Impl (Source : in String)
			return Rope_Impl_Access is
		begin
			-- If length = 0 just return null
			if Source'Length = 0 then
				return null;
			-- If 0 < length <= 8 then create Small_String_Impl
			elsif Source'Length > 0 and Source'Length <= 8 then
				declare
--					Str : constant String_Access := new String (1 .. Source'Length);
					Str : String (1 .. Max_Small_String);

					--  Need to shift the index of Source to be 1 based
                    New_Impl : constant Rope_Impl_Access :=
					  new Small_String_Impl'(Ref_Count => 0,
									   Length => Source'Length, 
									   S => Str);
				begin
					Str(1 .. Source'Length) := Source;
					Small_String_Impl(New_Impl.all).s(1 .. Source'Length) := 
						str(1 .. Source'Length);
					Inc_Ref_Count (New_Impl);
					return New_Impl;
				end;
			-- If Source'Length > 8 then create Large_String_Impl
			else	
				declare
					Str : constant String_Access := new String (1 .. Source'Length);
					New_Impl : constant Rope_Impl_Access :=
					  new Large_String_Impl'(Ref_Count => 0,
									   Length => Source'Length, S => Str);
				begin
					--  Need to shift the index of Source to be 1 based
					--  ^^ what does that mean?
					Str.all := Source;
					Inc_Ref_Count (New_Impl);
					return New_Impl;
				end;
			end if;
		end Make_String_Impl;
	end Make;
	--------------------------------------------------------------
	--------------------------------------------------------------

end Ropes.String_Impl;
