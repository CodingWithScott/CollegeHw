-----------------------------------------------------------------------
--  Tracking_Pools package spec
--
--  Author: Chris Reedy (Chris.Reedy@wwu.edu)
-----------------------------------------------------------------------

with System.Storage_Pools;
private with System.Storage_Elements;
private with Ada.Containers.Vectors;

--  A tracking pool is a storage pool that tracks allocations and the
--  number of bytes allocated. The actual allocation is preformed by
--  the underlying system allocator.

package Tracking_Pools is

    --  This exception is raised is there is an attempt to deallocate something
    --  more than once.
    Deallocation_Error : Exception;

    type Tracking_Pool is new System.Storage_Pools.Root_Storage_Pool with private;
    
    --  Do deferred deallocations that are saved in the tracking pool.
    procedure Do_Deallocations (Pool : in out Tracking_Pool);

    --  Clear_Counts clears the counts in the tracking pool.
    procedure Clear_Counts (Pool : in out Tracking_Pool);

    --  Is_Balanced returns True if the allocation and allocated bytes
    --  are equal to the deallocations and deallocated bytes.
    function Is_Balanced (Pool : Tracking_Pool) return Boolean;

private

    subtype Storage_Count is System.Storage_Elements.Storage_Count;
    use type System.Storage_Elements.Storage_Count;

    subtype Allocation_Count is Long_Integer range 0 .. Long_Integer'Last;

    --  We keep track of deallocations and only actually deallocate when
    --  Clear_Counts is called.
    
    type Alloc_Record is record
        Storage_Address          : System.Address;
        Size_In_Storage_Elements : Storage_Count;
        Alignment                : Storage_Count;
    end record;
    
    package Alloc_Vector is new Ada.Containers.Vectors (Positive, Alloc_Record);
    
    type Tracking_Pool is new System.Storage_Pools.Root_Storage_Pool
    with record
        Allocations           : Allocation_Count := 0;
        Pending_Deallocations : Alloc_Vector.Vector;
        Deallocations         : Allocation_Count := 0;
        Allocated             : Storage_Count := 0;
        Deallocated           : Storage_Count := 0;
    end record;

    --  see System.Storage_Pools
    overriding
    procedure Allocate (Pool                     : in out Tracking_Pool;
                        Storage_Address          : out System.Address;
                        Size_In_Storage_Elements : Storage_Count;
                        Alignment                : Storage_Count);

    overriding
    procedure Deallocate (Pool                     : in out Tracking_Pool;
                          Storage_Address          : System.Address;
                          Size_In_Storage_Elements : Storage_Count;
                          Alignment                : Storage_Count);
                          
    overriding
    function Storage_Size (Pool : Tracking_Pool) return Storage_Count;

    procedure Update_Deallocation (Pool                 : in Tracking_Pool;
                                   Actual_Deallocations : in out Allocation_Count;
                                   Actual_Deallocated   : in out Storage_Count);
                                   
end Tracking_Pools;
