-- Scott Felch
-- 17 February 2012
-- CSCI 145 
-- Lab 5, Book Collections Body. This package provides the specifications of the ADT Book_Collection, now being implemented with a linked list instead of an array.
-- NOTE TO TA: This program works flawlessly with the bookstuff.adb found on the Winter 2011 CSCI 145 moodle page. It does NOT work with the bookstuff.adb provided
-- on the current moodle page, since the specification file requires us to remove the Collection() function, but the most recent bookstuff.adb still contains calls to
-- that function. I also still have a definition included for the Collection_full exception (which will never be raised due to now having a limitless data structure)
-- because bookstuff.adb still contains references to that as well.


with Ada.Text_Io, Ada.Integer_Text_IO;
use  Ada.Text_Io, Ada.Integer_Text_IO;

with book_pack;
use  book_pack;

package body Book_Collections is
	-- Function will return the number of books in a given book_collection by walking through the linked list and counting the number of nodes
	function Size (collection : book_collection) return natural is
	begin -- Begin Size
		return collection.length;
	end size;
	
	-- This function will check if a book currently exists in a collection 
	function ItemExists (collection : book_collection; new_book : book_type) return boolean is
		scan_ptr	:	bt_access;			-- Pointer used to scan through the list
	begin -- Begin item_exists
		scan_ptr := collection.first;				-- Set scan_ptr to 1st node in the list and begin to walk through the list
		while scan_ptr.next /= null loop
			if ISBN(scan_ptr.book) = ISBN(new_book) then	-- If an entry is found with a matching ISBN, then this book already exists in the book_collection
				return true; 				
			end if;
			scan_ptr := scan_ptr.next;			-- If current node isn't the book being searched for, walk forward one step in the list
		end loop;
		return false; -- If the entire array is searched and the new_book's ISBN isn't found, then return False, that book does not exist in this book_list
	end ItemExists;
	
	-- Finds the index value of a given book based on ISBN, and returns that index
	function Find_Item (collection : book_collection; looking_for_ISBN : ISBN_type) return positive is
		index		: 	natural := 0;			-- Number of nodes to jump through to get to the desired item, 0 indicates the first item in the list is the desired item
		scan_ptr	:	bt_access;			-- Pointer used to scan through the list
	begin -- Begin find_item
		scan_ptr := collection.first;				-- Set scan_ptr to 1nd node in the list and begin to walk through the list
		for N in 1 .. Size(Collection) loop			
			if looking_for_ISBN = ISBN(scan_ptr.book) then	-- If the current node is the book being searched for, store the index and exit the loop
				index := N;
				exit;
			end if;
			scan_ptr := scan_ptr.next;			-- If current node isn't the book being searched for, walk forward one step in the list and try again
		end loop;
		-- After finding the item, return the index value. The item will always be found since this function won't be called without first calling ItemExists.
		return index;						
	end find_item;
	
	-- Function will calculate and return the total dollar value of all the books in a collection
	function Stock_Value 	(collection : book_collection) return dollars is
		total_value	:	dollars := 0.00;		-- Accumulator for the value of all the books in the collection passed in
		scan_ptr	:	bt_access;			-- Pointer used to scan through the list
	begin -- Begin stock_value
		scan_ptr := collection.first;				-- Initialize scan_ptr to 1nd node in the list
		while scan_ptr /= null loop
			total_value := total_value + Book_Pack.Stock_Value(scan_ptr.book);	-- Add current book's value to the total value
			scan_ptr := scan_ptr.next;
		end loop;
		return total_value;
	end Stock_Value;
	
	-- This function will use the book_pack.ToString function, and return a concatenated string of all the book_pack.ToString functions of the book in the given book_collection
	-- I got help on this function from Johnny Hoffman, so it probably looks similar to his
	function ToString	(collection	: book_collection) return string is
		temp_string	:	string(1 .. (book_string_length * size(collection)));	-- Length of the string will be the length of 1 book_type * number of books in the collection
		curr_pos	:	positive := 1;						-- Current position in the string
		count		:	natural := 1;						-- Counter to keep track of iterations through the while loop
		scan_ptr	:	bt_access;						-- Pointer used to scan through the list
	begin -- Begin ToString
		scan_ptr := collection.first;		-- Set scan_ptr to 1st element in the list
		while scan_ptr /= null loop 
			-- Get string from this current book and add it to the right part of temp_string. Ie, 1st book is chars 1..140, 2nd book is 141..280, 3rd book is 281..420, etc
			temp_string(curr_pos .. (book_string_length * count)) := ToString(scan_ptr.book);	
			curr_pos := curr_pos + book_string_length;
			count := count + 1;
			scan_ptr := scan_ptr.next;
		end loop;
		return temp_string;
	end ToString;
	
	-- Procedure will change the price of a book in a collection
	procedure change_price	(collection	: in out book_collection;	-- Name of a book collection
				new_ISBN	: in ISBN_type;			-- ISBN being searched for
				new_price	: in dollars) is		-- New price to set the book to
		found 	:	boolean := false;				-- Boolean indicating whether or not the book exists in the collection
		scan_ptr	:	bt_access;				-- Pointer used to scan through the list
	begin -- Begin Change_price
		scan_ptr := collection.first;				-- Set scan_ptr to 1st element in the list and begin to walk through
		while scan_ptr.next /= null loop			-- Otherwise begin walking through the list to find the book
			if ISBN(scan_ptr.book) = new_ISBN then
				Set_Price(scan_ptr.book, new_price);
				found := true;
			end if;
			scan_ptr := scan_ptr.next;
		end loop; -- If the loop completes without finding the right book and changing its price, set Found to false and raise exception

		if not found then
			raise Book_not_found;
		end if;
	end change_price;
	
	-- Procedure will add or subtract from the available stock of a book in a collection
	procedure change_stock	(collection	: in out book_collection;	-- Name of a book collection
				look_for_ISBN	: in ISBN_type;			-- ISBN being searched for
				amount_changed	: in integer) is		-- Number of copies of a book to add or subtract
		found 		:	boolean := false;			-- Boolean indicating whether or not the book exists in the collection
		scan_ptr	:	bt_access;				-- Pointer used to scan through the list
	begin -- Begin Change_stock
		scan_ptr := collection.first;					-- Set scan_ptr to 1st element in the list and begin to walk through
		while scan_ptr /= null loop
			if ISBN(scan_ptr.book) = look_for_ISBN then
				Change_Stock(scan_ptr.book, amount_changed);
				found := true;
			end if;
			scan_ptr := scan_ptr.next;
		end loop; -- If the loop completes without finding the right book and changing its price, Found is still set to false and will raise an exception

		if not found then
			raise Book_not_found;
		end if;
	end change_stock;
	
	-- Procedure will add a book to a given collection
	procedure add_book 	(collection	: in out book_collection;	-- Name of book collection to be added to
				book		: in book_type) is		-- Book to be added
		new_node	:	bt_access;				-- Node to be appended to the end of the list
		scan_ptr	:	bt_access;				-- Node to scan through collection
	begin -- Begin add_book
		if Size(collection) = 0 then				-- If collection is empty then I need to set book_collection to point to my first node
			new_node := new book_node'(book, null);			-- Create a new node containing the input book, and a pointer to null
			collection.first := new_node;				-- Set collection.first pointer to point to the new node
			collection.length := collection.length + 1;		-- Increment size of book_collection by 1 book
		else							-- If collection is larger than 1, check to see there's not already an entry in the collection for this given book			
			if ItemExists(collection, book) then		
				raise Duplicate_book;
			end if; -- End ItemExists check
		
			collection.length := collection.length + 1;		-- Increment size of book_collection by 1 book
			new_node := new book_node'(book, null);			-- Create a new node containing the input book, and a pointer to null
			scan_ptr := collection.first;				-- Scan_ptr is set to the first element in the list...
			while scan_ptr.next /= null loop			-- ...walk through the list until reaching the last node...
				scan_ptr := scan_ptr.next;
			end loop;
			scan_ptr.next := new_node;				-- ...and set the last node to point to the newly created node, so new_node is now the last node in the list.
		end if; -- End length check
	end add_book;
	
	-- Function will take two collections and merge them together. If any book is found in both collections, only one instance shall be in the resulting collection, with the sum of the available stock,
	-- and price set to whichever of the two prices is lower. 
	function merge 		(collection1	: in book_collection;	-- Name of first book_collection being passed in
				 collection2 	: in book_collection) 	-- Second book_collection being passed in
				return book_collection is
			collection3		: book_collection;	-- Collection3, to be filled with values from both collection1 and collection2, then returned at the end
			scan_ptr		: bt_access;		-- Pointer used to scan through source linked lists
			write_ptr		: bt_access;		-- Current node being looked at in destination list
	begin -- Begin merge
		---- Step 1: take all the books from Collection1 and put them in Collection3
		scan_ptr := collection1.first;				-- Set scan_ptr to the beginning of collection1, to start reading through
		while scan_ptr /= null loop
			Add_Book(collection3, scan_ptr.book);		-- Assign the current book from source list (scan_ptr) to the destination list (curr)
			scan_ptr := scan_ptr.next;			-- Increment scan_ptr one step
		end loop;
		
		-- Step 2: go through Collection2 and see if each book exists in Collection3.
		-- For items that don't already exist in collection2, they'll be added to the end of Collection3. For items that do exist, 
		-- the stock of the two will be added together and the price set to whichever of the two prices is lower.
		scan_ptr := collection2.first;	-- Set scan_ptr to point to the beginning of collection2
		write_ptr := collection3.first;	-- Set write_ptr to beginning of collection3 again
		while scan_ptr /= null loop
			if not ItemExists(collection3, scan_ptr.book) then	-- Check destination (collection3) if current book (scan_ptr.book) is already present
				Add_Book(collection3, scan_ptr.book);		-- If current book in Collection2 (scan_ptr) doesn't exist in Collection3 already, append it to the end of Collection3
				write_ptr := collection3.first;			-- Set write_ptr to beginning of collection3 again
			else						-- Otherwise follow procedure for merging two books
				-- Call Change_Stock, changing collection3, with the book matching ISBN of current book in collection2, adding the amount of stock in collection2
				Change_Stock(collection3, ISBN(scan_ptr.book), Stock(scan_ptr.book));
				
				while ISBN(write_ptr.book) /= ISBN(scan_ptr.book) loop		-- Find the current book in the destination list
					write_ptr := write_ptr.next;
				end loop;

				if Price(scan_ptr.book) < Price(write_ptr.book) then		-- If Collection2 (scan_ptr) has a lower price than the existing price, set Collection3 price to Collection2 price
					Set_Price(write_ptr.book, Price(scan_ptr.book));
				end if; -- End lower_price checker

			end if; -- End ItemExists if statement
			write_ptr := collection3.first;						-- Reset write pointer to the beginning of the list again
			scan_ptr := scan_ptr.next;						-- Increment read pointer to the next node
		end loop; -- End reading through collection2
		-- Now if all that worked correctly, any books in collection2 will be added to or merged with collection1, and stored in temp_collection, which is then returned
		return collection3;
	end merge;
	
end Book_Collections;
