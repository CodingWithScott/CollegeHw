-- Scott Felch
-- 19 November 2011
-- CSCI 141, David Bover
-- Assignment 3 Online Store. This program will read in data from Inventory.txt and use it to create an array of records about 
-- different product types, including: product code, product description, price, product category, stock on hand, and sales history.
-- It will then read in data from transactions.txt and modify inventory based on transactions: sale of items, delivery of items, 
-- new products introduced, deleting products, and changing price of existing product. After processing everything, updated data 
-- will be outputted to newinventory.txt.

with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure store is
--== New data types I need to work with
	type money is delta 0.01 range 0.0 .. 1000.00;					-- This fixed point data type makes handling money easier
		package money_io is new fixed_io(money);				-- Not able to Get or Put an enumerated type without instantiating and using its package
		use money_io;
	type Category_Type is (ACCESSORY, JACKET, PANTS, SHIRT, SHOES, SWEATER);	-- This enumerated type makes categorizizng clothing types easier
		package category_io is new enumeration_io(category_type);		
		use category_io;
	type Transaction_Type is (DELETE, DELIVERY, NEWPRODUCT, PRICE, SALE);		-- This enumerated type makes performing transactions easier
		package transaction_io is new enumeration_io(transaction_type);
		use transaction_io;
	type Sales_Array is array (1 .. 12) of natural;					-- This array will hold sales history for last 12 months of a product
	product_code_size	:	constant := 8;					-- Length of product code as assigned in spec file
	product_desc_size	:	constant := 30;					-- Length of product description
	subtype product_code_type is string(1 .. product_code_size);			-- Subtype specifically for holding product's code
	subtype product_description is string (1 .. product_desc_size);			-- Subtype specifically for holding product's description
	type Product is	record								-- This record type will hold all 6 relevant pieces of information to 1 product
		product_code	:	product_code_type := "12345678";
		description	:	product_description := "123456789012345678901234567890";
		price		:	money := 0.00;
		category	:	category_type := ACCESSORY;
		stock		:	natural := 0;
		sales_history	:	sales_array := (others => 0);
	end record;
	type Sales_Total is record							-- This record will associate a category label with the corresponding numerical sales total
		category	:	category_type;
		total		:	money := 0.00;
	end record;
	type Total_Array_Type is array (1 .. 6) of Sales_Total;				-- This array will hold the names and numerical values sales totals for the categories
	
	
--== Instantiations of data types
	max_number_of_products	:	constant := 200;					-- Maximum number of products, as defined in assignment spec
	num_of_categories	:	constant := 6;						-- Number of categories of items I have
	all_the_things		:	array (1 .. max_number_of_products) of Product;		-- This is my big array of records holding all the data about my inventory
	Total_Array		:	array (1 .. num_of_categories) of Sales_Total;		-- Array of 6 elements to hold the total sales of the categories
	accessory_sales		:	money := 0.00;						-- Accumulator for accessory sales, temporary holder before putting into an array and sorting
	jacket_sales		:	money := 0.00;						-- Accumulator for jacket sales
	pants_sales		:	money := 0.00;						-- Accumulator for pants sales
	shirt_sales		:	money := 0.00;						-- Accumulator for shirt sales
	shoe_sales		:	money := 0.00;						-- Accumulator for shoe sales
	sweater_sales		:	money := 0.00;						-- Accumulator for sweater sales

--== These functions will be used numerous times in the program so it saves space and makes the program easier to read to define them here
	-- Skip_spaces finds the next non-whitespace character in a line, so a Get command can read a line
	-- without screwing up due to whitespace.
	procedure Skip_spaces is
		Next	: character; 		-- The current character being analyzed in a line of text
		Endline : boolean; 		-- Whether or not the current character is the end of the line
	begin -- Begin skip_spaces
		Endline := false;
		look_Ahead(Next, Endline);
		while Next = ' ' or Next=ASCII.ht or Endline = true loop
			if Endline = true then
				Skip_line;
			else
				Get(Next);
			end if;	
		look_Ahead(Next, Endline);
		end loop;
	end Skip_spaces;
	
	-- Checks to see whether an item currently exists in the array or not, returns as a boolean
	function item_exists (looking_for : product_code_type) return boolean is
		index		: 	natural;
		exists		:	boolean := false;
	begin -- Begin item_exists
		for N in all_the_things'range loop
			if all_the_things(n).product_code = looking_for then
				index := N;
				exists := true;
				exit;
			end if;
		end loop;
		return exists;
	end item_exists;
	
	-- Finds the index value of a given item based on item code
	function find_item (looking_for : product_code_type) return natural is
		index		:	natural;
	begin -- Begin find_item
		for N in all_the_things'range loop
			if looking_for = all_the_things(N).product_code then
				index := N;
				exit;
			end if;
		end loop;
		return index;
	end find_item;
	
	-- Finds the first blank entry in the array to store a New Product in, and fills in the data that was passed by the calling procedure
	procedure write_to_first_empty (new_code : in product_code_type; new_prod_desc : in product_description; new_price : in money; new_category : in category_type) is
		index		:	natural; -- The index location of the first empty array cell found
	begin -- Begin write_to_first_empty
		for N in all_the_things'range loop
			if all_the_things(N).product_code = "12345678" then	-- The first cell that's encountered with a default entry for product code will be used to hold new product data
				index := N;
				exit;
			end if;
		end loop;
		-- After proper index has been found, write all the data for new product to that cell
		all_the_things(index).product_code := new_code;
		all_the_things(index).description := new_prod_desc;
		all_the_things(index).price := new_price;
		all_the_things(index).category := new_category;
		all_the_things(index).stock := 10;
		-- Sales_history is left at all 0s, since a new product has no previous sales
	end write_to_first_empty;
	
	-- This procedure will sort the category sales totals into ascending order, to be outputted all pretty and nice at the end of the program
	procedure SortSales is
		temp		:	Sales_Total;
	begin -- Begin SortSales, just a simple Bubble Sort
		for I in Total_Array'Range loop
			for J in Total_Array'Range loop
				if Total_Array(I).total > Total_Array(J).total then
					temp := Total_Array(I);
					Total_Array(I) := Total_Array(J);
					Total_Array(J) := temp;
				end if;
			end loop; 
		end loop;
	end SortSales;
		
	-- This procedure will populate my array with all the info needed from inventory.txt
	procedure Populate is
		Inventory	:	file_type;
		line_counter	:	positive := 1;
	begin -- Begin Populate
		-- Set category names for sales accumulators
		Total_Array(1).category := ACCESSORY; 
		Total_Array(2).category := JACKET; 
		Total_Array(3).category := PANTS; 
		Total_Array(4).category := SHIRT; 
		Total_Array(5).category := SHOES; 
		Total_Array(6).category := SWEATER;

		Open (Inventory, In_File, "inventory.txt");
		Set_Input(Inventory);
		while not end_of_file(File => Inventory) loop
			get(all_the_things(line_counter).product_code);	
			get(all_the_things(line_counter).description);
			get(all_the_things(line_counter).price);
			get(all_the_things(line_counter).category);
			get(all_the_things(line_counter).stock);
			for month in 1 .. 12 loop
				get(Inventory, all_the_things(line_counter).sales_history(month));
			end loop; 	-- End sales_history population loop, sales_history array has been populated for this element
			line_counter := line_counter + 1;
		end loop; -- End population loop, done reading inventory.txt
		
		Close (Inventory);
	end Populate;
	
	-- This procedure will create all the modifications to the data in my array using transactions.txt
	procedure Transact is
		Transactions		:	file_type;			-- Variable for the input file
		current_transaction	:	Transaction_Type;		-- The transaction that will be performed on this line
		current_prod_id		:	string(1 .. product_code_size);	-- The product ID I'm searching for in the array all_the_things
		new_prod_desc		:	string(1 .. product_desc_size);	-- The new product's description
		new_price		:	money;				-- The new product's price
		new_category		:	category_type;			-- The new product's category
		quantity		:	natural;			-- The number of items being sold or delivered
		index			:	natural;			-- Index value of the current item being looked for
		transact_counter	:	natural := 1;			-- Counter of how many transactions have been performed so I can tell how far I've gone in transactions.txt
		
	begin -- Begin Transact
		Open (Transactions, In_File, "transactions.txt");
		Set_Input(Transactions);
		while not end_of_file(File => Transactions) loop
			get(current_transaction);
			skip_spaces;	-- There's a space between the transaction type and the product ID, I think I need to skip it to read product ID properly

			case current_transaction is
				when DELETE =>
					get(current_prod_id);
					if not item_exists(current_prod_id) then
						put_line("ERROR: The item " & current_prod_id & " doesn't exist! Deletion not performed.");	
					else	
					-- Once the correct product is is verified, every element from here to the end of the array will be shifted one cell up, 
					-- overwriting any previous contents	
						index := find_item(current_prod_id);
						for N in index .. (max_number_of_products - 1) loop
							all_the_things(N) := all_the_things(N+1);
						end loop;
					end if; -- End item_exists check
				
				when DELIVERY => 
					get(current_prod_id);
					if not item_exists(current_prod_id) then
						put("ERROR: The item "); put(current_prod_id); put(" doesn't exist! Delivery not performed."); new_line;
					else
						get (quantity);
						index := find_item(current_prod_id);						
						all_the_things(index).stock := all_the_things(index).stock + quantity;	-- Increment stock by however many were delivered
					end if; -- End item_exists check
				
				when NEWPRODUCT =>
					get(current_prod_id);
					if item_exists(current_prod_id) then
						Put("ERROR: A product already exists with ID "); put(current_prod_id); put("! new product not created."); new_line;
					else
						get(new_prod_desc);
						get(new_price);
						skip_spaces;
						get(new_category);
						write_to_first_empty(current_prod_id, new_prod_desc, new_price, new_category);
					end if; -- End item_exists check
			
				when PRICE =>
					get(current_prod_id);
					if not item_exists(current_prod_id) then
						put_line("ERROR: The item " & current_prod_id & " doesn't exist! Price change not performed.");
					else 
						index := find_item(current_prod_id);
						skip_spaces;
						get(new_price);
						all_the_things(index).price := new_price;
					end if; -- End item_exists check

				when SALE =>
					get(current_prod_id);
					get (quantity);
					if not item_exists(current_prod_id) then
						put_line("ERROR: The item " & current_prod_id & " doesn't exist! Sale not performed.");
					else 
						index := find_item(current_prod_id);
						if all_the_things(index).stock - quantity < 0 then -- If the transaction is trying to sell more of product than in stock, display error and do nothing else
							Put_line("ERROR: Item " & current_prod_id & " has insufficient stock! Sale not performed.");
						else	-- If enough of item is in stock, then perform the sale
							all_the_things(index).stock := all_the_things(index).stock - quantity;	-- Decrement stock by however many were sold
							case all_the_things(index).category is -- Increment sales for apppropriate category
							-- The sales accumulators are going to incrmement sections of an array that is indexed 1 to 6. This will be sorted later.
								when ACCESSORY 	=> accessory_sales	:= accessory_sales	+ (all_the_things(index).price * quantity);
								when JACKET	=> jacket_sales		:= jacket_sales	 	+ (all_the_things(index).price * quantity);
								when PANTS 	=> pants_sales		:= pants_sales	 	+ (all_the_things(index).price * quantity);
								when SHIRT 	=> shirt_sales		:= shirt_sales		+ (all_the_things(index).price * quantity);
								when SHOES 	=> shoe_sales		:= shoe_sales		+ (all_the_things(index).price * quantity);
								when SWEATER 	=> sweater_sales	:= sweater_sales	+ (all_the_things(index).price * quantity);
							end case; -- End category detection
						end if; -- End stock verification
						all_the_things(index).sales_history(2 .. 12) := all_the_things(index).sales_history(1 .. 11); -- Shift sales history left by one cell
					end if; -- End product code verification  
				end Case; -- End transaction type check
			skip_line; 	-- This line of transactions has been processed, move to next line of transactions.txt to continue working
			quantity := 0;
			index := 0;	-- Reset all my values to 0 for next iteration
			new_price := 0.00; 
		end loop; -- End end_of_file loop, done reading transactions.txt
		Close (Transactions);
				
		-- Take the sales which were totalled up in the temporary variables, put them in the array for sorting
		Total_Array(1).total := accessory_sales; 
		Total_Array(2).total := jacket_sales; 
		Total_Array(3).total := pants_sales; 
		Total_Array(4).total := shirt_sales; 
		Total_Array(5).total := shoe_sales; 
		Total_Array(6).total := sweater_sales;
		
		-- Total_Array has been populated with appropriate categories and sales, needs to be sorted before moving on to Output function
		SortSales;
	end Transact;
	
	-- This procedure will output all of the newly updated data into newinventory.txt
	procedure OutputToFile is
		NewInventory		:	file_type;
		end_of_array		:	boolean := false;	-- This will test if the end of the array has been reached or not, by testing for an element with all default values
		index			:	integer := 1;		-- Index to move through my array
	begin -- Begin OutputToFile
		Create (NewInventory, Out_File, "newinventory.txt");
--		Set_Output(NewInventory);	-- For some reason I can't use Set_Output, it errors out. Set_Input works fine. I have no idea.
		while not end_of_array loop
			if all_the_things(index).product_code = "12345678" then	-- If the next product in the array has the default product code, I know I've hit the end of the populated elements.
				end_of_array := true;				-- Set the flag to true, and exit out of array
				exit;
			end if;
			put(NewInventory, all_the_things(index).product_code);
			put(NewInventory, all_the_things(index).description);
			put(NewInventory, all_the_things(index).price);
			put(NewInventory, all_the_things(index).category); put(NewInventory, " ");
			put(NewInventory, all_the_things(index).stock, width => 2);
			for n in 1 .. 12 loop
				put(NewInventory, all_the_things(index).sales_history(n), width => 3);
			end loop;
			New_line (NewInventory);
			index := index + 1;
		end loop;	
		Close (NewInventory);
	end OutputToFile;
	
	-- This procedure will output the category sales totals to the screen
	procedure OutputToScreen is
	begin
		-- Eventually this will be sorted using an array, for now I'm just outputting statically
		New_line; 
		for I in 1 .. 6 loop
			if Total_Array(I).category = ACCESSORY then -- ACCESSORY requires one fewer horizontal tabs
				put(Total_Array(I).category); Put(ASCII.ht); put("$ "); put(Total_Array(I).total); New_Line;
			else
				put(Total_Array(I).category); Put(ASCII.ht); Put(ASCII.ht); put("$ "); put(Total_Array(I).total); New_Line;
			end if;
		end loop;
	end OutputToScreen;
begin
	Populate; 	-- Populate array using inventory.txt
	Transact; 	-- Perform transactions using transactions.txt
	OutputToFile; 	-- Output new inventory information to newinventory.txt
	OutputToScreen; -- Display errors and sales total information to screen
end store;
