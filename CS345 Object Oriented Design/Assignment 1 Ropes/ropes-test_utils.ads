-----------------------------------------------------------------------
--  Ropes.Test_Utils package spec
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

package Ropes.Test_Utils is

    --  Set_Memory_Verbose (True) will cause a trace of memory relevant actions
    --  to be produced. This is available for internal debugging of the Rope
    --  operations.
    procedure Set_Memory_Verbose (Verbose : Boolean);
    
    ---------------------------------------------------------------------------
    --  Functions for internal testing that expose the structure of Rope_Impls.
    ---------------------------------------------------------------------------
    
    --  Get the maximum size for a String in a Small_String_Impl
    function Get_Max_Small_String return Natural;
    
    --  Test whether the Rope_Impl referenced by a Rope is null.
    function Is_Null (Source : Rope) return Boolean;
    
    --  Test whether the Rope_Impl reference by a Rope is a String_Impl.
    function Is_String_Impl (Source : Rope) return Boolean;
    
    --  Test whether the Rope_Impl reference by a Rope is a Large_String_Impl.
    function Is_Large_String_Impl (Source : Rope) return Boolean;
    
    --  Test whether the Rope_Impl reference by a Rope is a Small_String_Impl.
    function Is_Small_String_Impl (Source : Rope) return Boolean;
    
    --  Test whether the Rope_Impl reference by a Rope is a Concat_Impl.
    function Is_Concat_Impl (Source : Rope) return Boolean;
    
    --  Test whether the Rope_Impls reference by two Ropes are the same.
    function Is_Same_Impl (Left, Right : Rope) return Boolean;
    
    --  Get the left child of a Concat_Impl. Returns a Null Rope if this is
    --  not a Concat_Impl.
    function Get_Left_Child (Source : Rope) return Rope;
    
    --  Get the right child of a Concat_Impl. Returns a Null Rope if this is
    --  not a Concat_Impl.
    function Get_Right_Child (Source : Rope) return Rope;
    
    ---------------------------------------------------------------------------
    --  Functions for manipulating the Rope_Pool.
    ---------------------------------------------------------------------------

    procedure Rope_Pool_Clear_Counts;
    
    function Rope_Pool_Is_Balanced return Boolean;
    
    function Rope_Pool_Allocation_Message return String;

end Ropes.Test_Utils;