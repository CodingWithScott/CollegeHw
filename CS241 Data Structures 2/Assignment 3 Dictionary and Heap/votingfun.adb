-- Scott Felch / Chris Koos
-- 17 November 2012
-- CSCI 241
-- Assignment 3 Dictionary/Heap

-- Main driver program

with Ada.Text_IO, Ada.Integer_Text_IO, dictionary_pack; 
use  Ada.Text_IO, Ada.Integer_Text_IO, dictionary_pack;

procedure votingfun is

					--#################################################--
					--############## Variables 'n' stuff ##############--
					--#################################################--
	input_file		:	file_type;				-- Variable for input file containing all the votes
	current_ballot	:	varying_string(20);		-- Current line being analyzed

	Dictionary 		:	Dictionary_Array;		-- Dictionary_Array is an array 0 .. 137 of Candidate_Ptr
	Vote_Heap		:	heap_array := 			-- Heap to be used for keeping track of election leaders
						(others => "none");	
	hanging_chad	:	boolean := false;		-- Boolean used to determine if a vote recount is necessary
	happy			:	character;				-- User input indicating whether they desire a recount or not
	InvalidInput	:	exception;				-- Exception raised if user gives a bad answer for "happy"
	
	procedure Initialize is
	begin
		Put(ASCII.ESC & "[2J");
		put_line("************************************************************************************************************");
		put_line("***                              WE ARE GOING TO VOTE LIKE IT'S 1999!!!                                  ***");
		put_line("************************************************************************************************************"); 
		new_line;
		put_line("                               o                                                        _..                 ");
		put_line("           H|H|H|H|H           H__________________________________         ___..-'''-.  `)^|   .-'''-..___  ");
		put_line("           H|H|H|H|H           H|* * * * * *|---------------------|       `-...___ '=.'-.'  \-'.=' ___...-' ");
		put_line("           H|H|H|H|H           H| * * * * * |---------------------|               `\  ' ##### '  /`         ");
		put_line("           H|H|H|H|H           H|* * * * * *|---------------------|                 '--;|||||;--'           ");
		put_line("           H|H|H|H|H           H| * * * * * |---------------------|                    /\|||/\              ");
		put_line("           H|H|H|H|H           H|---------------------------------|                   ( /;-;\ )             ");
		put_line("        ===============        H|---------------------------------|                    '-...-'              ");
		put_line("          /| _   _ |\          H|---------------------------------|                                         ");
		put_line("          (| O   O |)          H|---------------------------------|                                         ");
		put_line("          /|   U   |\          H-----------------------------------                                         ");
		put_line("           |  \=/  |           H                                                                            ");
		put_line("            \_..._/            H                                                                            ");
		put_line("    _______/\| H |/\_______    H                                                                            ");
		put_line("   /       \ \   / /       \   H                                                                            ");
		put_line("  |         \ | | /         |  H                                                                            ");
		put_line("  |          ||o||          |  H                                                                            ");
		put_line("  |    |     ||o||     |    |  H                                                                            ");
		put_line("  |    |     ||o||     |    |  H                                                                            ");
	
	end Initialize;
	
	-- Traverse dictionary and print contents. Not used in final program, just for troubleshooting purposes.
	procedure PrintDictionary is
		current		:	Candidate_Ptr;
	begin
		for n in 0 .. 131 loop
			if dictionary(n) /= null then
				current := dictionary(n);
				put(current.name); put(" :  Hash Location: ");  
				put(n, 0); put("   Vote count: "); put(current.votes, 0); new_line;

				while current.next /= null loop
					current := current.next;
					put(current.name); put(" :  Hash Location: ");  
					put(n, 0); put("   Vote count: "); put(current.votes, 0); new_line;
				end loop;
			end if;
		end loop;
	end PrintDictionary;
	
	-- Read in and process votes from input file
	procedure TallyVotes is
	begin
		put_Line("Processing input file..."); new_line; new_line;
		Open (Input_File, In_File, "ballots.txt");
	
		while not end_of_file(File => Input_File) loop
			get_line(Input_File, current_ballot.value, current_ballot.length);
			Add(current_ballot, Dictionary, Vote_Heap);
		end loop;
		Close(Input_File);
	end TallyVotes;
	
	-- Iterate through the Vote_Heap, each time through the top node is printed, then assigned 0
	-- and put back at end of the heap until all nodes have been printed.
	procedure DisplayResults is
	begin
		new_line; new_line;
		for n in 1 .. 24 loop
			-- Put current candidate's name and number of votes
			put("("); put(find_candidate(vote_heap(1)(1 .. 4)).votes, 4); put(" votes)  ");
			put(find_candidate(vote_heap(1)(1 .. 4)).printed_name); new_line;

			-- Put them in back of heap and do it again
			find_candidate(vote_heap(1)(1 .. 4)).votes := 0;
			sort(Vote_heap);
		end loop;
	end DisplayResults;

begin

	Initialize;			-- Display welcome screen 
	TallyVotes;			-- Read in and process votes from input file
--	PrintDictionary;	-- Print Dictionary to verify contents
	DisplayResults;		-- Print out the final results of the election

	loop
		new_line;
		put("Are you happy with the results? I can do a recount if you want. (Y/N)   ");
		get(happy);	
		if ToLower(happy) = 'y' then 
			put_line("Sweet! Enjoy your new city council!!"); 
			hanging_chad := false;
		elsif ToLower(happy) = 'n' then
			TallyVotes;
			DisplayResults;
			put_line("Dang, looks like it's the same. Bummer!");
			hanging_chad := true;
		else
			raise InvalidInput;
		end if;
		exit when hanging_chad = false;
	end loop;
	

exception	
	when Event : InvalidInput =>
		new_line; put_line("Uh oh... I'm not sure what that means. I'm shutting down now.");
end votingfun;
