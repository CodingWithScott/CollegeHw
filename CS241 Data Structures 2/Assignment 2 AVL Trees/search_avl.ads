-- Generic Package Specification for Search_AVL
--     Maintains AVL trees
-- Requires:
--     Instantiated with any private type and
--     a "<" function for that type and
--     a Put procedure for that type
-- Types defined:
--     Avl_Ptr             private type
--     Search_Tree         limited private type
-- Exceptions defined:
--     Item_Not_Found      raised when searches or deletions fail
-- Operations defined:
--     (* throws Item_Not_Found)
--     Initialize and Finalize are defined for Search_Tree
--     Delete *            removes item from search tree
--     Find  *             returns Tree_Ptr of item in search tree
--     Find_Max *          returns Tree_Ptr of maximum item in search tree
--     Find_Min *          returns Tree_Ptr of minimum item in search tree
--     Insert              insert item into search tree
--     Make_Empty          make a search tree empty
--     Print_Tree          print tree in sorted order
--     Retrieve *          returns item in Tree_Ptr passed as parameter

with Ada.Finalization;
with Text_IO; use Text_IO;

generic
    type Element_Type is private;
    with function "<" ( Left, Right: Element_Type ) return Boolean;
    with procedure Put( Element: Element_Type );
package Search_Avl is
    type Avl_Ptr is private;
    type Search_Tree is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( T: in out Search_Tree );
    procedure Finalize( T: in out Search_Tree );

    procedure Delete( X: Element_Type; Tree : in out Search_Tree );
    function  Find( X: Element_Type; T: Search_Tree ) return Avl_Ptr;
    function  Find_Max( T: Search_Tree ) return Avl_Ptr;
    function  Find_Min( T: Search_Tree ) return Avl_Ptr;
    procedure Insert( X: Element_Type; T: in out Search_Tree );
    procedure Make_Empty( T: in out Search_Tree );
    procedure Print_Tree( T: Search_Tree );
    function  Retrieve( P: Avl_Ptr ) return Element_Type;

    -- Used for debugging; returns true if T is AVL
    function Check_Ht( T: Search_Tree ) return Boolean;

    function get_balance(T : avl_ptr) return integer;

    Item_Not_Found : exception;

private
    type Avl_Node;
    type Avl_Ptr is access Avl_Node;

    type Search_Tree is new Ada.Finalization.Limited_Controlled with
      record
        Root : Avl_Ptr;
      end record;

    type Avl_Node is
      record
        Element : Element_Type;
        Left    : Avl_Ptr;
        Right   : Avl_Ptr;
        Height  : Natural;
      end record;
      
end Search_Avl;
