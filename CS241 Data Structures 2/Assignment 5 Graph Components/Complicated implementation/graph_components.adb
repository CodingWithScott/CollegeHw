-- Scott Felch / Chris Koos
-- 9 December 2012
-- CSCI 241
-- Assignment 5 Extra Credit: Graph Component Traversal
-- Graph Components package body file

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Exceptions;


package body Graph_Components is
	-- Overloaded Put statement for use with Varying_Strings. May not actually be needed, we'll see
	procedure Put(input : in Varying_string) is		
	begin
		for I in 1 .. input.length loop
			put(input.value(I));
		end loop;
	end Put; 
	
	-- Convert a Varying_string to a regular string
	function ToString(input : in varying_string) return string is	
	begin							-- Small function to convert from Varying_String to standard string, for procedures/functions expecting strings.
		return input.value(1..input.length);	
	end ToString;
	
	-- Receive a GraphMatrix and print it out 
	procedure Print(Graph : in VaryingArray) is
	begin -- Begin Print
		for Column in Graph'Range loop		-- Loop through array
			for Row in Graph'Range loop
				put(Graph(Column, Row), 2);
			end loop;
			New_line;
		end loop;
		new_line;
	end Print;
	
	-- Receive name of input graph file and return how many columns are in it
	function HowBig (input_file_name : in varying_string) return natural is
		Input		:	file_type;			 -- Variable for the input file to read a graph matrix from
		curr_line	:	Varying_String(100); -- VString to read in graph matrix one line at a time
	begin
		Open (Input, In_File, ToString(input_file_name));		-- Assign filename to the file variable
		get_line(Input, curr_line.value, curr_line.length);		-- Width of matrix = total # of vertices
		put("Total vertices:  "); put(curr_line.length, 2); new_line;
		Close(Input);
		return curr_line.length;
	end HowBig;

	-- Receive input graph file, build a GraphMatrix out of it
	function BuildGraph (input_file_name : in varying_string; total_verts : in natural) return VaryingArray is
		Input		:	file_type;			-- Variable for the input file to read a graph matrix from
		OriginalG	:	VaryingArray(1 .. total_verts, 1 .. total_verts);-- := (others => (others=> 0));
		curr_line	:	Varying_String(100);-- VString to read in graph matrix one line at a time
		row			:	positive := 1;		-- Keep track of what row is being read in
	begin
		Open (Input, In_File, ToString(input_file_name));
		
		while not end_of_file(File => Input) loop
			get_line(Input, curr_line.value, curr_line.length);		-- Store an entire line in a Vstring
			-- Read through string to populate the graph
			for column in 1 .. total_verts loop
				-- This rather ugly line is a ghetto way of converting from the char 0 to the integer 0
				OriginalG(Column, row) := character'pos(curr_line.value(column)) - 48;
--				put(OriginalG(Column, row), 2);
			end loop;
			row := row + 1;
--			new_line;
		end loop;
		new_line;
		Put_line("Graph has been fully populated");
		Close(Input);
		
		return OriginalG;
	end BuildGraph;
	
end Graph_Components;
