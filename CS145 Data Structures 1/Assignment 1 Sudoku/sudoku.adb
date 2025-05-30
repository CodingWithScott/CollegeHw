-- Scott Felch
-- 2 February 2012
-- CSCI 145, Assignment 1
-- This program will solve Sudoku puzzles recursively. It will read input from a text file the user specifies via command line argument, or if they don't specify one via command line
-- it will prompt the user to enter the input text file. Either way, if it can't open the input file then an error will be displayed and the program terminate. The puzzle file will contain 9
-- rows of 9 characters each. Empty squares are represented by spaces. Several example puzzles will be given on the website to work with. If a solution is found, the program will display the 
-- solution. If no solution can be found, then a message will be displayed indicating that. Individual steps do not need to be displayed.

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;

procedure Sudoku is
	-- These are my custom exceptions I'll be using in the program
	Too_Many_Arguments	:	exception;		-- Exception which will be raised if user enters more than 1 command line argument
	Invalid_Data		:	exception;		-- Exception which will be raised if input data file contains data other than spaces or integers 1-9
	Unsolvable		:	exception;		-- Exception which will be raised if a puzzle is determined to be impossible to solve.
	recursion_counter	:	integer := 1;		-- Counter that tracks how many recursive calls have been made before reaching solution
	solved			:	boolean := false;	-- Flag keeping track if puzzle has been solved yet or not, defaults to false until changed by procedure Solve
	
	-- Now I'll declare some custom data types that will be necessary to run this program.
	----------------- Coordinate Pair ----------------
	type coordinate (X_input : integer := 0; Y_input : integer := 0) is record	-- Custom data type to store an X and Y coordinate together
		x	:	integer;
		y	:	integer;
	end record;
	
	procedure Put (input : coordinate) is
	begin
		Put(input.x, width => 1); put(","); put(input.y, width => 1);
	end Put;
	
	----------------- Varying String -----------------
	type Varying_String (Maximum : Positive) is record	-- Custom data type to allow for strings of varying length, to get around Ada's stupid string restrictions.
		Length	:	natural;
		Value	:	String (1..Maximum);
	end record;
		
	procedure Put(input : in Varying_string) is		-- Overloaded Put statement for use with Varying_Strings, otherwise some garbage characters are printed.
	begin
		for I in 1 .. input.length loop
			put(input.value(I));
		end loop;
	end Put; 
	
	function ToString(input : in varying_string) return string is	
	begin							-- Small function to convert from Varying_String to standard string, for procedures/functions expecting strings.
		return input.value(1..input.length);	
	end ToString;

	----------------- Puzzle_Type --------------------
	subtype Number is integer range 0..9;			-- Only numbers 0-9 will be used in my calculations. 0s will be used as placeholders for spaces.
	subtype Valid_Int is Number range 1..9;			-- Only the numbers 1-9 can be used in a Sudoku puzzle, no 0s allowed, so this subtype verifies validity.
	type Puzzle_Type is array(Valid_Int, Valid_Int) of Number;	-- A Puzzle is defined as a 9x9 array of numbers, accepting only single digit integers. 1-9 are used for playing the game, 0 is a placeholder.

	procedure Get (input 	: 	in out Puzzle_type) is 		-- This function will populate a Puzzle from a text file, reading in one character at a time. Spaces will be assigned 0s.
		curr_char	:	character;		-- Current character being analyzed
	begin
		while not (end_of_file) loop			-- Until end of file is reached, loop through box by box and assign values
			for row in Valid_Int'first .. Valid_Int'last loop
				for column in Valid_Int'first .. Valid_Int'last loop
					get(curr_char);
					if curr_char = ' ' then	--If current character being analyzed is a space, assign a 0 to that cell in the Puzzle.
						input(row, column) := 0;
					elsif character'pos(curr_char) >= 48 and character'pos(curr_char) <= 57 then
								-- If current character being analyzed is a valid integer, assign the appropriate number to that cell.
						input(row, column) := character'pos(curr_char) - 48;
					else			-- If anything else appears raise an exception, there's something wrong with the input data.
						raise Invalid_Data;
					end if; 		-- End character analysis If statement
				end loop; 			-- End Column loop
			end loop; 				-- End Row loop
		end loop; 					-- End end_of_file loop
	end Get;
	
	procedure Put (temp 	:	in puzzle_type) is
	begin
		for row in 1 .. 9 loop
			for column in 1 .. 9 loop
				if temp(row, column) = 0 then	-- Output a space for empty spaces in the sudoku puzzle
					put(" ");  
				else				-- Otherwise output the number that's in the box
					put(temp(row, column), width => 2);
				end if;				-- End space checking if statement
			end loop;	-- End column loop
			new_line;
		end loop;		-- End row loop
		new_line;
	end Put; -- End overloaded Put function
	
	Initial_Puzzle		:	Puzzle_Type;		-- My Puzzle I'll be working with throughout the program
	Input			:	file_type;		-- Variable name for the text file I'll be using as input 
	filename		:	Varying_string(100);	-- Varying string used to hold name of the user's input text file, maximum length of 100 characters
	
	----------------- Other procedures --------------------
	procedure SetInputs is					-- Set data input appropriately, depending on number of command line arguments provided. Raise an exception if too many arguments or invalid filename specified.
	begin
		if Argument_Count = 0 then
			put("Please enter the name of the text file you'd like to use as Sudoku input:  ");
			get_line(filename.value, filename.length);
			Open(Input, in_file, ToString(filename));
			put("Now operating on puzzle:  "); put(filename); new_line;		
			Set_Input(Input);
		elsif Argument_Count = 1 then
			filename.length := Argument(1)'length;
			for I in 1 .. Argument(1)'length loop		-- I'd like to move this somewhere to use as a replacement := operator but I don't know how. This will work for now.
				filename.value(I) := Argument(1)(I);
			end loop;
			Open(Input, in_file, ToString(filename));
			Put_Line("Input data file read from command line argument.");
			put("Now operating on puzzle:  "); put(filename); new_line;
			Set_Input(Input);
		else	-- If user has entered more than 1 command line argument they aren't doing it right. Raise error and terminate.
			raise Too_Many_Arguments;
		end if;
	end SetInputs;
	
	-- This function accepts a puzzle, the row number being analyzed, and the character being searched for, and verifies the character being searched for only occurs once in this row.
	-- Returning true indicates a valid row, returning false indicates a character has been repeated.
	function CheckRow(puzzle : in puzzle_type; row : in valid_int; i : in valid_int) return boolean is	
	begin -- Begin CheckRow
		for Column in Valid_Int loop			-- Loop through a single row, reading columns 1 to 9, left to right
			if puzzle(row, column) = i then		-- If any character in the row is the number being searched for, return false
				return false;
			end if;
		end loop; 
		return true;		-- If row has been read through completely and no repeats found, return True to indicate the row is valid
	end CheckRow;
	
	-- CheckColumn is nearly identical to CheckRow, see above comments for explanation of logic
	function CheckColumn(puzzle : in puzzle_type; column : in valid_int; i : in valid_int) return boolean is	
	begin -- Begin CheckColumn
		for Row in Valid_Int loop							-- Loop through a single column, reading rows 1 to 9, top to bottom
			if puzzle(row, column) = i then						-- If any character in the column is the number being searched for, return false
				return false;
			end if;
		end loop; 		-- End loop, row has been read completely
		return true;		-- If column has been read through completely and no repeats found, return True to indicate the column is valid
	end CheckColumn;
	
	-- CheckSquare will check each 3x3 section of the puzzle to verify it contains numbers 1-9, with no repeats, but slightly more complex than previous functions.
	-- This method will use an array of bools to check for characters already seen. 
	function CheckSquare(puzzle : in puzzle_type; row : in valid_int; column : in valid_int) return boolean is
		seen 		:	array (Valid_Int) of boolean := (others => false);	-- Array from 1-9, all start as false. Switched to true as numbers are enrecursion_countered.	
		current_number	:	number;							-- Current number being looked at and checked in the array
		row_lower_bound	:	valid_int;						-- Lower bound for the row of a 3x3 square
		row_upper_bound	:	valid_int;						-- Upper bound for the row of a 3x3 square
		col_lower_bound	:	valid_int;						-- Lower bound for the column of a 3x3 square
		col_upper_bound	:	valid_int;						-- Upper bound for the column of a 3x3 square
		
	begin -- Begin CheckSquare
		-- These two case statements will determine which 3x3 square the current coordinate is in
		case Row is
			when 1 .. 3 => 
				row_lower_bound := 1;
				row_upper_bound := 3;
			when 4 .. 6 =>
				row_lower_bound := 4;
				row_upper_bound := 6;
			when 7 .. 9 =>
				row_lower_bound := 7;
				row_upper_bound := 9;
		end case; -- End Row case
		
		case Column is
			when 1 .. 3 => 
				col_lower_bound := 1;
				col_upper_bound := 3;
			when 4 .. 6 =>
				col_lower_bound := 4;
				col_upper_bound := 6;
			when 7 .. 9 =>
				col_lower_bound := 7;
				col_upper_bound := 9;
		end case; -- End Row case
		
		-- Once upper and lower bounds have been determined for the row and columns, I can do the same type of validation I did in the CheckRow and CheckColumn
		for Row in row_lower_bound .. row_upper_bound loop
			for Column in col_lower_bound .. col_upper_bound loop
				current_number := puzzle(Row, Column);
				if current_number = 0 then						-- If current number is a 0, skip over it, to avoid Constraint Error
					null;
				elsif seen(current_number) = false then
					seen(current_number) := true;
				elsif seen(current_number) = true then					-- If the current number has already been seen, return False to indicate an invalid row
					return false;
				end if;
			end loop; -- End Column loop
		end loop; -- End Row 
		return true; -- If function makes it through all these loops successfully then return True, the square is valid
	end CheckSquare;
			
	function CanFit(puzzle : in puzzle_type; row : in Valid_Int; column : Valid_Int; char : Valid_Int) return boolean is
	begin
		if CheckRow(puzzle, row, char) = true then
			if CheckColumn(puzzle, column, char) = true then
				if CheckSquare(puzzle, row, column) = true then
					return true; -- Return true if all 3 conditions are true
				end if; -- End Square checking
			end if; -- End Column checking
		end if; -- End Row checking
		return false; -- Return False if any of these fail
	end CanFit;
	
	function FindEmpty(puzzle : in puzzle_type) return coordinate is			-- This function will find the location of the first empty square and return it as a Coordinate data type
		temp	:	coordinate;
	begin -- Begin FindEmpty
		for Row in 1 .. 9 loop
			for Column in 1 .. 9 loop
				if puzzle(Row, Column) = 0 then					-- If a cell is found that contains 0, return the X and Y coordinates in Empty_Location
					temp.x := Row;
					temp.y := Column;
					return temp;
				end if;
			end loop; -- End Column loop
		end loop; -- End Row loop
		temp.x := 0;
		temp.y := 0;
		return temp;	-- If no empty cells are found then (0,0) will be returned indicating a full puzzle
	end FindEmpty;
	
	-- Solve procedure accepts the initial puzzle given, and then performs recursive calls on itself to fill the empty squares via trial and error. This is basically
	-- just the algorithm given to us in class by the instructor. I got a lot of help from Isaac Powell too.
	procedure Solve(puzzle : in out puzzle_type)  is
		temp_puzzle	:	puzzle_type;			-- Mutable version of the current puzzle
		empty_location	:	coordinate;			-- First empty location, in coordinate form
		empty_row	:	valid_int;			-- Current row being looked at
		empty_column	:	valid_int;			-- Current column being looked at
	begin -- Begin Solve
		empty_location := FindEmpty(puzzle);
		
		if empty_location.x = 0 and empty_location.y = 0 then	-- If there are no empty spots left, output the puzzle
			Put_Line("AFTER:  ");
			Put(puzzle);
			solved := true;
		
		elsif solved = false then				-- Otherwise determine next empty spot to continue solving
			empty_row := empty_location.x;
			empty_column := empty_location.y;
			for i in 1 .. 9 loop
				if CanFit(puzzle, empty_row, empty_column, i) = true then
					temp_puzzle := puzzle;
					temp_puzzle(empty_row, empty_column) := i;
					solve(temp_puzzle);
					recursion_counter := recursion_counter + 1;	-- Keep track of how many recursive calls there are
				end if; -- End CanFit check
			end loop; -- End checking characters for current coordinate		
		end if; -- End Solved checker
	end Solve;
		
begin -- Begin Sudoku
	-- First I'll check how many command line arguments have been passed in. It should be one (the input text file name) or none, in which case I'll ask user for input text file name.
	SetInputs;
	Get(Initial_Puzzle);	-- Read in data from input file to populate Puzzle
	Put_line("BEFORE:  ");
	Put(Initial_Puzzle);	-- Output Puzzle to verify it was read in correctly
	
	Solve(Initial_Puzzle);	-- If puzzle is solvable then the Solve procedure will display the output and quit.
	if not solved then	-- Otherwise it'll raise an exception to display an error and then quit.
		raise Unsolvable;
	elsif solved then	-- The puzzle outputting has already been handled in Solve() so I am just outputting the number of recursion calls here
		put("Recursive calls:  "); put(recursion_counter); new_line;
	end if;
			
exception
	when Event : Too_Many_Arguments =>
		Put_Line("Error: You entered too many arguments! You need to have 0-1 command line arguments for the program to work.");
		put_line("GOOD: ./sudoku input.txt");
		put_line("GOOD: ./sudoku");
		put_line("BAD: ./sudoku input.txt BLARGH!dsa ");
	when Name_Error =>	-- If user enters a filename that doesn't exist display an error
		Put("File name """); put(filename); put(""" not found."); new_line;
		Put_line("Program terminating...");
	when Event : Invalid_Data =>	-- If user's input text file contains data other than spaces or integers 1-9 then something isn't right
		Put_line("Error: Your input text file contains invalid data. The program can only work with input files containing spaces and numbers 1-9.");
	when Event : Unsolvable => 	-- If puzzle input is determined to be impossible to solve spit out a nice error and terminate.
		Put_Line("Error: Don't feel bad you couldn't solve it, I couldn't either. This puzzle is impossible!");
		put("Recursive calls:  "); put(recursion_counter); new_line;
end Sudoku;
