with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

-- Create, initialize, traverse and transpose a matrix representation of a graph.
-- TO DO: Nothing! All done, works great. :)

procedure Graphs_Matrix is
	vertices	:	positive; -- Number of user defined vertices in the graph

	procedure DefineGraphs (num_of_vertices : in positive) is
		-- Variable length 2-dimensional array
		type VaryingArray is array(Positive range <>, Positive range <>) of natural;
		subtype GraphMatrix is VaryingArray(1 .. num_of_vertices, 1 .. num_of_vertices);

		-- Print out a VaryingArray
		procedure Print(input : in VaryingArray) is
		begin -- Begin Print
			for I in Input'Range(1) loop		-- Loop through columns
				for J in Input'Range(2) loop	-- Loop through rows
					Put (Integer'Image (input (I, J)) & " ");
				end loop;
				New_line;
			end loop;
			new_line;
		end Print;

		procedure MakeGraphs (num_of_vertices : in positive) is
			-- GraphMatrix of width/length identical to how many nodes/vertices there are
			Columns		:  positive := num_of_vertices;
			Rows		:  positive := num_of_vertices;
			G  			:  GraphMatrix;

			-- Transposed version of Graph Matrix
			YudongGT    :  GraphMatrix;
			ScottGT		:  GraphMatrix;

			-- Counter for how many nodes of original graph are read in			
			Y_count		:	natural := 0;
			S_count		:	natural := 0;

		begin -- Begin MakeGraphs
			G 				:= (others => (others => 0));
			YudongGT 		:= (others => (others => 0));
			ScottGT 		:= (others => (others => 0));

 			-- Initialize G to values provided in Yudong's assignment spec file
			G :=  ((0, 1, 0, 1, 0, 0),
				   (0, 0, 0, 0, 1, 0),
				   (0, 0, 0, 0, 1, 1),
				   (0, 1, 0, 0, 0, 0),
				   (0, 0, 0, 1, 0, 0),
				   (0, 0, 0, 0, 0, 1));


			-- Testing out Yudong's pseudocode algorithm to transpose a graph.
			-- Turns out it's broken, skips over some chars that need to be read, outputs garbage.
			put_line("Yudong's reading input, note that it skips necessary matrix entries:  "); 
			
			for i in G'Range(1) loop 				-- Loop through all columns of G
				for j in i+1 .. G'Length(2) loop	-- Loop through some rows of G but not all
					Y_count := Y_count + 1;
					Put("G("); Put(I, 0); Put(","); Put(J, 0); put("):"); 
					Put(Integer'Image(G (I, J))); 
--					put("    Y_Count:  "); put(Y_count, 0); New_line;
					new_line;
					if G(i,j) = 1 then 			-- If (column, row) in G = 1, set row, column in GT to 1
						YudongGT(j,i) := 1;
					end if;
				end loop;
			end loop;
			Put("Total entries read:  "); put(Integer'Image(Y_count)); Put(" out of "); 
			put_line(Integer'Image(num_of_vertices * num_of_vertices)); 
			Put_line("End Yudong"); new_line; 
			
			put_line("My reading input, hits every single matrix entry:  ");
			-- Set of loops will transpose the original graph G, making a correct GT.
			for i in G'Range(1) loop 				-- Loop through all columns of GT
				for j in G'Range(2) loop			-- Loop through all rows within each column of GT
					S_count := S_count + 1;
					Put("G("); Put(I, 0); Put(","); Put(J, 0); put("):"); 
					Put(Integer'Image(G (I, J))); 
					-- put("    S_Count:  "); put(S_count, 0); 
					New_line;
					if G(i,j) = 1 then 			-- If (column, row) in G = 1, set (row, column) in GT to 1
						ScottGT(j,i) := 1;
					end if;
				end loop;
			end loop; 
			Put("Total entries read:  "); put(Integer'Image(S_count)); Put(" out of "); 
			put_line(Integer'Image(num_of_vertices * num_of_vertices)); 
			Put_line("End Scott");  new_line;

			put_line("Original Graph:  ");
			Print(G); 

			put_line("Yudong's broken Transposed Graph:  ");
			Print(YudongGT);
			
			put_line("My functional Transposed Graph (yay!):  ");
			Print(ScottGT); 
		end MakeGraphs;

	begin -- Begin DefineGraphs
		MakeGraphs(num_of_vertices);
	end DefineGraphs;


begin -- Begin Graphs.adb
	Put(ASCII.ESC & "[2J");
	put_line("**********************************************************");
	put_line("***      Matrix Graph Representation Demonstration     ***");
	put_line("**********************************************************");

--	put("How many vertices are there in the graph?   ");
--	get(vertices);

	-- Theoretically could change to be more generic and allow different graphs, 
	-- for now will just keep things hard coded to run with Yudong's 6x6 example.
	vertices := 6;
	DefineGraphs(vertices);

	Put_line("Well that was fun, peace out girl scout.");
end Graphs_Matrix;
