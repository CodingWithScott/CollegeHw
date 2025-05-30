			procedure AddGT(Graph_List : in out Graph_List_Type;		-- Array to add a node to
 						  Column	 : in positive; 		 			-- Column of the array to add to
						  input_name : in positive) is					-- Name/integer of node to be added 
						  
  				new_V_Ptr	: V_Ptr := new (input_name, null) is		-- New pointer to add to array
				parent		: V_Ptr;  			-- Pointer to traverse the linked list within the array,
												-- until finding 2nd to last entry
				current		: V_Ptr;			-- Pointer to scan to the end of the linked list
			begin
				-- Set Parent and Current to head of column, navigate through list to get Current pointing to last
				-- element, Parent pointing to second to last element.
				parent := Graph_List(Column);
				current := Graph_List(Column);
				while current /= null loop
					if current /= null then
						parent := current;
						current := current.next;
					end if;
				end loop;
			
			end AddGT;

