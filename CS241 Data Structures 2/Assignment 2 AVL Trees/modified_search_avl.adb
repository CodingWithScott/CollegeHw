-- Implementation of Search_Avl

with Unchecked_Deallocation;
package body Search_Avl is

    procedure Dispose is new Unchecked_Deallocation( Avl_Node, Avl_Ptr );

    procedure Initialize( T: in out Search_Tree ) is
    begin
        null;
    end Initialize;

    procedure Finalize( T: in out Search_Tree ) is
    begin
        Make_Empty( T );
    end Finalize;

    -- Declarations for internal routines
    function ">"( Left, Right: Element_Type ) return Boolean;
    function Max( A, B: Integer ) return Integer;
    function Height( P: Avl_Ptr ) return Integer;
    procedure S_Rotate_Left( K2: in out Avl_Ptr );
    procedure S_Rotate_Right( K2: in out Avl_Ptr );
    procedure D_Rotate_Left( K3: in out Avl_Ptr );
    procedure D_Rotate_Right( K3: in out Avl_Ptr );

    -- THE VISIBLE ROUTINES

    -- Procedure Delete removes X from AVL tree T
    -- Will walk through the tree until it finds the node that needs to be deleted, then perform appropriate actions based on how many children it has
    -- ORIGINALLY: T was both Search_Tree and AVL_Ptr, however I renamed them to be WholeTree and SubTree to be less confusing.
	procedure Delete( X: Element_Type; T: in out Search_Tree ) is
		-- This is just the Find_Min function from down below except I took out the inner part so I could call it it with just a partial tree, instead of a Search_Tree type		
		function Find_Min( T: Avl_Ptr ) return Avl_Ptr is
        begin
            if T = null then
                raise Item_Not_Found;
            elsif T.Left = null then
                return T;
            else
                return Find_Min( T.Left );
            end if;
        end Find_Min;
    
		procedure Delete( X : Element_Type; T : in out Avl_Ptr) is
			temp 	: avl_ptr;
			balance : integer;
		begin
			if T = null then		-- If the current element is null then just do nothing
				raise Item_Not_Found;
			end if;
			
			if X < T.Element then		-- If Element I'm looking for is less than current node's element, then go down one level to the left...
				Delete(X, T.left);
			elsif X > T.Element then	-- ... or if ELement is greater than current node, go down a level to the right.
				Delete(X, T.right);
			else			-- If Element matches current node then I've found the one to delete, need to start doing delete work.
--				if (T.left = null) and (T.right = null) then	-- If this is a leaf node then both L and R pointers will be null
--					Dispose(T);							-- Just delete the leaf node and that's it
														-- AFAIK that should just work, I don't see why it won't. I can just comment it out and use the following cases though if it causes problems
				if T.Left = null then	
					temp := T.Right;							-- Copy non-null node into the temporary node
--					T.Element := temp.Element;					-- Assign value from temp node into current node
					T := temp;						-- Maybe I need to assign whole pointer to T and not just element?
					Dispose(temp);						-- Delete temp node
				elsif T.Right = null then	-- Same as above but mirrored
					temp := T.Left;								
					T.Element := temp.Element;					
					Dispose(temp);						
				elsif T.Left /= null and T.Right /= null then	
					temp := Find_Min(T.right);					-- If both L and R are children, then get the smallest node in the right tree and store it in current node
					T.Element := temp.Element;					-- Store element from Temp into current node
					Delete(T.Element, T.Right);					-- 
				end if;
			end if;
			
			if Check_HT(T) = false then -- If current node doesn't satisfy AVL requirements after performing deletion then do appropriate rotations to get it in check
			
			-- Update height of current node
			T.height := Find_max(height(T.left), height(T.right)) + 1;
			-- Check height of current node to see what kind of rotations are necessary
			-- Can be LeftLeft, LeftRight, RightLeft, and RightRight.
--			balance := Height(T.right) - Height(T.left);

			--- This whole block doesn't work, I'm not sure how it's supposed to work yet
			-- Left Left case
			if ((balance > 1) and (get_balance(T.left) >= 0)) then
				S_rotate_right(t);
			-- Left Right case
			elsif ((balance > 1) and (get_balance(T.left) < 0)) then
				S_rotate_left(T.left);
				S_rotate_right(T);
			-- Right Right case
			elsif ((balance < -1) and (get_balance(T.right) <= 0)) then
				S_rotate_left(T);
			elsif ((balance < -1) and (get_balance(T.right) > 0)) then
				S_rotate_right(T.right);
				S_rotate_left(T);
			end if ;
		end Delete;	
    begin
		Delete(X, T.root);
    end Delete;

    -- Return Avl_Ptr of item X in AVL tree T
    -- Calls hidden recursive routine
    -- Raises Item_Not_Found if necessary
    -- Same as binary search tree implementation
    function Find( X: Element_Type; T: Search_Tree ) return Avl_Ptr is
        function Find( X: Element_Type; T: Avl_Ptr ) return Avl_Ptr is
        begin
            if T = null then
                raise Item_Not_Found;
            elsif X < T.Element then
                return Find( X, T.Left );
            elsif X > T.Element then
                return Find( X, T.Right );
            else
                return T;
            end if;
        end Find;
    begin
        return Find( X, T.Root );
    end Find;
    
    -- Return Avl_Ptr of maximum item in AVL tree T
    -- Raise Item_Not_Found if T is empty
    -- Same as binary search tree implementation
    function Find_Max( T: Search_Tree ) return Avl_Ptr is
        Curr_Node : Avl_Ptr := T.Root;
    begin
        if Curr_Node /= null then
            while Curr_Node.Right /= null loop
                Curr_Node := Curr_Node.Right;
            end loop;

            return Curr_Node;
        end if;

        raise Item_Not_Found;
    end Find_Max;

    -- Return Avl_Ptr of minimum item in AVL tree T
    -- Raise Item_Not_Found if T is empty
    -- Calls hidden recursive routine
    -- Otherwise, implementation is same as for binary search tree
    function Find_Min( T: Search_Tree ) return Avl_Ptr is
        function Find_Min( T: Avl_Ptr ) return Avl_Ptr is
        begin
            if T = null then
                raise Item_Not_Found;
            elsif T.Left = null then
                return T;
            else
                return Find_Min( T.Left );
            end if;
        end Find_Min;
    begin
        return Find_Min( T.Root );
    end Find_Min;
    
    -- Insert X into tree T
    -- Calls hidden recursive routine
    procedure Insert( X: Element_Type; T: in out Search_Tree ) is
    
        procedure Calculate_Height( T: in out Avl_Ptr ) is
        begin
            T.Height := Max( Height( T.Left ), Height( T.Right ) ) + 1;
        end Calculate_Height;

        procedure Insert( X: Element_Type; T: in out Avl_Ptr ) is
        begin
            if T = null then	-- Create a one node avl tree 
--                T := new Avl_Node'( X, null, null, 0 );
				T := new Avl_Node'( ELEMENT => X, LEFT => null, RIGHT => null, Height => 0 );
            elsif X < T.Element then
                Insert( X, T.Left );
                if Height( T.Left ) - Height( T.Right ) = 2 then
                    if X < T.Left.Element then
                        S_Rotate_Left( T );
                    else
                        D_Rotate_Left( T );
                    end if;
                else
                    Calculate_Height( T );
                end if;
            elsif X > T.Element then
                Insert( X, T.Right );
                if Height( T.Left ) - Height( T.Right ) = -2 then
                    if X > T.Right.Element then
                        S_Rotate_Right( T );
                    else
                        D_Rotate_Right( T );
                    end if;
                else
                    Calculate_Height( T );
                end if;
            -- Else X is in the avl already; do nothing 
            end if;
        end Insert;
    begin
        Insert( X, T.Root );
    end Insert;

    -- Make AVL tree T empty, and dispose all nodes
    -- Implementation is identical to binary search tree
    procedure Make_Empty( T: in out Search_Tree ) is
        procedure Make_Empty( T: in out Avl_Ptr ) is
        begin
           if T /= null then
               Make_Empty( T.Left );
               Make_Empty( T.Right );
               Dispose( T );
           end if;
        end Make_Empty;
    begin
        Make_Empty( T.Root );
    end Make_Empty;

    -- Print the AVL tree T in sorted order
    -- Same as binary search tree routine
    procedure Print_Tree( T: Search_Tree ) is
        procedure Print_Tree( T: Avl_Ptr ) is
        begin
            if T /= null then
                Print_Tree( T.Left );
                Put( T.Element ); New_Line;
                Print_Tree( T.Right );
            end if;
        end Print_Tree;
    begin
        Print_Tree( T.Root );
    end;

    -- Return item in node given by Avl_Ptr P
    -- Raise Item_Not_Found if P is null
    -- Same implementation as in binary search tree
    function Retrieve( P: Avl_Ptr ) return Element_Type is
    begin
        if P = null then
            raise Item_Not_Found;
        else
            return P.Element;
        end if;
    end Retrieve;

    -- Return true if heights recorded in the nodes of T
    -- satisfy the AVL tree structure property
    -- Calls hidden recursive routine
    function Check_Ht( T: Search_Tree ) return Boolean is
        function Check_Ht( T: Avl_Ptr ) return Boolean is
            Left_Ht, Right_Ht : Integer;
        begin
            if T = null then
                return True;
            end if;
    
            if Check_Ht( T.Left ) and then Check_Ht( T.Right ) then
                if T.Left = null and T.Right = null then
                    return T.Height = 0;
                elsif T.Left = null then
                    return T.Height = T.Right.Height + 1;
                elsif T.Right = null then
                    return T.Height = T.Left.Height + 1;
                else
                    return T.Height = Max( T.Left.Height, T.Right.Height ) + 1;
                end if;
            else
                return False;
            end if;
        end Check_Ht;
    begin
        return Check_Ht( T.Root );
    end Check_Ht;
    
    -- Return integer value of the balance of a node
    function get_balance(T : avl_ptr) return integer is
    begin
    	return (Height(T.right) - Height(T.left));
	end get_balance;
    -- INTERNAL ROUTINES

    -- ">" to make tree code look nicer
    function ">"( Left, Right: Element_Type ) return Boolean is
    begin
        return Right < Left;
    end ">";

    -- Return the height of the tree rooted at node P
    -- Empty trees have height of -1, by definition
    function Height( P: Avl_Ptr ) return Integer is
    begin
        if P = null then
            return -1;
        else
            return P.Height;
        end if;
    end Height;

    -- Max function returns the larger of A and B
    -- It is used for updating heights during rotations
    function Max( A, B: Integer ) return Integer is
    begin
        if B < A then
            return A;
        else
            return B;
        end if;
    end Max;

    -- This procedure can be called only if K2 has a left child
    -- Perform a rotate between a K2 and its left child
    -- Update heights
    -- Then assign the new root to K2
    procedure S_Rotate_Left( K2: in out Avl_Ptr ) is
        K1 : Avl_Ptr := K2.Left;
    begin
        K2.Left := K1.Right;
        K1.Right := K2;

        K2.Height := Max( Height( K2.Left ), Height( K2.Right ) ) + 1;
        K1.Height := Max( Height( K1.Left ), K2.Height ) + 1;

        K2 := K1;                   -- Assign new root
    end S_Rotate_Left;

    -- Mirror image symmetry for S_Rotate_Left
    procedure S_Rotate_Right( K2: in out Avl_Ptr ) is
        K1 : Avl_Ptr;
    begin
        K1 := K2.Right;
        K2.Right := K1.Left;
        K1.Left := K2;

        K2.Height := Max( Height( K2.Right ), Height( K2.Left ) ) + 1;
        K1.Height := Max( Height( K1.Right ), K2.Height ) + 1;

        K2 := K1;                   -- Assign new root
    end S_Rotate_Right;

    -- This procedure can only be called if K3 has a left child 
    -- and K3's left child has a right child
    -- Do the left-right double rotation and update heights
    procedure D_Rotate_Left( K3: in out Avl_Ptr ) is
    begin
        S_Rotate_Right( K3.Left );  -- Rotate between k1 and k2 
        S_Rotate_Left ( K3 );	    -- Rotate between k3 and k2 
    end D_Rotate_Left;

    -- Mirror image symmetry of D_Rotate_Left
    procedure D_Rotate_Right( K3: in out Avl_Ptr ) is
    begin
        S_Rotate_Left( K3.Right );  -- Rotate between k1 and k2 
        S_Rotate_Right ( K3 );      -- Rotate between k3 and k2 
    end D_Rotate_Right;

end Search_Avl;
