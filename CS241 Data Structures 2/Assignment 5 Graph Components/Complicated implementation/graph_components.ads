-- Scott Felch
-- 9 December 2012
-- CSCI 241
-- Assignment 5 Extra Credit: Graph Component Traversal
-- Graph Components package spec file

package Graph_Components is

					--#################################################--
					--##################  Data Types ##################--
					--#################################################--
	type VaryingArray is array(Positive range <>, Positive range <>) of natural;

	type Varying_String (Maximum : Positive) is record	
		Length	:	natural := 0;
		Value	:	String (1..Maximum);
	end record;
	procedure Put(input : in Varying_string);
	function ToString(input : in varying_string) return string;
	
	
	type V_Ptr;			-- Pointer to Vertex_Node
	type Vertex_Node;	-- Node storing all of a vertex's information
    type V_Ptr is access Vertex_Node;
    
    type Vertex_Node is record
    	name		:	string(1 .. 1); 	-- Name/letter of the nodes
    	reached		:	boolean := false;	-- Whether or not node has been reached yet in traversal
	end record;
	
					--#################################################--
					--#############  Functions/Procedures #############--
					--#################################################--
	-- Receive a GraphMatrix and print it out 
	procedure Print(Graph : in VaryingArray);
	
	-- Receive name of the input graph file, return how many vertices it has, will use for setting
	-- total num of vertices in driver program
	function HowBig (input_file_name : in varying_string) return natural;
	
	-- Receive input graph file and number of vertices, build a GraphMatrix out of it
	function BuildGraph (input_file_name : in varying_string; 
						     total_verts : in natural) return VaryingArray;

end Graph_Components;
