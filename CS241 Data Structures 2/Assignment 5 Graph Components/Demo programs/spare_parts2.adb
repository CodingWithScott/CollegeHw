			put_line("Begin main print. Note that the numbers match up with the manually printed entries above.");
			for Column in G'Range loop		-- Loop through array
				row_ctr := 1;
				current := G(Column);

				-- Check if current column in array has any nodes before 
				-- attempting to access name within it, to avoid Constraint errors.
				if current /= null then				
						put("G("); put(Column, 0); put(").name"); put(G(Column).name, 2); put("        ");
						put("Current.name = "); put(current.name, 2); 
--						put(Integer'Image (current.name)); put(" ");
						while current.next /= null loop
							row_ctr := row_ctr + 1;
--							put("Row "); put(row_ctr, 2); put(":   ");
							current := current.next;
							put(Integer'Image (current.name)); put(" ");
						end loop;
				end if;
				New_line;
			end loop;
			new_line; new_line; new_line;
			
			
			
			
		--************************************--
		--****         Procedures         ****--
		--************************************--	
		-- Receive a GraphList (either G or GT) and print it out 
		procedure Print(Graph : in Graph_List_Type) is
			current	:	Vert_Ptr;				-- Current node being looked at for traversal
			row_ctr	:	positive := 1;			-- Current row the list
		begin -- Begin Print
			for Column in Graph'Range loop		-- Loop through array
--				put("Column         "); put(Column); new_line;
				row_ctr := 1;
				current := Graph(Column);

				-- Check if current column in array has any nodes before 
				-- attempting to access name within it, to avoid Constraint errors.
				if current /= null then				
						put("G("); put(Column, 0); put(").name"); put(Graph(Column).name, 2); put("        ");
						put("Current.name = "); put(current.name, 2); 
--						put(Integer'Image (current.name)); put(" ");
						while current.next /= null loop
							row_ctr := row_ctr + 1;
--							put("Row "); put(row_ctr, 2); put(":   ");
							current := current.next;
							put(Integer'Image (current.name)); put(" ");
						end loop;
				end if;
				New_line;
			end loop;
			new_line;
		end Print;
		
		
		
		
		
		
			 			Put_line("Manually printing out nodes from graph G:");
				if G(1) /= null then
					put("G(1).name = "); put(G(1).name); put("     ");
				else 
					put_line("G(1) = null");
				end if;

				if G(1).next /= null then
					put("G(1).next.name = "); put(G(1).next.name); new_line;
				else 
					put_line("G(1).next = null");
				end if;
				
				if G(2) /= null then
					put("G(2).name = "); put(G(2).name); new_line;
				else 
					put_line("G(2) = null");
				end if;

				if G(3) /= null then
					put("G(3).name = "); put(G(3).name); put("     ");
				else 
					put_line("G(3) = null");
				end if;

				if G(3).next /= null then
					put("G(3).next.name = "); put(G(3).next.name); new_line;
				else 
					put_line("G(3).next = null");
				end if;

				if G(4) /= null then
					put("G(4).name = "); put(G(4).name); new_line;
				else 
					put_line("G(4) = null");
				end if;

				if G(5) /= null then
					put("G(5).name = "); put(G(5).name); new_line;
				else 
					put_line("G(5) = null");
				end if;
      			
				if G(6) /= null then
					put("G(6).name = "); put(G(6).name); new_line;
				else 
					put_line("G(6) = null");
				end if;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
						if GT(1) /= null then
					put("GT(1).name = "); put(G(1).name); put("     ");
				else 
					put_line("GT(1) = null");
				end if;
				
				if GT(2) /= null then
					put("GT(2).name = "); put(GT(2).name); put("     ");
				else 
					put_line("GT(2) = null");
				end if;
				
				if GT(2).next /= null then
					put("GT(2).next.name = "); put(GT(2).next.name); put("     ");
				else 
					put_line("GT(2).next = null");
				end if;
				
				if GT(3) /= null then
					put("GT(3).name = "); put(G(3).name); put("     ");
				else 
					put_line("GT(3) = null");
				end if;
				
				if GT(4) /= null then
					put("GT(4).name = "); put(G(4).name); put("     ");
				else 
					put_line("GT(4) = null");
				end if;
				
				if GT(4).next /= null then
					put("GT(4).next.name = "); put(GT(4).next.name); put("     ");
				else 
					put_line("GT(4).next = null");
				end if;
				
				if GT(5) /= null then
					put("GT(5).name = "); put(G(5).name); put("     ");
				else 
					put_line("GT(5) = null");
				end if;	
				
				if GT(5).next /= null then
					put("GT(5).next.name = "); put(GT(5).next.name); put("     ");
				else 
					put_line("GT(5).next = null");
				end if;
				
				if GT(6) /= null then
					put("GT(6).name = "); put(G(6).name); put("     ");
				else 
					put_line("GT(6) = null");
				end if;	
				
				if GT(6).next /= null then
					put("GT(6).next.name = "); put(GT(6).next.name); put("     ");
				else 
					put_line("GT(6).next = null");
				end if;
				
