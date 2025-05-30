---------------------------------------------------------------- Blanks on the side
			for Row in 1 .. curr_length loop		-- This will go through the cypher_string and put each letter into the array going left to right, top to bottom.
				if Curr_length - Row <= remainder then	-- The first few rows will be regular width, once those are done and I've moved to short rows, decrease the curr_width by 1
					short_row := true;		-- which will allow for the empty space on the far right side.
				else
					short_row := false;
				end if;

				if not short_row then
					for Column in 1 .. curr_width loop
--						put(Row, width => 2); put(", "); put(Column, width => 2); put(" = ");
--						put(cypher_string.value(char_counter)); put("   Character # = "); put(char_counter); new_line;
						if char_counter < (cypher_string.length) then
							Matrix(Row, Column) := cypher_string.value(char_counter); 
							char_counter := char_counter + 1;
						end if;
					end loop;
				elsif short_row	then			-- Once the rows which are 1 square shorter have been reached, only write from columns 1 to 5
					for Column in 1 .. (curr_width - 1) loop
--						put(Row, width => 2); put(", "); put(Column, width => 2); put(" = ");
--						put(cypher_string.value(char_counter)); put("   Character # = "); put(char_counter); new_line;
						if char_counter < (cypher_string.length) then
							Matrix(Row, Column) := cypher_string.value(char_counter); 
							char_counter := char_counter + 1;
						end if;
					end loop;
				end if; -- End Short_row check

------------------------------------------------------------------- Blanks on bottom
--				if not short_row then
					for Column in 1 .. curr_width loop
--						put(Row, width => 2); put(", "); put(Column, width => 2); put(" = ");
--						put(cypher_string.value(char_counter)); put("   Character # = "); put(char_counter); new_line;
						if char_counter < (cypher_string.length) and cypher_string.value(char_counter) /= ' ' then
							Matrix(Row, Column) := cypher_string.value(char_counter); 
							char_counter := char_counter + 1;
						end if;
					end loop;
--				elsif short_row	then			-- Once the rows which are 1 square shorter have been reached, only write from columns 1 to 5
--					for Column in 1 .. (curr_width - 1) loop
--						put(Row, width => 2); put(", "); put(Column, width => 2); put(" = ");
--						put(cypher_string.value(char_counter)); put("   Character # = "); put(char_counter); new_line;
--						if char_counter < (cypher_string.length) and cypher_string.value(char_counter) /= ' ' then
--							Matrix(Row, Column) := cypher_string.value(char_counter); 
--							char_counter := char_counter + 1;
--						end if;
--					end loop;
--				end if; -- End Short_row check
