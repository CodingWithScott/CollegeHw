-- Scott Felch
-- 9 December 2012
-- CSCI 241
-- Assignment 5 Extra Credit: Graph Component Traversal

with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

-- Implement an algorithm to produce all connected components for an input graph G. 
-- Will accept input graphs of varying sizes using a matrix representation in a text file. 

procedure GraphComponents is
	--************************************--
	--****         Data Types         ****--
	--************************************--
	type VaryingArray   is array(Positive range <>) of natural;
	type VaryingArray2D is array(Positive range <>, Positive range <>) of natural;
	
	type Varying_String (Maximum : Positive) is record	
		Length	:	natural := 0;
		Value	:	String (1..Maximum);
	end record;
	
	type VA (Maximum : positive) is record		-- Varying length array
		Length	:	natural := 0;
		Value	:	VaryingArray(1 .. Maximum) := (others => 0);
	end record;
	
	type VA2 (Maximum : positive) is record		-- Varying length 2D array
		Width	:	natural := 0;				-- Assuming it's a square array, so width=length
		Value	:	VaryingArray2D(1 .. Maximum, 1 .. Maximum) := (others => (others => 0));
	end record;

	--************************************--
	--****          Variables         ****--
	--************************************--
	total_verts		:	natural := 0;		-- Number of vertices in the graph, aka width of the input file in chars
	input_file		:	varying_string(20); -- Name of input file, will be input.txt for this program
	subgraph_count	:	natural := 0;		-- Number of subgraphs counted
	
	--************************************--
	--****         Procedures         ****--
	--************************************--

	-- Convert a Varying_string to a regular string
	function ToString(input : in varying_string) return string is	
	begin		
		return input.value(1..input.length);	
	end ToString;
	
	-- Receive name of input graph file and return how many columns are in it
	function HowBig (input_file_name : in varying_string) return natural is
		Input		:	file_type;			 -- Variable for the input file to read a graph matrix from
		curr_line	:	Varying_String(100); -- VString to read in graph matrix one line at a time
	begin
		Open (Input, In_File, ToString(input_file_name));		-- Assign filename to th.e file variable
		get_line(Input, curr_line.value, curr_line.length);		-- Width of matrix = total # of vertices
		Close(Input);
		return curr_line.length;
	end HowBig;
	
	-- Receive a 1D varying array and print it out 
	procedure Print(Input : in VA) is
	begin -- Begin Print
		for Count in 1 .. Input.length loop		
			put(Input.value(Count), 2);
		end loop;
		new_line;
	end Print;

	-- Receive a 2D varying array and print it out
	procedure Print(Graph : in VA2) is
	begin -- Begin Print
		for Column in 1 .. Graph.width loop		
			for Row in 1 .. Graph.width loop
				put(Graph.value(Column, Row), 2);
			end loop;
			New_line;
		end loop;
		new_line;
	end Print;
	
	-- Bubble sort
	procedure Sort (A : in out VA) is
		Finished 	:	Boolean;
		pass	 	:	integer := 1;
		N			:	integer := A.length;	-- Number of times to loop through, decreases by 1 each time you loop through

		procedure Swap(Left, Right : in out integer) is
			TempElement :	Integer := Left;
		begin
			Left := Right;
			Right := TempElement;
		end Swap;
	begin
		loop
			Finished := True;
			for index in 1 .. N-1 loop
				if A.value (index) > A.value (index+1) then
					Swap(A.value(index), A.value(index+1));
					Finished := False;
				end if;
			end loop;
			pass := pass + 1;
			N := N - 1;
			exit when Finished;
		end loop;
	end Sort;
	
	-- Build a graph from input text file
	function BuildGraph (input_file_name : in varying_string; total_verts : in natural) return VA2 is
		Input		:	file_type;			-- Variable for the input file to read a graph matrix from
		OriginalG	:	VA2(30);-- := (others => (others=> 0));
		curr_line	:	Varying_String(100);-- VString to read in graph matrix one line at a time
		row			:	positive := 1;		-- Keep track of what row is being read in
	begin
		Open (Input, In_File, ToString(input_file_name));
		
		while not end_of_file(File => Input) loop
			get_line(Input, curr_line.value, curr_line.length);		-- Store an entire line in a Vstring
			OriginalG.width := curr_line.length;
			-- Read through string to populate the graph
			for column in 1 .. total_verts loop
				-- This rather ugly line is a ghetto way of converting from the char 0 to the integer 0
				OriginalG.value(Column, row) := character'pos(curr_line.value(column)) - 48;
			end loop;
			row := row + 1;
		end loop;
		Close(Input);
		
		return OriginalG;
	end BuildGraph;
	
	-- Add nodes to the array of nodes already seen
	procedure AddToSeen(x : in natural; y : in natural; seen : in out VA) is
		x_found		:	boolean := false;
		y_found		:	boolean := false;
	begin
		-- If seen.length is 0 then this is a new subgraph, need to increment subgraph counter
		if seen.length = 0 then
			subgraph_count := subgraph_count + 1;
			seen.length := 2;
			seen.value(1) := x;
			seen.value(2) := y;
		else
			-- Checking if either of the current coordinates are represented in the Seen array, and if one of them is,
			-- the other will be added. If neither coordinate is there then it will be skipped, as this is a disconnected
			-- segment. If both coordinates are present then no change is needed, do nothing.
			for count in 1 .. seen.length loop
				if seen.value(count) = x then
					x_found := true;
				end if;

				if seen.value(count) = y then
					y_found := true;
				end if;
			end loop;
		
			if x_found = false and y_found = true then
				seen.length := seen.length + 1;
				seen.value(seen.length) := x;
			elsif y_found = false and x_found = true then
				seen.length := seen.length + 1;		
				seen.value(seen.length) := y;
			elsif (x_found = false and y_found = false) or (x_found = true and y_found = true) then
				null;
			end if;
		end if;
	end AddToSeen;
	
begin
	Put(ASCII.ESC & "[2J");
	put_line("**********************************************************");
	put_line("***        Graph Connection Analysis Thing 2.0         ***");
	put_line("**********************************************************");
	input_file.value(1 .. 9) := "input.txt";
	input_file.length := 9;
	total_verts := HowBig(input_file);			-- Determine total number of vertices present in the graph
	declare
		OriginalG	:	VA2(30);				-- Original input graph
		Seen		:	VA (30);				-- Nodes seen in current loop
		Output		:	VA2(30);				-- Output matrix, will be populated with the Seen array
	begin
		OriginalG := BuildGraph(input_file, total_verts);	-- Create graph variable
		
		Put_line("Original:   ");
		Print(OriginalG);
		seen.length := 0;						-- Initialize Seen to be empty
		seen.value := (others => 0);
		
		-- This outer loop will check for subgraphs as many times as there are nodes. Worst case scenario is there are as many
		-- subgraphs as there are nodes.
		for count in 1 .. total_verts loop		-- Outer loop will check for all possible subgraphs
			-- X and Y loops will add all connected nodes of a subgraph together and put it in the array Seen
			for     y in 1 .. total_verts loop	
				for x in 1 .. total_verts loop
					if OriginalG.value(x, y) = 1 then
						AddToSeen(x, y, Seen);
					end if;
				end loop;
			end loop;
		
			Sort(Seen);
			Output.width := Seen.Length;
			
			-- Use Seen to point back to OriginalG and check if nodes are connected or not and write to Output
			for  	y in 1 .. seen.length loop
				for x in 1 .. seen.length loop
					if OriginalG.value(Seen.value(x), seen.value(y)) = 0 then
						Output.value(x, y) := 0;
					else
						Output.value(x, y) := 1;
						-- Change 1s in OriginalG to 0 so they aren't picked up on subsequent loops for more subgraphs
						OriginalG.value(Seen.value(x), seen.value(y)) := 0;
					end if;
				end loop;
			end loop;

			-- If there's still contents in Seen then print out this subgraph
			if seen.length > 0 then
				Put("Subgraph #"); put(subgraph_count, 2); put_line(":"); 
				Print(Output);
			end if;

			-- Reset Seen and Output to 0 values for next loop
			seen.length := 0;
			seen.value := (others => 0);
			output.width := 0;
			output.value := (others => (others => 0));
		end loop;
	end; -- End declare block
	
	Put("G has "); put(subgraph_count, 1); put(" connected components, yo!"); new_line;
	
end GraphComponents;
