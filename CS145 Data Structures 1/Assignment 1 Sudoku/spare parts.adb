--	if empty_location.x = 0 and empty_location.y = 0 then
--		put_line("This puzzle is full!");
--	else
--		Put("First empty location is at "); 
--		put(empty_location); new_line;
--	end if;

	-- This function will check a row to see if a given digit has been found already. It will return true if the integer has not yet been used in a row, otherwise it returns false.
	-- There's an array of bools, from 1 to 9. Each one starts as false, and will be set to true when that number is encountered in the row. If a number is encountered and has already
	-- been switched to true, then I know the number has been repeated and thus the row is invalid. I got most of the code for this function from Rosetta Code. I was halfway through
	-- writing my own version using 9 bools, then I saw Rosetta did the same thing using an array and I decided to copy that idea. Much simpler and cleaner.
	function CheckRow(puzzle : in puzzle_type; row : in valid_int) return boolean is	
		seen 		:	array (Valid_Int) of boolean := (others => false);	-- Array from 1-9, all start as false. Switched to true as numbers are encountered.
		current_number	:	number;							-- Current number being looked at and checked in the array
	begin -- Begin CheckRow
		for Column in Valid_Int loop							-- Loop through a single row, reading columns 1 to 9, left to right
			current_number := puzzle(Row, Column);
			--put("In CheckRow, current_number = "); put(current_number); new_line;
			if current_number = 0 then						-- If current number is a 0, skip over it, to avoid Constraint Error
				null;
			elsif seen(current_number) = false then					-- If the current number has not been seen before in this row, set the bool to True
				seen(current_number) := true;
			elsif seen(current_number) = true then					-- If the current number has already been seen, return False to indicate an invalid row
				return false;
			end if;		-- End checking logic
		end loop; 		-- End loop, row has been read completely
		return true;		-- If row has been read through completely and no repeats found, return True to indicate the row is valid
	end CheckRow;
	
	--	function CheckAll(puzzle : in puzzle_type) return boolean is
--	begin
--		for Row in Valid_Int loop
--			for Column in Valid_Int loop
--
--				if CheckRow(puzzle, Row) = false then	-- Return false if the Row is determined invalid
--					return false;
--				else -- If CheckRow is true then continue to check Column and Square
--					if CheckColumn(puzzle, Column) = false then
--						return false;
--					else -- If CheckColumn is true then continue to check Square
--						if CheckSquare(puzzle, Row, Column) = false then
--							return false;
--						end if; -- End CheckSquare if statement
--					end if; -- End CheckColumn if statement
--				end if; -- End CheckRow if statement
--			end loop; -- End Column loop
--		end loop; -- End Row loop
--		return true; -- If successfully completed all 3 checks for every Row and Column, return true that the puzzle is valid
--	end CheckAll;
	


	if CheckAll(puzzle) = true then
		put("This puzzle is solved!");
	end if;	
	for Row in Valid_int loop
		if CheckRow(puzzle, Row) = true then
			put("Row "); put(row, width => 2); put(" is valid"); new_line;
		else
			put("Row "); put(row, width => 2); put(" is NOT valid!"); new_line;
		end if;
	end loop;

	for Column in Valid_Int loop
		if CheckColumn(puzzle, Column) = true then
			Put("Column "); put(column, width => 2); put(" is valid"); new_line;
		else 
			Put("Column "); put(column, width => 2); put(" is NOT valid"); new_line;
		end if;
	end loop;
	
	for Row in Valid_Int loop
		for Column in Valid_Int loop
			if CheckSquare(puzzle, Row, Column) then
				put("Square "); put(row, width => 2); put(","); put(column, width => 2); put(" is valid."); new_line;
			end if;
		end loop;
	end loop;



	function Solve(puzzle : in puzzle_type; current : in coordinate; i : in valid_int) return boolean is
		temp_puzzle	:	puzzle_type := puzzle;		-- Mutable version of the current puzzle
		temp_row	:	valid_int := current.x;		-- Current row being looked at
		temp_column	:	valid_int := current.y;		-- Current column being looked at
		empty_location	:	coordinate;			-- First empty location

	begin
		put("counter = "); put(counter); new_line;
		empty_location := FindEmpty(temp_puzzle);
		if empty_location.x = 0 and empty_location.y = 0 then	-- If there are no empty spots left, output the puzzle
			Put_Line("I solved it!");
			Put(puzzle);
		else
			empty_location := Find
		for i in 1 .. 9 loop
			if CanFit(temp_puzzle, temp_row, temp_column, i) = true then
				temp_puzzle(temp_row, temp_column) := i;
				empty_location := FindEmpty(temp_puzzle);
				put(temp_puzzle);
				counter := counter + 1;
				if Solve(temp_puzzle, empty_location, i) = true then
					Put_Line("Hooray the puzzle is solved!");
					return true;
				end if;
			end if; -- End CanFit check
		end loop; -- End checking characters for current coordinate
		return false; -- If puzzle can't be solved return false, go back up a level
	end Solve;
