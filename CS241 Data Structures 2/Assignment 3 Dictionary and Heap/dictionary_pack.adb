-- Scott Felch / Chris Koos
-- 17 November 2012
-- CSCI 241
-- Assignment 3 Dictionary/Heap

-- Implementation of Dictionary
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Exceptions, heap_pack;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Exceptions;


package body Dictionary_Pack is
					--#################################################--
					--################### Variables ###################--
					--#################################################--
	CCounter		:	integer := 0;			-- Collision counter, not used in final program, just for troubleshooting
	total_votes		:	natural := 0;			-- Total number of votes counter
	Leader_Tracker	:	can_string := "none";	-- Current leader in the election

	Dictionary2 	: 	Dictionary_array;		-- When Add is called from Votingfun.adb it passes in Dictionary. In order for Dictionary to be accessible to all the functions/procedures
												-- in Dictionary_Pack without passing Dictionary in every single procedure/function call, a local copy called Dictionary2 is stored locally
												-- as a global variable in this package.

	


					--#################################################--
					--##############  Functions/Procedures ############--
					--#################################################--
	-- Overloaded Put statement for use with Varying_Strings
	procedure Put(input : in Varying_string) is		
	begin
		for I in 1 .. input.length loop
			put(input.value(I));
		end loop;
	end Put; 
	
	-- Convert individual character to lower case
	function ToLower (input : character) return character is
	begin
		-- If character is an upper case letter, add 32 from its ASCII value to make it lower case, otherwise just return the character untouched.
		if character'pos(input) in 65 .. 90 then
			return character'val(character'pos(input) + 32);
		else	
			return input;
		end if;
	end ToLower;
	
	-- Convert a varying_string to all lower case chars
	function ToLower (input : varying_string) return varying_string is
		new_string  : varying_string := input;		-- New string with all lower case chars
		curr_char	: character;					-- Current character being analyzed
	begin
		for count in 1 .. input.length loop
			-- Convert curr_char to a lower case and store it in new_string
			curr_char := ToLower(input.value(count));
			new_string.value(count) := curr_char;
		end loop;
		return new_string;
	end ToLower;
	
	-- Accept 2 can_strings as identifiers, compare which one has greater number of votes
	-- If either can_string refers to a null node then a 0 is used in its place, to avoid a constraint error.
	function ">" (A, B : Can_String) return boolean is
		C, D : integer := 1;
	begin
		if Find_Candidate(A) = null then
			C := 0;
		end if;
		if Find_Candidate(B) = null then
			D := 0;
		end if;
		
		if C = 0 and D = 1 then
			return C > Find_Candidate(B).votes;
		elsif C = 1 and D = 0 then
			return Find_Candidate(A).votes > D;
		elsif C = 0 and D = 0 then
			return C > D;
		else
			return Find_Candidate(A).votes > Find_Candidate(B).votes;
		end if;
	end ">";
	
	-- Hash uses first 4 chars of a candidate name to generate an identifying integer for use as an index in the dictionary
	function Hash (name : varying_string) return integer is
		Temp_Name : varying_string(20) := tolower(name);
	begin
		-- Add the ASCII values for first two letters in the name, letters have already been converted to lower case. A=0, B=1, etc
		return (character'pos(temp_name.value(1)) - 97) + (character'pos(temp_name.value(2)) - 97)+ (character'pos(temp_name.value(3)) - 97)+ (character'pos(temp_name.value(4)) - 97);
	end Hash;
	
	-- Accepts first 4 letters of a candidate's name, returns pointer to that candidate's node
	function Find_Candidate(input_name : in Can_String) return Candidate_ptr is
		L_name 		:	varying_string(20);	-- Lower case version of the name we're searching for
		current 	:	candidate_ptr;		-- Current node being evaluated
	begin
		L_name.value(1 .. 4) := input_name(1 .. 4);
		L_name.length := 4;
--		put("L_name: '"); put(L_name); put("'"); new_line;
		current := Dictionary2(Hash(L_name));								-- Use first 4 chars of Candidate name to find a location in the Dictionary

--		if current.name.value(1 .. 4) = L_name.value(1 .. 4) then			-- Check for possible collisions... 
		if Dictionary2(Hash(L_name)) = null then
			return null;
		end if;
		
		if Dictionary2(Hash(L_name)).name.value(1 .. 4) = input_name(1 .. 4) then
			return current;													-- If name matches, return pointer to this location.
		else
			while current.next /= null loop									-- Otherwise walk through linked list until finding the proper node
				current := current.next;
				if current.name.value(1 .. 4) = L_name.value(1 .. 4) then	-- Node has been located, return the pointer to it
					return current;
				end if;
			end loop;
		end if;
		
		return null;														-- If neither return statement has been hit yet then the node doesn't exist in the Dictionary. 
																			-- This should never happen but Ada wants another return statement here.
	end Find_Candidate;
	
	-- Add a vote to the Dictionary, will either insert a new node or increment the appropriate node
	procedure Add(input_name : in varying_string; Dictionary : in out Dictionary_Array; Vote_Heap : in out heap_array) is
		new_candidate_node	 :	Candidate_Ptr := 							-- New node with default values of Name passed in, Lower_case name, null pointers for Next, and vote count 1.
			new Candidate_Node'(input_name, ToLower(input_name), null, 1);
		current				 :	Candidate_Ptr := null; 						-- Pointer to current node being looked at when traversing linked list
		L_name 				 : 	varying_string(20) := tolower(input_name);  -- Lower case version of the name
		Cand_Found 			 :	boolean := false;							-- Flag indicating if current candidate has been found while walking linked list
	begin
		total_votes := total_votes + 1;	-- Increment total vote counter every time Add is called

		--*** If no Candidate exists in the Dictionary at current hash value, add the Candidate ***--
		if Dictionary(Hash(L_name)) = null then 							-- Checks if candidate node is empty
			Dictionary(Hash(L_name)) := new_candidate_node;					-- Add the new Candidate to appropriate spot in the dictionary
			Add_Heap(Vote_Heap, Dictionary(Hash(L_name)).name, Dictionary); -- Add Candidate to the heap
			
		--*** If a Candidate exists at this entry and it's the Candidate we're looking for, increment vote counter ***---
		elsif Dictionary(Hash(L_name)).name.value(1 .. Dictionary(Hash(L_name)).name.length)  = L_Name.value(1 .. L_name.length) then    --(This line did not work before comparing exact strings. Unknown reason why)
			Dictionary(Hash(L_name)).votes := Dictionary(Hash(L_name)).votes + 1;
	
		--*** If a Candidate exists at this entry but it's a collision, traverse to the correct location and either.... ***---
		else
			put("Collision: "); put(L_name); put(" Current Node Name: "); put(Dictionary(Hash(L_name)).name); new_line;
--			CCounter := CCounter + 1;
--			put("Collision: "); put(CCounter); new_line;
			current := Dictionary(Hash(L_name)).next;
		
			while current /= null and Cand_Found = False loop     		-- Walk through linked list until finding either correct Candidate or empty spot
				current := current.next;
				if current.name = L_name then
					Cand_Found := True;
				end if;
			end loop;
			
			---*** ...insert new Candidate node.... OR ***---
			if current = null then -- If ran into a null, then insert this node
				current := new_candidate_node;
				Add_Heap(Vote_Heap, current.name, Dictionary);
			---*** ...increment vote counter of correct Candidate. ***---
			else -- Or if ran into the candidate we're looking for, increment the vote counter
				current.votes := current.votes + 1;
			end if;
		end if;
		
		Dictionary2 := Dictionary;										-- Update local copy of Dictionary
		
		-- Need this if statement to handle the first vote counted
		if leader_tracker = "none" then
			Put(Find_Candidate(Vote_Heap(1)).Printed_Name); put(" pulls into the lead with ");
			Put(Find_Candidate(Vote_Heap(1)).votes, 0); put(" of "); put(total_votes, 0); 
			put_line("  votes."); 
		end if;
		
		leader_tracker := Vote_Heap(1);									-- Top entry in the heap is assigned as the leader
--		put("leader_tracker:  "); put(leader_tracker); new_line;
		heapify(Vote_Heap);												-- Sort the heap
--		put("leader_tracker:  "); put(leader_tracker); new_line;
		if leader_tracker /= Vote_Heap(1) then							-- If the top entry is now different, put who is now ahead
			Put(Find_Candidate(Vote_Heap(1)).Printed_Name); 
			put(" pulls into the lead with ");
			Put(Find_Candidate(Vote_Heap(1)).votes, 0); put(" of "); 
			put(total_votes, 0); put_line("  votes."); 
		end if;
	end Add;
	
	-- Add a new candidate to the heap
	procedure Add_Heap(In_heap : in out heap_array; Data : in varying_string; Dictionary : in out dictionary_array) is
		Found_empty : boolean := false;
	begin
		for n in 1 .. 24 loop
			if in_heap(n) = "none" and found_empty = false then
				In_Heap(N) := data.value(1 .. 4);	
				found_empty := true;
			end if;
		end loop;
	end Add_Heap;
	
	-- Heapify the vote heap. Having a procedure for it here allows Votingfun.adb to call the Heapify procedure, which is otherwise not visible to the driver program.
	procedure sort(Vote_heap : in out heap_array) is
	begin
		heapify(Vote_Heap);
	end Sort;

end Dictionary_Pack;
