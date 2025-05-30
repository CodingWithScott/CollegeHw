-----------------------------------------------------------------------
--  Ropes.Test_Utils package body
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

with Ropes.String_Impl;
with Ropes.Concat_Impl;

with Tracking_Pools.Allocation_Message;

package body Ropes.Test_Utils is

	procedure Set_Memory_Verbose (Verbose : Boolean) is
	begin
		Memory_Verbose := Verbose;
	end Set_Memory_Verbose;

	---------------------------------------------------------------------------
	--  Functions for internal testing that expose the structure of Rope_Impls.
	---------------------------------------------------------------------------
	
	--  Get the maximum size for a String in a Small_String_Impl
	function Get_Max_Small_String return Natural is
	begin
		return Ropes.String_Impl.Max_Small_String;
	end Get_Max_Small_String;
	
	--  Test to see whether the Rope_Impl referenced by a Rope is null.
	function Is_Null (Source : Rope) return Boolean is
	begin
		return Source.B = null;
	end Is_Null;

	--  Test whether the Rope_Impl reference by a Rope is a String_Impl.
	function Is_String_Impl (Source : Rope) return Boolean is
	begin
		return Source.B /= null and then Source.B.all in Ropes.String_Impl.String_Impl'Class;
	end Is_String_Impl;
	
	--  Test whether the Rope_Impl reference by a Rope is a Large_String_Impl.
	function Is_Large_String_Impl (Source : Rope) return Boolean is
		pragma Warnings (Off, Source);
	begin
--		return False;
        return Source.B /= null and then Source.B.all in String_Impl.Large_String_Impl'Class;
	end Is_Large_String_Impl;
	
	--  Test whether the Rope_Impl reference by a Rope is a Small_String_Impl.
	function Is_Small_String_Impl (Source : Rope) return Boolean is
		pragma Warnings (Off, Source);
	begin
--		return False;
        return Source.B /= null and then Source.B.all in String_Impl.Small_String_Impl'Class;
	end Is_Small_String_Impl;
	
	--  Test whether the Rope_Impl reference by a Rope is a Concat_Impl.
	function Is_Concat_Impl (Source : Rope) return Boolean is
	begin
		return Source.B /= null and then Source.B.all in Ropes.Concat_Impl.Concat_Impl'Class;
	end Is_Concat_Impl;
	
	--  Test whether the Rope_Impls reference by two Ropes are the same.
	function Is_Same_Impl (Left, Right : Rope) return Boolean is
	begin
		return Left.B = Right.B;
	end Is_Same_Impl;
	
	--  Get the left child of a Concat_Impl. Returns a Null Rope if this is
	--  not a Concat_Impl.
	function Get_Left_Child (Source : Rope) return Rope is
		Impl : Rope_Impl_Access;
		Child : Rope;
	begin
		if Source.B /= null and Source.B.all in Ropes.Concat_Impl.Concat_Impl'Class then
			Impl := Ropes.Concat_Impl.Concat_Impl (Source.B.all).L;
			Child := Rope'(Ada.Finalization.Controlled with B => Impl);
			Inc_Ref_Count (Impl);
			return Child;
		else
			return Null_Rope;
		end if;
	end Get_Left_Child;
	
	--  Get the right child of a Concat_Impl. Returns a Null Rope if this is
	--  not a Concat_Impl.
	function Get_Right_Child (Source : Rope) return Rope is
		Impl : Rope_Impl_Access;
		Child : Rope;
	begin
		if Source.B /= null and Source.B.all in Ropes.Concat_Impl.Concat_Impl'Class then
			Impl := Ropes.Concat_Impl.Concat_Impl (Source.B.all).R;
			Child := Rope'(Ada.Finalization.Controlled with B => Impl);
			Inc_Ref_Count (Impl);
			return Child;
		else
			return Null_Rope;
		end if;
	end Get_Right_Child;
	
	---------------------------------------------------------------------------
	--  Functions for manipulating the Rope_Pool.
	---------------------------------------------------------------------------

	procedure Rope_Pool_Clear_Counts is
	begin
		Rope_Pool.Clear_Counts;
	end Rope_Pool_Clear_Counts;
	
	function Rope_Pool_Is_Balanced return Boolean is
	begin
		return Rope_Pool.Is_Balanced;
	end Rope_Pool_Is_Balanced;

	function Rope_Pool_Allocation_Message return String is
	begin
		return Tracking_Pools.Allocation_Message (Rope_Pool);
	end Rope_Pool_Allocation_Message;

end Ropes.Test_Utils;
