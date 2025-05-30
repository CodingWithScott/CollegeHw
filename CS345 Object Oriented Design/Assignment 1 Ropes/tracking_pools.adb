-----------------------------------------------------------------------
--  Tracking_Pools package body
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

with System.Pool_Global;
with Ada.Containers;
-- with Ada.Text_IO;

package body Tracking_Pools is

    use Alloc_Vector;
    
    Global_Pool : System.Pool_Global.Unbounded_No_Reclaim_Pool
        renames System.Pool_Global.Global_Pool_Object;

    -- procedure Action_Message (Prefix  : String;
                              -- Address : System.Address;
                              -- Size    : Storage_Count) is
        -- use System.Storage_Elements;
        -- use Ada.Text_IO;
        -- Address_Str : constant String := Integer_Address'Image (To_Integer (Address));
        -- Size_Str : constant String := Storage_Count'Image (Size);
    -- begin
        -- Put (Prefix);
        -- Put (": ");
        -- Put (Address_Str);
        -- Put (" (");
        -- Put (Size_Str);
        -- Put_Line (")");
    -- end Action_Message;

    overriding
    procedure Allocate (Pool                     : in out Tracking_Pool;
                        Storage_Address          : out System.Address;
                        Size_In_Storage_Elements : Storage_Count;
                        Alignment                : Storage_Count) is
    begin
        Pool.Allocations := Pool.Allocations + 1;
        Pool.Allocated := Pool.Allocated + Size_In_Storage_Elements;
        Global_Pool.Allocate (Storage_Address, Size_In_Storage_Elements, Alignment);
        --  Action_Message ("Allocate", Storage_Address, Size_In_Storage_Elements);
    end Allocate;

    use type Ada.Containers.Count_Type;
    Initial_Capacity : constant Ada.Containers.Count_Type := 100;    
    
    overriding
    procedure Deallocate (Pool                     : in out Tracking_Pool;
                          Storage_Address          : System.Address;
                          Size_In_Storage_Elements : Storage_Count;
                          Alignment                : Storage_Count) is
                          
        E : constant Alloc_Record :=
            Alloc_Record'(Storage_Address, Size_In_Storage_Elements, Alignment);
    begin
        --  Make an initial reservation if necessary.
        if Pool.Pending_Deallocations.Capacity = 0 then
            Pool.Pending_Deallocations.Reserve_Capacity (Initial_Capacity);
        --  Double the capacity of Pending_Deallocations if it won't hold this deallocation.
        elsif Pool.Pending_Deallocations.Capacity = Pool.Pending_Deallocations.Length then
            Pool.Pending_Deallocations.Reserve_Capacity (2 * Pool.Pending_Deallocations.Length);
        end if;
        
        --  Check to see if this has already been deallocated. If it has, raise an 
        --  exception.
        if Has_Element (Pool.Pending_Deallocations.Find (E)) then
            --  Oops!!
            declare
                use System.Storage_Elements;
                Address_String : constant String :=
                    Integer_Address'Image(To_Integer(Storage_Address));
            begin
                raise Deallocation_Error
                    with "Repeated deallocation of" & Address_String;
            end;
        else
            --  Action_Message ("Queue Deallocate", Storage_Address, Size_In_Storage_Elements);
            Pool.Pending_Deallocations.Append (E);
        end if;
    end Deallocate;
    
    --  Do deferred deallocations that are saved in the tracking pool.
    procedure Do_Deallocations (Pool : in out Tracking_Pool) is
        C : Alloc_Vector.Cursor;
        E : Alloc_Record;
    begin
        C := Pool.Pending_Deallocations.First;
        while Has_Element (C) loop
            E := Element (C);
            Pool.Deallocations := Pool.Deallocations + 1;
            Pool.Deallocated := Pool.Deallocated + E.Size_In_Storage_Elements;
            Global_Pool.Deallocate (E.Storage_Address, E.Size_In_Storage_Elements, E.Alignment);
            --  Action_Message ("Deallocate", E.Storage_Address, E.Size_In_Storage_Elements);
            Next (C);
        end loop;
        Pool.Pending_Deallocations.Clear;
    end Do_Deallocations;

    overriding
    function Storage_Size (Pool : Tracking_Pool) return Storage_Count is
        pragma Warnings (Off, Pool);
    begin
        return Global_Pool.Storage_Size;
    end Storage_Size;

    procedure Clear_Counts (Pool : in out Tracking_Pool) is
    begin
        Do_Deallocations (Pool);
        Pool.Allocations := 0;
        Pool.Deallocations := 0;
        Pool.Allocated := 0;
        Pool.Deallocated := 0;
    end Clear_Counts;
    
    procedure Update_Deallocation (Pool                 : in Tracking_Pool;
                                   Actual_Deallocations : in out Allocation_Count;
                                   Actual_Deallocated   : in out Storage_Count) is
        C : Alloc_Vector.Cursor;
        E : Alloc_Record;
    begin
        C := Pool.Pending_Deallocations.First;
        while Has_Element (C) loop
            E := Element (C);
            Actual_Deallocations := Actual_Deallocations + 1;
            Actual_Deallocated := Actual_Deallocated + E.Size_In_Storage_Elements;
            Next (C);
        end loop;
    end Update_Deallocation;

    function Is_Balanced (Pool : Tracking_Pool) return Boolean is
        Actual_Deallocations : Allocation_Count := Pool.Deallocations;
        Actual_Deallocated : Storage_Count := Pool.Deallocated;
    begin
        Update_Deallocation (Pool, Actual_Deallocations, Actual_Deallocated);
        return Pool.Allocations = Actual_Deallocations and Pool.Allocated = Actual_Deallocated;
    end Is_Balanced;

end Tracking_Pools;
