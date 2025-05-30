-----------------------------------------------------------------------
--  Ropes package body
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

with Ada.Strings.Fixed;
with Ada.Text_IO;
with Ada.Tags;
with System.Storage_Elements;

with Ropes.String_Impl; use Ropes.String_Impl;
with Ropes.Concat_Impl; use Ropes.Concat_Impl;

package body Ropes is

	--  Note that the Rope_Impl_Access in a Rope can be null. For this
	--  reason, all routines that manipulate Ropes (as opposed to
	--  Rope_Impls) must check for a null pointer and do the right thing,
	--  which is whatever is correct for a null string.

	--  Length returns the length of Source, which is the same as the length
	--  of the string represented by the rope.
	function Length (Source : in Rope) return Natural is
	begin
		if Source.B = null then
			return 0;
		else
			return Length (Source.B.all);
		end if;
	end Length;

	--  Element returns the character at position Index in Source. The
	--  first character of a Rope has Index one (1). The last character has
	--  Index Length (Source). If Index > Length (Source), a Constraint_Error
	--  will be raised.
	function Element (Source : Rope; Index : Positive) return Character is
	begin
		if Index > Source.Length then
			raise Constraint_Error with "Rope Index out of range";
		end if;
		--  If Source.B is null, Index > Source.Length should have been true
		pragma Assert (Source.B /= null);
		return Element (Source.B.all, Index);
	end Element;

	--  To_Rope returns a Rope containing the contents of the ordinary
	--  string Source. To_Rope makes a copy of Source so it cannot be
	--  modified by later changes to Source.
	function To_Rope (Source : in String) return Rope is
		Result : constant Rope_Impl_Access := Make_String_Impl (Source);
	begin
		--  Result will be null if Source has length zero. Incrementing the
		--  Ref_Count of Result is not required since Make_String_Impl
		--  returns a Rope_Impl with Ref_Count = 1.
		return Rope'(Ada.Finalization.Controlled with B => Result);
	end To_Rope;

	--  To_String returns an ordinary String that contains the contents
	--  of the Rope Source. The returned String will have indices in the
	--  range 1 .. Length (Source).
	function To_String (Source : in Rope) return String is
	begin
		if Source.B = null then
			return "";
		end if;
		declare
			Result : String (1 .. Length (Source.B.all));
		begin
			To_String (Source.B, Result, 1);
			return Result;
		end;
	end To_String;

	--  Copy makes a copy of the given Rope.
	function Copy (Source : Rope) return Rope is
	begin
		--  Increment Reference Count and return a copy.
		if Source.B /= null then
			Inc_Ref_Count (Source.B);
		end if;
		return Rope'(Ada.Finalization.Controlled with B => Source.B);
	end Copy;

	--  & is an overloaded form of the Ada String concatenation operator.
	--  Three versions are provided. For concatenating two Ropes or a Rope
	--  and a String.
	function "&" (Left, Right : Rope) return Rope is
	begin
		--  We must increment the ref counts for Left.B and Right.B since
		--  Make_Concat_Impl expects to borrow these references.
		if Left.B /= null then
			Inc_Ref_Count (Left.B);
		end if;
		if Right.B /= null then
			Inc_Ref_Count (Right.B);
		end if;
		return Rope'(Ada.Finalization.Controlled with
						B => Make_Concat_Impl (Left.B, Right.B));
	end "&";



	----------------------------------------------------------------------------
	-- My additions for Part 2, step 2										  --
	----------------------------------------------------------------------------

	-- Need to & a rope_impl and a string
	-- and a string and rope_impl
	function "&" (Left : Rope; Right : String) return Rope is
		Result : Rope;
	begin
		Result.B := Left.B & Right;
		return Result;
--		return Rope'(Ada.Finalization.Controlled with 
--				B => Left.B & Right);
			
	end "&";

	function "&" (Left : String; Right : Rope) return Rope is
		Result : Rope;
	begin
--		return Rope'(Ada.Finalization.Controlled with 
--				B => Left & Right.B);
		Result.B := Left & Right.B;
		return Result;

	end "&";
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------




--	function "&" (access Rope_Impl, String) return Rope_Impl_Access;
--	function "&" (String, access Rope_Impl) return Rope_Impl_Access;

	--  Slice return a new Rope which is corresponds to the characters with
	--  indices Low .. High (inclusive) of the original Rope. The indices of
	--  the Rope that is returned will be 1 .. High - Low + 1. If
	--  Low > Length (Source) + 1, a Constraint_Error will be raised. If
	--  High > Length (Source), then High = Length (Source) is assumed. If Low
	--  is in the valid range and High < Low, a Null_Rope will be returned.
	function Slice (Source : Rope; Low : Positive; High : Natural) return Rope is
		Source_Length : constant Natural := Length (Source);
		Real_High : constant Natural := Natural'Min (High, Source_Length);
		Result : Rope_Impl_Access;
	begin
		if Low > Source_Length + 1 then
			raise Constraint_Error with "Rope Index out of range";
		end if;
		if Real_High < Low then
			return Null_Rope;
		end if;
		Result := Source.B.Slice (Low, Real_High);
		return Rope'(Ada.Finalization.Controlled with B => Result);
	end Slice;

	--  Adjust for Ropes. Adjust is called when a new Rope_Impl_Access
	--  replaces the old Rope_Impl_Access. This procedure must account
	--  for additional Ref_Count for the new Rope_Impl.
	procedure Adjust (R : in out Rope) is
	begin
		if Memory_Verbose then
			Ada.Text_IO.Put_Line ("Adjust " & Rope_Text_Image (R));
		end if;
		--  Only increment for non-null Rope_Impls.
		if R.B /= null then
			Inc_Ref_Count (R.B);
		end if;
	end Adjust;

	--  Finalize for Ropes. Finalize is called when the current
	--  Rope_Impl_Access is about to be overwritten or discarded. This
	--  procedure must decrement the Ref_Count for the Rope_Impl to
	--  reflect that the reference is about to be destroyed.
	procedure Finalize (R : in out Rope) is
	begin
		if Memory_Verbose then
			Ada.Text_IO.Put_Line ("Finalize " & Rope_Text_Image (R));
		end if;
		if R.B /= null then
			Dec_Ref_Count (R.B);
			if R.B.Ref_Count = 0 then
				Free (R.B);
			end if;
		end if;
	end Finalize;

	--  Length returns the Length of the Rope_Impl. This routine returns
	--  the length value.
	function Length (Source : in Rope_Impl) return Natural is
	begin
		return Source.Length;
	end Length;

	--  Increment the Ref_Count of the R. Inc_Ref_Count should only be called
	--  with R /= null.
	procedure Inc_Ref_Count (R : access Rope_Impl'Class) is
	begin
		
		pragma Assert (R /= null, "Inc_Ref_Count called with a null pointer.");
		R.Ref_Count := R.Ref_Count + 1;
		if Memory_Verbose then
			declare
				Ref_Count_Str : constant String := Integer'Image (R.Ref_Count);
			begin
				Ada.Text_IO.Put_Line ("Inc_Ref_Count " & Impl_Text_Image (R) & " to" & Ref_Count_Str);
			end;
		end if;
	end Inc_Ref_Count;

	--  Decrement the Ref_Count of the R. Dec_Ref_Count should only be called
	--  with R /= null.
	--
	--  Dec_Ref_Count will automatically call Dispose if the Ref_Count is
	--  decremented to zero. The caller of Dec_Ref_Count must still check to
	--  see if the count was decremented to zero and Free the Rope_Impl if
	--  it was.
	procedure Dec_Ref_Count (R : access Rope_Impl'Class) is
	begin
		pragma Assert (R /= null, "Dec_Ref_Count called with a null pointer.");
		pragma Assert (R.Ref_Count > 0, "Dec_Ref_Count called with non-positive Ref_Count");
		R.Ref_Count := R.Ref_Count - 1;
		if Memory_Verbose then
			declare
				Ref_Count_Str : constant String := Integer'Image (R.Ref_Count);
			begin
				Ada.Text_IO.Put_Line ("Dec_Ref_Count " & Impl_Text_Image (R) & " to" & Ref_Count_Str);
			end;
		end if;
		if R.Ref_Count = 0 then
			Dispose (R);
		end if;
	end Dec_Ref_Count;

	--  Utility function. Produces a String from an address.
	function Address_String (Addr : System.Address) return String is
		use System.Storage_Elements;
		Address_Str : constant String := Integer_Address'Image (To_Integer (Addr));
	begin
		return Address_Str (2 .. Address_Str'Length);
	end Address_String;

	--  Utility functions which produces a string describing a Rope.
	--
	--  Rope_Text_Image returns a string of the form
	--  "[Rope@<<address>> [<<class>>@<<address>>]]".
	--  where <<class>> is the actual class of the Rope_Impl,
	--		<<address>> is the memory address of the Rope or Rope_Impl,
	function Rope_Text_Image (R : in Rope'Class) return String is
	begin
		if R.B = null then
			return "[Rope@" & Address_String (R'Address) & " null]";
		else
			return "[Rope@" & Address_String (R'Address) & " " & Impl_Text_Image(R.B, False) & "]";
		end if;
	end Rope_Text_Image;

	--  Utility functions which produce a string describing a Rope_Impl.
	--
	--  Impl_Test_Image returns a string of the form
	--  "[<<class>>@<<address>> <<contents>>]"
	--  where <<class>> is the actual class of the Rope_Impl,
	--		<<address>> is the memory address of the Rope or Rope_Impl,
	--	and <<contents>> is the result of calling Impl_Text_Contents of the
	--			 Rope_Impl.
	--  If Full is False, the contents portion of the Rope_Impl is suppressed.
	function Impl_Text_Image (R : access constant Rope_Impl'Class; Full : Boolean := True) return String is
		use Ada.Strings; use Ada.Strings.Fixed;
		Full_Name : constant String := Ada.Tags.External_Tag (R'Tag);
		I : constant Natural := Index (Full_Name, ".", Backward);
		Short_Name : constant String := Full_Name (I + 1 .. Full_Name'Length);
		Address_Str : constant String := Address_String (R.all'Address);
	begin
		if Full then
			return "[" & Short_Name & "@" & Address_Str & Impl_Text_Contents (R) & "]";
		else
			return "[" & Short_Name & "@" & Address_Str & "]";
		end if;
	end Impl_Text_Image;

	--  Impl_Text_Contents provides a String descriptive of the contents of
	--  R. This is called by Impl_Text_Image to create a string describing
	--  the Rope_Impl. The default implementation of this function returns
	--  the null string ("").
	function Impl_Text_Contents (R : access constant Rope_Impl) return String is
		pragma Warnings (Off, R);
	begin
		return "";
	end Impl_Text_Contents;

end Ropes;
