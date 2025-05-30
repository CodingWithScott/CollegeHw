-- Scott Felch
-- 24 January 2012
-- CSCI 145, Lab 2
-- This program will simulate a Towers of Hanoi game, accepting user input via command line arguments for minimum number of discs, maximum number of discs, and
-- the character 'V' (for 'verbose') flagging whether or not the user wants a list of all the disc movements. All the arguments are optional, if no min/max number of discs
-- are specified the program will use 3 discs, and if 'V' is not flagged then the number of disc movements will be reported, but not the individual disc movements. If only 1 
-- integer is specified, that is the number of discs to be used. If 2 integers are specified, the program will solve the puzzle for each number of towers in the range. For example,
-- if 3 and 5 are specified, the program will solve for 

-- Feb 1 closing notes: framework is written and finalized, seems to be optimized and bulletproof as far as I can tell. I trimmed down almost 100 lines of code and maintained same functionality.
-- Still to do: figure out how the fuck to get the recursive algorithm to work. Dr Awad did provide a recursive solution in the Recursion class lecture notes, but I have not the slightest idea how to implement it.

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;

procedure towers is
	Too_Many_Arguments	:	exception;		-- Custom exception which will be raised if user enters more than 3 command line arguments
	Invalid_Mode		:	exception;		-- Custom exception which will be raised if user enters something other than 'v' or 'V' as the mode tag
	verbose			:	boolean := false;	-- Flag to determine whether program is set to "verbose" mode or not, ie, displaying every single move (verbose) instead of just number of moves (non-verbose)
	min			:	natural;		-- Minimum number of discs to solve for, if user specifies a range
	max			:	natural;		-- Maximum number of discs to solve for, if user specifies a range
	string1			:	string(1..1024) := (others => ' ');	-- Variable for holding the first argument passed in from the command line
	string1_length		:	natural := 0;		-- Length of string1, in characters. Will use later when converting command line argument from string to integer
	string2			:	string(1..1024) := (others => ' ');	-- Variable for holding the second argument passed in from the command line
	string2_length		:	natural := 0;		-- Length of string2, in characters. Will use later when converting command line argument from string to integer
	string3			:	string(1..1024) := (others => ' ');	-- Variable for holding the third argument passed in from the command line
	string3_length		:	natural := 0;		-- Length of string3, in characters. Will use later when converting command line argument from string to integer
	num_moves		:	natural := 0;		-- Counter for number of moves performed
	
	procedure Initialize is	-- This procedure determines how many command line arguments the user has provided, and configures settings accordingly
	begin
		-- First I'll go through the Arguments and set my program's settings accordingly.
		if Argument_Count > 3 then		-- Raise an exception if user provided more than a usable number of arguments
			raise Too_Many_Arguments;
		elsif Argument_Count = 0 then		-- User provided no arguments, run simulation with all default values
			min := 3;
			max := 3;
		end if; -- End Argument_Count = 0 settings

		if Argument_Count >= 1 then	-- User provided 1 or more arguments, start assigning settings based on how many arguments were provided
			for count in 1 .. Argument(1)'length loop	-- Read in Argument(1) into string1 char by char, to keep track of length
				if Argument(1)(count) /= ' ' then	
					string1(count) := Argument(1)(count);
					string1_length := string1_length + 1;
				elsif Argument(1)(count) = ' ' then
					exit;
				end if; -- End space checker
			end loop; -- End Argument(1) being read into string1
			
			loop	-- User may potentially enter something invalid as a command line argument instead of a usable integer, so I'm going to wrap my Get command in a loop and have a local exception handler
				begin -- Begin mini-exception handler block
					Get(string1, min, string1_length);	-- Read up until string1_length characters from string1 (as a string) and store as the min number of discs (as an integer)
										-- if it's usable, otherwise display error and use 3 as default value.
					Get(string1, max, string1_length);	-- Set string1 as the maximum number of discs as well. If the user provided a min AND a max, the max will be overwitten in the next step.
					exit;					-- If a usable value is entered for number of discs then exit this loop and continue with program.
				exception
					when Data_Error =>
					Put_line("Well, the user entered something other than a usable integer, so I'm just gonna go ahead and set the min value to 3 and pretend that didn't happen. Okie dokie?  ");	
					min := 3;
					max := 3;
					exit;
				end; -- End mini-exception handler block
			end loop; -- End mini-exception handler loop
		end if; -- End Argument_Count >= 1 settings			
			
		if Argument_Count >= 2 then	-- If user has specified 2 or more arguments, use first two as a range of number of discs to run the simulation with. 
						-- Ie, 3 and 6 will run the simulation for 3, 4, 5, and 6 discs.
			for count in 1 .. Argument(2)'length loop	-- Read in Argument(2) into string2 char by char, to keep track of length
				if Argument(2)(count) /= ' ' then	-- If next character being read in is a space then the end of the word has been reached, can quit reading in.
					string2(count) := Argument(2)(count);
					string2_length := string2_length + 1;
				elsif Argument(2)(count) = ' ' then
					exit;
				end if; -- End space checker
			end loop; -- End Argument(2) being read into string2
			
			loop	-- Begin loop for mini-exception handler for Argument 2
				begin -- Begin mini-exception handler for Argument 2
					Get(string2, max, string2_length);	-- Read up until string2_length characters from string2 (as a string) and store as the max number of discs (as an integer)
										-- if it's usable, otherwise display error and use 3 as default value.
					exit;					-- If Get command executes successfully, exit loop and continue program
				exception
					when Data_Error => 			-- If Get command fails, display error and use default value for Max
					Put_line("Well, the user entered something other than a usable integer, so I'm just gonna go ahead and set the max value to 3. Okie dokie?  ");	
					max := 3;
					exit;
				end; -- End mini-exception handler block for Argument 1
			end loop; -- End mini-exception handler block for Argument 1
			
			if min > max then	-- If the minimum value entered is greater than the maximum value, then set them both to min value and solve only once, using the min value
				max := min;
			end if;
		end if; -- End Argument_Count >= 2 settings
		
		if Argument_Count = 3 then	-- If user has specified 3 arguments, the 3rd argument will be used as a flag to indicate the user wants Verbose mode.
			for count in 1 .. Argument(3)'length loop	-- Read in Argument(3) into string3 char by char, to keep track of length
				if Argument(3)(count) /= ' ' then	-- If next character being read in is a space then the end of the word has been reached, can quit reading in
					string3(count) := Argument(3)(count);
					string3_length := string3_length + 1;
				elsif Argument(3)(count) = ' ' then
					exit;
				end if; -- End space checker
			end loop; -- End Argument(3) being read into string3

			if Argument(3) = "v" or Argument(3) = "V" then
				verbose := true;
			else
				--Put_Line("The user entered something other than the appropriate Verbose flag ('V' or 'v'), so I'm going to assume you don't really want Verbose mode.");
				raise Invalid_Mode;
			end if; -- End Verbose flag checker
		end if; -- End Argument_Count = 3 settings
		
		-- Then I'll output what the program just did so the user knows what's going on. 		
		if Argument_Count = 0 then
			put_line("No user specified arguments. Will run a single simulation with 3 discs, non-verbose mode.");
		elsif Argument_Count = 1 then
			put_line("User entered a single number, to be used as the number of discs to solve for. Using non-verbose mode.");
			put("# of discs: "); put(ASCII.ht); put(min); new_line; 
		elsif Argument_Count = 2 then 
			put_line("User entered two numbers, to be used as a range of number of discs to solve for. Using non-verbose mode.");
			put("Minimum # of discs: "); put(ASCII.ht); put(min); new_line;
			put("Maximum # of discs: "); put(ASCII.ht); put(max); new_line;
		elsif Argument_Count = 3 then
			Put_Line("User entered two numbers to use as a minimum and maximum, and a Verbose flag.");
			put("Minimum # of discs: "); put(ASCII.ht); put(min); new_line;
			put("Maximum # of discs: "); put(ASCII.ht); put(max); new_line;
			put_line("Using Verbose mode.");
		end if; -- End status printing messages
		
	end Initialize;
	
	procedure MoveTower (N : in natural; Source : in character; Dest : in character; Inter : in character) is -- Run the simulation for N number of discs, providing Source, Intermediate, and Destination towers

	begin -- Begin MoveTower
	-- I really don't feel like I fully understand exactly how this algorithm works, but I copied it from the instructor's Powerpoint slides so I trust that it's valid.
		if N = 1 then	-- Check if this is the very final step of the solution
			if verbose = true then	-- Don't display individual moves unless in verbose mode
				put("Moved disc from "); put(source); put(" to "); put(dest); new_line;
			end if;
			num_moves := num_moves + 1;
		else	-- Copied this algorithm from instructor's Powerpoint presentation
			MoveTower(N - 1, source, inter, dest);
			MoveTower(1, source, dest, inter);
			MoveTower(N - 1, inter, dest, source);
		end if; -- End final step checker
	end MoveTower;
	
begin
	Initialize;			-- Initialize will determine what mode the program is running in based on command line arguments, verify arguments are usable, and set initial values for the program to run.
	for count in min .. max loop 	-- All settings have been assigned and possible errors checked for, it's time to run the simulation with the given information.
		put("Running simulation for "); put(count); put(" discs."); new_line;
		MoveTower(count, 'A', 'B', 'C');	-- Simulation will be run once for each number of discs the user has specified
		Put("It took a total of "); put(num_moves, 1); put(" moves to complete the simulation with "); put(count, 1); put(" discs."); new_line;
		num_moves := 0;	-- Reset num_moves for next loop around
	end loop;

exception
	when Event : Too_Many_Arguments =>
		Put_Line ("Error: You entered too many arguments! You can have up to 3 arguments for the program to work.");
		Put_Line ("Usage: ./towers [minimum] [maximum] [verbose flag]");
		put_line("GOOD: ./towers 5");
		put_line("GOOD: ./towers 2 7");
		put_line("GOOD: ./towers 2 7 V");
		put_line("BAD: ./towers 2 7 V 9 H");
	when Event : Invalid_Mode =>
		Put_Line ("Error: You must specify either Verbose mode (V) or non-Verbose mode, by using no V. Any other letter will not work.");
		put_line("GOOD: ./towers 2 7 V");
		put_line("GOOD: ./towers 2 7");
		put_line("BAD: ./towers 2 9 P");
end towers;
