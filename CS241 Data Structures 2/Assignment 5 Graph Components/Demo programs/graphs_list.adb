with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

-- Create, initialize, traverse and transpose a linked list representation of a graph
-- TO DO: Nothing, this shit is done!! 

procedure Graphs_List is
	vertices	:	positive; -- Number of user defined vertices in the graph. Hard coded for now.

	--************************************--
	--****          Data Types        ****--
	--************************************--
	type Vert_Ptr;			-- Pointer to a Vertex node's linked list node representation
	type Vert_Node;			-- A Vertex node's linked list node representation
	type Vert_Ptr is access Vert_Node;
	
	type Vert_Node is record
		name	:	natural := 0;
		next	:	Vert_Ptr := null;
	end record;
	
	type Graph_List_Type is array (Positive range <>) of Vert_Ptr;
	
	procedure DefineGraphs (num_of_vertices : in positive) is
		--************************************--
		--****         Procedures         ****--
		--************************************--	
		-- Receive a GraphList (either G or GT) and print it out 
		procedure Print(Graph : in Graph_List_Type) is
			current	:	Vert_Ptr;				-- Current node being looked at for traversal
		begin -- Begin Print
			for Column in Graph'Range loop		-- Loop through array
				current := Graph(Column);
				put("Column "); put(Column, 0); put(":      ");

				-- Check if current column in array has any nodes before 
				-- attempting to access name within it, to avoid Constraint errors.
				if current /= null then
						put(Graph(Column).name, 2);
						while current.next /= null loop
							current := current.next;
							put(Integer'Image (current.name)); put(" ");
						end loop;
				end if;
				
				current := null;
				New_line;
			end loop;
			new_line;
		end Print;

		procedure MakeGraphs (num_of_vertices : in positive) is
			--************************************--
			--****          Variables         ****--
			--************************************--	
			G	:	Graph_List_Type(1 .. num_of_vertices) := (others => null);	-- Original Graph
			GT	:	Graph_List_Type(1 .. num_of_vertices) := (others => null);	-- Transposed Graph
		
			-- Add a Vert_Ptr to the Graph_List
			procedure Add(Graph_List : in out Graph_List_Type;			-- Array to add a node to
 						  Column	 : in positive; 		 			-- Column of the array to add to
						  input_name : in positive) is					-- Name/integer of node to be added 

				new_Vert_Ptr	: Vert_Ptr := new Vert_Node'(input_name, null);			-- New pointer to add to array
				parent			: Vert_Ptr;  		-- Pointer to traverse the linked list within the array,
													-- until finding 2nd to last entry
				current			: Vert_Ptr;			-- Pointer to scan to the end of the linked list
			begin
				-- Set Parent and Current to head of column, navigate through list to get Current pointing to last
				-- element, Parent pointing to second to last element.
				parent := Graph_List(Column);
				current := Graph_List(Column);
				if current = null then			-- If head of the linked list is null, put the new node here
					current := new_Vert_Ptr;	-- Set current to equal the new Vert_Ptr node created
					Graph_List(Column) := current;
				else							-- Otherwise traverse linked list to put node at the end
					while current /= null loop
						if current /= null then
							parent := current;
							current := current.next;
						end if;
					end loop;
					current := new_Vert_Ptr;		-- Set current to equal the new Vert_Ptr node created
					parent.next := current;			-- Set last element in the list to now point to newly created node
				end if;
			end Add;
			
			procedure PopulateG is
			begin
	 			-- Initialize G to values provided in Yudong's assignment spec file
	 			-- Can pretend I'm reading in from a real graph, for now I'll hardcode everything in. 
	 			-- It's ugly, deal with it.
	 			
	 			-- Parameters: GraphList array to be added to, column to add to, name of node to add
				Add(G, 1, 2);
				Add(G, 1, 4); 	
				Add(G, 2, 5);
				Add(G, 3, 5);
				Add(G, 3, 6);
				Add(G, 4, 2);
				Add(G, 5, 4);
				Add(G, 6, 6);
			end PopulateG;
			
			procedure PopulateGT is
				-- Read through linked list G. Name of node in G will become Column in GT,
				-- Column in G will become Name in GT. 
				current 	:	Vert_Ptr;		-- Current node being analyzed in G 
				new_name	:	positive;		-- Read column from G, will use as a name in GT
				new_column	:	positive;		-- Read name from G, will use as column in GT
			begin
				for Column in 1 .. num_of_vertices loop
					current := G(Column);
					new_name := Column;
					
					while current /= null loop -- If current column is empty, no need to read anything, so just move on to next column.
						new_column := current.name;
						current := current.next;
						Add(GT, new_column, new_name);
					end loop;
				end loop;
				
			end PopulateGT;
		
		begin -- Begin MakeGraphs
			PopulateG;
			PopulateGT;

			put_line("Original Graph:  ");
			Print(G); 
			
			put_line("Transposed Graph:  ");
			Print(GT);
		end MakeGraphs;

	begin -- Begin DefineGraphs
		MakeGraphs(num_of_vertices);
	end DefineGraphs;


begin -- Begin Graphs.adb
	Put(ASCII.ESC & "[2J");
	put_line("**********************************************************");
	put_line("***   Linked List Graph Representation Demonstration   ***");
	put_line("**********************************************************");

	-- Theoretically could change to be more generic and allow different graphs, 
	-- for now will just keep things hard coded to run with Yudong's 6 vertice example.
--	put("How many vertices are there in the graph?   ");
--	get(vertices);
	vertices := 6;
	DefineGraphs(vertices); -- Define what a Graph data type is, which will call MakeGraphs to instantiate

	Put_line("Well that was fun, peace out girl scout.");
end Graphs_List;
