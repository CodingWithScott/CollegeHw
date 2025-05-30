-- Scott Felch
-- 9 December 2012
-- CSCI 241
-- Assignment 5 Extra Credit: Graph Component Traversal
-- Driver program

with Ada.Text_IO, Ada.Integer_Text_IO, graph_components, generic_stack;
use  Ada.Text_IO, Ada.Integer_Text_IO, graph_components;

-- Implement an algorithm to produce all connected components for an input graph G. 
-- Will accept input graphs of varying sizes using a matrix representation in a text file. 

-- TO DO: First write a basic graph traversal program using matrix implementation. Once that is done,
-- begin working on how to handle disconnected subgraphs like the assignment calls for. 

procedure GraphMain is
	--************************************--
	--****          Variables         ****--
	--************************************--
	total_verts	:	natural := 0;		-- Number of vertices in the graph, aka width of the input file in chars
	input_file	:	varying_string(20); -- Name of input file, will be input.txt for this program
	
	
	
	

begin
	Put(ASCII.ESC & "[2J");
	put_line("**********************************************************");
	put_line("***        Graph Connection Analysis Thing 2.0         ***");
	put_line("**********************************************************");
	input_file.value(1 .. 9) := "input.txt";
	input_file.length := 9;
	total_verts := HowBig(input_file);			-- Determine total number of vertices present in the graph
	declare
		OriginalG	:	VaryingArray(1 .. total_verts, 1 .. total_verts) := (others => (others => 0));
	begin
		OriginalG := BuildGraph(input_file, total_verts);	-- Create graph variables
		Print(OriginalG);
	end; -- End declare block
	
--	put(OriginalG(1,1));

end GraphMain;
