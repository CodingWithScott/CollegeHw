-- Scott Felch / Chris Koos
-- 17 November 2012
-- CSCI 241
-- Assignment 3 Dictionary/Heap

-- Specification of Dictionary

with heap_pack;

package Dictionary_Pack is

					--#################################################--
					--##################  Data Types ##################--
					--#################################################--
	type Varying_String (Maximum : Positive) is record	
		Length	:	natural := 0;
		Value	:	String (1..Maximum);
	end record;
	procedure Put(input : in Varying_string);
	
	type Candidate_Ptr;		-- Pointer to Candidate_Node
	type Candidate_Node;	-- Node storing all of a candidate's information
    type Candidate_Ptr is access Candidate_Node;

    type Candidate_Node is record					-- Aka Dictionary_Node 
		Printed_Name 	:	varying_string(20);		-- Name of candidate as defined first time it was encountered in Ballots.txt
		name			:	varying_string(20) := 	-- Name of candidate in all lower case. Default values assigned to easily identify empty nodes.
							(Length => 5, 
							Value => "empty123456789012345", 
							Maximum => 20);		
		Next			:	Candidate_Ptr;			-- Pointer to next candidate in the linked list, used for chaining
		Votes			:	natural := 0;			-- Number of votes candidate has acquired
	end record;
	


	subtype Can_String is string(1 .. 4);										-- Candidate_String: stores first 4 chars of candidate name in all lower case, used for hashing and finding candidates.
	type Dictionary_Array is Array (0 .. 137) of Candidate_Ptr;					-- Dictionary of all the Candidates' information
	type Heap_Array_Unconstrained is array (positive range <>) of Can_String;	-- Heap_type keeping track of leaders, uses can_strings as identifiers
	subtype Heap_Array is Heap_Array_Unconstrained(1 .. 24);					-- Instantiation of the Heap_type
	
					--#################################################--
					--##################  Functions ###################--
					--#################################################--
	-- Functions for converting characters and strings to lower case, used throughout the program for consistency of input
	function ToLower (input : character) return character;
	function ToLower (input : varying_string) return varying_string;
	
	function ">" (A, B : can_string) return boolean;							-- Accepts 2 can_strings and returns the candidate with greater number of votes
	function Hash (name : varying_string) return integer;						-- Hash function identifies a candidate's location in the Dictionary using first 4 chars of the candidate's name
	function Find_Candidate(input_name : in can_string) return Candidate_Ptr;	-- Accepts can_string as input to locate the Dictionary entry for a candidate and returns pointer to candidate
	
	package Heap_Type is new heap_pack(Element_Type => can_string, 				-- Instantiation of generic heap_pack using can_strings as the data type
									   heap_pack_array => heap_array_unconstrained, 
								       ">" => ">");
	use Heap_Type;
	
					--#################################################--
					--##################  Procedures ##################--
					--#################################################--
	-- Add a vote to the Dictionary
	procedure Add(input_name   : in varying_string; 			-- Candidate's printed name
				  Dictionary   : in out Dictionary_Array; 		-- Dictionary passed from driver program into package
				  Vote_Heap    : in out Heap_Array);			-- Heap passed in so that it can call Add_Heap when necessary
				  
	-- Add a new candidate to the heap
	procedure Add_Heap(In_heap : in out heap_array; 			-- Heap_array to be added to
					   Data    : in varying_string; 			-- Name of Candidate being added
				    Dictionary : in out dictionary_array);		-- Copy of Dictionary containing all Candidate's information
	
	procedure sort(vote_heap   : in out heap_array);			-- Sort/heapify the heap, called every time a vote is added
	


end Dictionary_Pack;
