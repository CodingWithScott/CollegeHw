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
    -- Got a lot of algorithm help from:   http://www.geeksforgeeks.org/archives/18009
    -- TO DO: I don't know if I handled keeping track of parent nodes correctly, I don't think I did, but I don't have any way of testing that right now since the program doesn't compile
    
	procedure Delete( X: Element_Type; Tree : in out Search_Tree ) is
		-- This is just the Find_Min function from down below except I took out the inner part so I could call it it with just a partial tree, instead of a full Search_Tree type		
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

		-- Find_Max function stripped down, same as above
        function Find_Max( T: Avl_Ptr ) return Avl_Ptr is
	        Curr_Node : Avl_Ptr := T;
		begin
		    if Curr_Node /= null then
		        while Curr_Node.Right /= null loop
		            Curr_Node := Curr_Node.Right;
		        end loop;

		        return Curr_Node;
		    end if;

		    raise Item_Not_Found;
		end Find_Max;
		
		-- Stole this procedure from the Insert procedure		
        procedure Calculate_Height( T: in out Avl_Ptr ) is
        begin
            T.Height := Max( Height( T.Left ), Height( T.Right ) ) + 1;
        end Calculate_Height;

		
		-- Check_Ht function stripped down to accept an Avl_Ptr instead of a full Search_Tree
        function Check_Ht( T: Avl_Ptr ) return Boolean is
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
        
        -- This function will walk through the entire tree starting at the root looking for a certain element, and then return the parent node of that root
        function Find_Parent (X : element_type) return Avl_Ptr is
        	parent	:	avl_ptr;
        	current	:	avl_ptr;
        begin
        	parent	:= Tree.Root;
        	current := Tree.Root;
        	
        	-- Sets parent to current node, and then moves down tree as necessary looking for next node, parent always indicates node current was previously. When current finds the element,
        	-- parent is not changed and should hold the parent of the current node.
        	while current.element /= X loop
        		if current.element < X then
        			parent := current;
        			current := current.right;
    			elsif current.element > X then
    				parent := current;
    				current := current.left;
        		end if;
    		end loop;
        	return parent;
    	end Find_Parent;
    	
    	procedure Recursive_Balance (Node : in out Avl_Ptr) is 
			balance : integer;
			parent : avl_ptr;
    	begin

			if node.left /= null then
	    		Calculate_Height(Node.Left); 
    		end if;
			if node.right /= null then
	    		Calculate_Height(Node.Right);
    		end if;
    		
			balance := Height(Node.left) - Height(Node.right);
    		if Balance < -1 then
				-- CASE A: Left Left
				-- Y is Left child of Z and X is left child of Y
					-- requires a single Rotate Right
				if (get_balance(Node.left) >= 0) then
					S_rotate_right(Node);
					
				-- CASE B: Left Right
				-- Y is Left child of Z and X is right child of Y
					--  requires a double Rotate Left					
				elsif (get_balance(Node.left) < 0) then
					D_Rotate_Right(Node);
				end if;
				
			elsif Balance > 1 then
				-- CASE C: Right Right
				-- Y is right child of Z and X is right child of Y
					-- requires a single Rotate Left
				if (get_balance(Node.right) <= 0 ) then
					S_rotate_left(Node);

				-- CASE D:	Right Left
				-- Y is right child of Z and X is left child of Y
					-- requires a double Rotate Right
				elsif (get_balance(Node.right) > 0) then
					D_Rotate_Left(Node);
				end if;
			end if;
			
			-- Go up the tree, if the parent of current node is unbalanced then recursively call the balance procedure again on the parent.
			if Find_Parent(node.element) /= node then
				parent := Find_Parent(node.element);
				Recursive_Balance(parent);	
			end if;
		
			
    	end Recursive_Balance;
    
		procedure Delete( X : Element_Type; Node : in out Avl_Ptr) is
			temp 	:	avl_ptr;
			parent	:	avl_ptr;
		begin
			if Node = null then		-- If the current element is null then just do nothing
				raise Item_Not_Found;
			end if;
			
			parent := Find_Parent(node.element);
			
			if X < Node.Element then					-- If Element I'm looking for is less than current node's element, then go down one level to the left...
				Delete(X, Node.left);
			elsif X > Node.Element then					-- ... or if ELement is greater than current node, go down a level to the right.
				Delete(X, Node.right);
			else	-- If Element matches current node then I've found the one to delete, need to start doing delete work.
				if Node.Left = null  then
					temp := Node.Right;					-- Copy non-null node into the temporary node
					Node := temp;						-- Maybe I need to assign whole pointer to T and not just element?
					Dispose(temp);						-- Delete temp node
					Recursive_Balance(parent);			-- Restructure once deletion has occurred
				elsif Node.Right = null then			-- Same as above but mirrored
					temp := Node.Left;								
					Node.Element := temp.Element;					
					Dispose(temp);				
					Recursive_Balance(parent);			-- Restructure once deletion has occurred
				elsif Node.Left /= null and Node.Right /= null then	
					temp := Find_Min(Node.right);		-- If both L and R are children, then get the smallest node in the right tree and store it in current node
					Node.Element := temp.Element;		-- Store element from Temp into current node
					Delete(Node.Element, Node.Right);	-- Call delete and move down to the right
					Recursive_Balance(parent);			-- Restructure once deletion has occurred
				end if;
			end if;

		end Delete;	
    begin
		Delete(X, Tree.root);
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
				T := new Avl_Node'( X, null, null, 0 );
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
    -- I added in formatting to match my Assignment 1 in_order traversal
    procedure Print_Tree( T: Search_Tree ) is
        procedure Print_Tree( T: Avl_Ptr ) is
        begin
            if T /= null then
				put("(");
                Print_Tree( T.Left );
                put(",");
                Put( T.Element ); 
                put(",");
                Print_Tree( T.Right );
				put(")");
			else
				put("null");
            end if;
        end Print_Tree;
    begin
        Print_Tree( T.Root ); new_line;
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
    
    function get_balance(T : avl_ptr) return integer is
		left	:	integer;
		right	:	integer;
    begin
    	-- Check for T being null before trying to access children of T. If T is null then by definition its child has a height of -1.
    	if T = null then
    		left := -1;
		else
			left := T.left.height;
		end if;
		
		if T = null then
			right := -1;
		else 
			right := T.right.height;
		end if;
		
    	return (left - right);
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
