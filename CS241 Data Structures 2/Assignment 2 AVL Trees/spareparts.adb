    -- Procedure Delete removes X from AVL tree T
    -- Will walk through the tree until it finds the node that needs to be deleted, then perform appropriate actions based on how many children it has
    -- ORIGINALLY: T was both Search_Tree and AVL_Ptr, however I renamed them to be WholeTree and SubTree to be less confusing.
    procedure Delete( X: Element_Type; WholeTree: in out Search_Tree ) is
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
    
		procedure Delete( X : Element_Type; SubTree : in out Avl_Ptr) is
			temp 	: avl_ptr;
			balance : integer;
		begin
			if SubTree = null then		-- If the current element is null then just do nothing
				raise Item_Not_Found;
			end if;
			
			if X < SubTree.Element then		-- If Element I'm looking for is less than current node's element, then go down one level to the left...
				Delete(X, SubTree.left);
			elsif X > SubTree.Element then	-- ... or if ELement is greater than current node, go down a level to the right.
				Delete(X, SubTree.right);
			else			-- If Element matches current node then I've found the one to delete, need to start doing delete work.
--				if (T.left = null) and (T.right = null) then	-- If this is a leaf node then both L and R pointers will be null
--					Dispose(T);							-- Just delete the leaf node and that's it
														-- AFAIK that should just work, I don't see why it won't. I can just comment it out and use the following cases though if it causes problems
				if SubTree.Left = null and SubTree.right /= null then	
					temp := SubTree.Right;							-- Copy non-null node into the temporary node
--					T.Element := temp.Element;					-- Assign value from temp node into current node
					SubTree := temp;						-- Maybe I need to assign whole pointer to T and not just element?
					Dispose(temp);						-- Delete temp node
				elsif SubTree.Left /= null and SubTree.Right = null then	-- Same as above but mirrored
					temp := SubTree.Left;								
					SubTree.Element := temp.Element;					
					Dispose(temp);						
				elsif SubTree.Left /= null and SubTree.Right /= null then	
					temp := Find_Min(SubTree.right);					-- If both L and R are children, then get the smallest node in the right tree and store it in current node
					SubTree.Element := temp.Element;					-- Store element from Temp into current node
					Delete(SubTree.Element, SubTree.Right);					-- 
				end if;
			end if;
			
			-- Update height of current node
--			T.height := Find_max(height(T.left), height(T.right)) + 1;
			-- Check height of current node to see what kind of rotations are necessary
			-- Can be LeftLeft, LeftRight, RightLeft, and RightRight.
--			balance := Height(T.right) - Height(T.left);

			--- This whole block doesn't work, I'm not sure how it's supposed to work yet
			-- Left Left case
--			if ((balance > 1) and (get_balance(T.left) >= 0)) then
--				S_rotate_right(t);
			-- Left Right case
--			elsif ((balance > 1) and (get_balance(T.left) < 0)) then
--				S_rotate_left(T.left);
--				S_rotate_right(T);
			-- Right Right case
--			elsif ((balance < -1) and (get_balance(T.right) <= 0)) then
--				S_rotate_left(T);
--			elsif ((balance < -1) and (get_balance(T.right) > 0)) then
--				S_rotate_right(T.right);
--				S_rotate_left(T);
--			end if ;
		end Delete;	
    begin
--		Put_Line( "Delete is not implemented" );
		Delete(X, WholeTree.root);
    end Delete;
    
    
    
    
			-- Update height of current node to perform checking for rotations
--			Node.height := Max(height(Node.left), height(Node.right)) + 1;
--			Calculate_Ht(node);
			
--			if Check_HT(Node) = false then -- If current node doesn't satisfy AVL requirements after performing deletion then do appropriate rotations to get it in check

			-- Call Recursive_Balance after every delete, no adjustments will be made by the procedure if none are needed
--			Recursive_Balance(parent);
--				balance := get_balance(Node);
													
				-- Possible rotations: LeftLeft, LeftRight, RightLeft, and RightRight.

				-- CASE A: Left Left
				-- Y is Left child of Z and X is left child of Y
					-- requires a single Rotate Right
--				if ((balance > 1) and (get_balance(Node.left) >= 0)) then
--					S_rotate_right(Node);
					
				-- CASE B: Left Right
				-- Y is Left child of Z and X is right child of Y
					--  requires a double Rotate Left
--				elsif ((balance > 1) and (get_balance(Node.left) < 0)) then
--					D_Rotate_Right(Node);
					
				-- CASE C: Right Right
				-- Y is right child of Z and X is right child of Y
					-- requires a single Rotate Left
--				elsif ((balance < -1) and (get_balance(Node.right) <= 0)) then
--					S_rotate_left(Node);
	
				-- CASE D:	Right Left
				-- Y is right child of Z and X is left child of Y
					-- requires a double Rotate Right
--				elsif ((balance < -1) and (get_balance(Node.right) > 0)) then
--					D_Rotate_Left(Node);
--				end if;
				
--			end if ;
