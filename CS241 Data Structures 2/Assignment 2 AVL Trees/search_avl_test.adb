-- Quick test routine for AVL trees

with Search_AVL;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- Main procedure starts here 
procedure Search_AVL_Test is

    procedure Put_Int( X: Integer );

    -- Now we instantiate the search tree package 
    package Int_Tree is new Search_AVL( Integer, "<", Put_Int );
    use Int_Tree;

    -- Rest of main continues here

    T : Search_Tree;
    J : Integer;
    P : AVL_Ptr;

    procedure Put_Int( X: Integer ) is
    begin
--        Integer_Text_IO.Put( X );
		Put( X );
    end Put_Int;

begin
    Make_Empty( T );
    J := 0;
    while J < 10 loop
        Insert( J, T );
        J := J + 3;
    end loop;

    J := 8;
    while J > 0 loop
        Insert( J, T );
        J := J - 3;
    end loop;

    Put( "Min: " ); Put( Retrieve( Find_Min( T ) ) ); New_Line;
    Put( "Max: " ); Put( Retrieve( Find_Max( T ) ) ); New_Line;
    for I in 0..10 loop
        begin
            P := Find( I, T );
            Put( I ); Put_Line( " Found." );

            exception
                when Item_Not_Found =>
                    Put( I ); Put_Line( " Not found." );
        end;
    end loop;

    Print_Tree( T );
    Delete( 6, T );
    Print_Tree( T );
end Search_AVL_Test;
