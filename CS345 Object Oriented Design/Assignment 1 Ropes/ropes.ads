-----------------------------------------------------------------------
--  Ropes package spec
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

--  "private with" means that these packages are only used in the private
--  private portion of this spec.
private with Ada.Unchecked_Deallocation;
private with Ada.Finalization;
private with Tracking_Pools;

--  package Ropes
--
--  The Ropes package provides an alternative implementation of the concept
--  of a string. (A Rope is a heavy-weight string.) The original concept is
--  discussed in the article: "Ropes: an Alternative to Strings", Boehm,
--  Atkinson, and Plass, Software Practice and Experience, December 1995,
--  pages 1315-1330.

package Ropes is

	--  Ropes are a data structure that provides behavior equivalent to that
	--  of a string. Ropes are immutable. All operations that return Ropes
	--  create a new Rope and leave the original Rope unchanged.
	--
	--  An uninitialized Rope is initialized to the empty Rope.
	type Rope is private;

	--  Length returns the length of Source, which is the same as the length
	--  of the string represented by the rope.
	function Length (Source : Rope) return Natural;

	--  Element returns the character at position Index in Source. The
	--  first character of a Rope has Index one (1). The last character has
	--  Index Length (Source). If Index > Length (Source), a Constraint_Error
	--  will be raised.
	function Element (Source : Rope; Index : Positive) return Character;

	--  To_Rope returns a Rope containing the contents of the ordinary
	--  string Source. To_Rope makes a copy of Source so it cannot be
	--  modified by later changes to Source.
	function To_Rope (Source : String) return Rope;

	--  To_String returns an ordinary String that contains the contents
	--  of the Rope Source. The returned String will have indices in the
	--  range 1 .. Length (Source).
	function To_String (Source : Rope) return String;

	--  Copy makes a copy of the given Rope.
	function Copy (Source : Rope) return Rope;

	--  & is an overloaded form of the Ada String concatenation operator. Three
	--  versions are provided. For concatenating two Ropes or a Rope and a
	--  String.
	function "&" (Left, Right : Rope) return Rope;
	function "&" (Left : Rope; Right : String) return Rope;
	function "&" (Left : String; Right : Rope) return Rope;


	--  Slice return a new Rope which is corresponds to the characters with
	--  indices Low .. High (inclusive) of the original Rope. The indices of
	--  the Rope that is returned will be 1 .. High - Low + 1. If
	--  Low > Length (Source) + 1, a Constraint_Error will be raised. If
	--  High > Length (Source), then High = Length (Source) is assumed. If Low
	--  is in the valid range and High < Low, a Null_Rope will be returned.
	function Slice (Source : Rope; Low : Positive; High : Natural) return Rope;

	--  A Rope representing a null string.
	Null_Rope : constant Rope;

private

	--  Rope_Pool is provided as a way to track allocation and deallocation of
	--  Ropes. This provides a way to detect memory leaks.
	Rope_Pool : Tracking_Pools.Tracking_Pool;

	--  Ropes are implemented as pointers to Rope_Impls. There can be multiple
	--  kinds of Rope_Impls.
	type Rope_Impl is abstract tagged;

	type Rope_Impl_Access is access all Rope_Impl'Class;
	for Rope_Impl_Access'Storage_Pool use Rope_Pool;

	--  The Rope type is an extension of Ada.Finalization.Controlled.
	--  Ada.Finalization.Controlled provides three procedures (Initialize,
	--  Adjust, and Finalize) that are called at appropriate times when
	--  these actions happen to objects. See the English Ada Book chapter 16
	--  or the Ada LRM sectino 7.6 for more detail.
	type Rope is new Ada.Finalization.Controlled with record
		B : Rope_Impl_Access;
	end record;

	--  Adjust and Finalize for Ropes. These procedures are required to handle
	--  memory management for Rope_Impls. No Initialize is needed since
	--  default initialization (B is set to null) does the right thing.
	overriding procedure Adjust (R : in out Rope);
	overriding procedure Finalize (R : in out Rope);

	Null_Rope : constant Rope := (Ada.Finalization.Controlled with B => null);

	--  Ropes are implemented by having the Rope reference a Rope_Impl. All
	--  the interesting action vis-a-vis ropes is handled by the Rope_Impl.
	--  The operations on Ropes simply invoke the Rope_Impl to do the right
	--  thing.
	--
	--  All Rope_Impls contain a reference count and a length. Length is the
	--  total length of the string represented by this Rope_Impl, including
	--  any Rope_Impls that might be referenced by the given Rope_Impl.
	--
	--  Ref_Count contains a count of all references (via Rope_Impl_Access
	--  types) to this Rope_Impl. When this reference count goes to zero, the
	--  Rope_Impl will be freed. When an additional reference to a Rope_Impl
	--  is created, the Ref_Count must be incremented to account for this
	--  reference. In general, the Ref_Count must be decremented when a
	--  reference is destroyed. However, in most cases in this package,
	--  references are only destroyed by the Dispose operation on Rope_Impls
	--  and the Adjust and Finalize operations on Ropes.
	type Rope_Impl is abstract tagged record
		Ref_Count : Natural := 0;
		Length	: Natural := 0;
	end record;

	--  Dispose is called when the Ref_Count of a Rope_Impl goes to zero.
	--  Dispose is responsible for decrementing the Ref_Counts of any child
	--  Rope_Impls and Freeing any other structures that might be owned by
	--  this Rope_Impl.
	procedure Dispose (R : access Rope_Impl) is abstract;

	--  Length returns the Length of the Rope_Impl. This routine returns
	--  the length value.
	function Length (Source : Rope_Impl) return Natural;
	
	--  Element returns the character at the given Index in this Rope_Impl.
	--  
	--  This Element function is allowed to assume that
	--  1 <= Index <= Length (Source). (The Element function on Ropes
	--  performs this check.)
	function Element (Source : Rope_Impl; Index : Positive) return Character
		is abstract;

	--  To_String copies the characters associated with this Rope_Impl into
	--  the String Target, beginning at Index Start. To_String is allowed to
	--  assume that Target is large enough to hold all of the string
	--  represented by Source.
	procedure To_String (Source : access constant Rope_Impl;
						 Target : in out String;
						 Start  : in Positive) is abstract;

	--  Slice returns a new Rope_Impl which represents the given Slice of
	--  Source. As part of memory management for Rope_Impls, the returned
	--  Rope_Impl will have its Ref_Count incremented to reflect that it has
	--  created a new reference to the slice. The caller of Slice is
	--  responsible for either using that reference by placing the slice in
	--  a Rope or as the child of another Rope_Impl, or decrementing the
	--  Ref_Count if the Slice is to be discarded.
	--
	--  This Slice function is allowed to assume that
	--  1 <= Low <= High <= Length (Source). (The Slice function on Ropes
	--  performs this check.
	function Slice (Source : access Rope_Impl;
					Low : Positive; High : Positive)
	  return Rope_Impl_Access is abstract;

	----------------------------------------------------------------------------
	-- My additions for Part 2, step 1										  --
	----------------------------------------------------------------------------

	-- Two overloaded & functions. I added these.
	function "&" (Left	: access Rope_Impl; 
				  Right : String) 
		return Rope_Impl_Access is abstract;
	function "&" (Left  : String; 
				  Right : access Rope_Impl) 
		return Rope_Impl_Access is abstract;
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	
	--  Impl_Text_Contents provides a String descriptive of the contents of
	--  R. This is called by Impl_Text_Image to create a string describing
	--  the Rope_Impl. The default implementation of this function returns
	--  the null string ("").
	function Impl_Text_Contents (R : access constant Rope_Impl) return String;
	
	--  Note: Primitive Operations on Rope_Impls end here.

	--  Setting this flag to True will cause output describing memory relevant
	--  actions to be produced.
	Memory_Verbose : Boolean := False;

	--  Increment and decrement the Ref_Count of the R. Use these procedures
	--  when this is required, do not increment and decrement Ref_Counts
	--  directly.
	--
	--  Inc_Ref_Count and Dec_Ref_Count should only be called with R /= null.
	--
	--  Dec_Ref_Count will automatically call Dispose if the Ref_Count is
	--  decremented to zero. The caller of Dec_Ref_Count must still check to
	--  see if the count was decremented to zero and Free the Rope_Impl if
	--  it was.
	procedure Inc_Ref_Count (R : access Rope_Impl'Class);
	procedure Dec_Ref_Count (R : access Rope_Impl'Class);

	--  Utility functions which produce a string describing a Rope or
	--  Rope_Impl.
	--
	--  Rope_Text_Image returns a string of the form
	--  "[Rope@<<address>> [<<class>>@<<address>>]]".
	--  Impl_Test_Image returns a string of the form
	--  "[<<class>>@<<address>> <<contents>>]"
	--  where <<class>> is the actual class of the Rope_Impl,
	--		<<address>> is the memory address of the Rope or Rope_Impl,
	--	and <<contents>> is the result of calling Impl_Text_Contents of the
	--			 Rope_Impl.
	--  If Full is False, the contents portion of the Rope_Impl is suppressed.
	function Rope_Text_Image (R : in Rope'Class) return String;
	function Impl_Text_Image (R : access constant Rope_Impl'Class; Full : Boolean := True) return String;

	--  Free the memory used by a Rope_Impl.
	procedure Free is
		new Ada.Unchecked_Deallocation (Rope_Impl'Class, Rope_Impl_Access);

	--  A String_Access type used whenever a String is referenced by a
	--  Rope_Impl. Note that Strings allocated as a String_Access use the Rope_Pool.
	type String_Access is access String;
	for String_Access'Storage_Pool use Rope_Pool;

	--  Free the memory referenced by a String_Access.
	procedure Free is
		new Ada.Unchecked_Deallocation (String, String_Access);

end Ropes;
