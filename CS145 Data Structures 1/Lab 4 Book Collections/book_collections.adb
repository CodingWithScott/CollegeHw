-- Scott Felch
-- 17 February 2012
-- CSCI 145 
-- Lab 4, Book Collections Body. This package provides the body of the ADT Book_Collection.

with Ada.Text_Io, Ada.Integer_Text_IO;
use  Ada.Text_Io, Ada.Integer_Text_IO;

with book_pack;
use  book_pack;

package body Book_Collections is
	-- Function will return a new book_collection type with all default values, except for the limit of books in the collection, which can be user defined. Otherwise defaults to Max_Books (see .ads declaration)
	function Collection (limit : in positive) return book_collection is
		new_collection	:	book_collection;
	begin -- Begin Collection
		new_collection.book_limit := limit;
		return new_collection;
	end collection;
	
	-- Function will return the number of books in a given book_collection
	function Size (collection : book_collection) return natural is
		collection_size	:	natural := collection.curr_size;			-- Number of books in the book_collection that was passed in
	begin -- Begin Size
		return collection_size;
	end size;
	
	-- This function will check if a book currently exists in a collection 
	function ItemExists (collection : book_collection; new_book : book_type) return boolean is
		index		: 	positive;
	begin -- Begin item_exists
		for N in 1 .. collection.curr_size loop
			if ISBN(collection.book_array(N)) = ISBN(new_book) then
				index := N;
				return true; -- If an entry is found with a matching title, then this book already exists in the book_collection
			end if;
		end loop;
		return false; -- If the entire array is searched and the new_book's title isn't found, then return False, that book does not exist in this book_collection
	end ItemExists;
	
	-- Finds the index value of a given book based on ISBN, and returns that index
	function Find_Item (collection : book_collection; looking_for_ISBN : ISBN_type) return positive is
		index		:	positive := 1;
	begin -- Begin find_item
		for N in 1 .. size(collection) loop
			if looking_for_ISBN = ISBN(collection.book_array(N)) then
				index := N;
				exit;
			end if;
		end loop;
		return index;
	end find_item;
	
	-- Function will calculate and return the total dollar value of all the books in a collection
	function Stock_Value 	(collection : book_collection) return dollars is
		total_value	:	dollars := 0.00;		-- Accumulator for the value of all the books in the collection passed in
	begin -- Begin stock_value
		for N in 1 .. Size(collection) loop
			total_value := total_value + Book_Pack.Stock_Value(collection.book_array(N));
		end loop;
		return total_value;
	end Stock_Value;
	
	-- This function will use the book_pack.ToString function, and return a concatenated string of all the book_pack.ToString functions of the book in the given book_collection
	-- I got help on this function from Johnny Hoffman, so it probably looks similar to his
	function ToString	(collection	: book_collection) return string is
		temp_string	:	string(1 .. (book_string_length * size(collection)));	-- Length of the string will be the length of 1 book_type * number of books in the collection
		curr_pos	:	positive := 1;						-- Current position in the string
	begin -- Begin ToString
		for count in 1 .. (size(collection)) loop
			temp_string(curr_pos .. (book_string_length * count)) := ToString(collection.book_array(count));
			curr_pos := curr_pos + book_string_length;
		end loop;
		return temp_string;
	end ToString;
	
	-- Procedure will change the price of a book in a collection
	procedure change_price	(collection	: in out book_collection;	-- Name of a book collection
				new_ISBN	: in ISBN_type;			-- ISBN being searched for
				new_price	: in dollars) is		-- New price to set the book to
		found 	:	boolean := false;				-- Boolean indicating whether or not the book exists in the collection
	begin -- Begin Change_price
		for N in 1 .. size(collection) loop
			if ISBN(collection.book_array(N)) = new_ISBN then
				Set_Price(collection.book_array(N), new_price);
				found := true;
			end if;
		end loop; -- If the loop completes without finding the right book and changing its price, set Found to false and raise exception

		if not Found then
			raise Book_not_found;
		end if;
	end change_price;
	
	-- Procedure will add or subtract from the available stock of a book in a collection
	procedure change_stock	(collection	: in out book_collection;	-- Name of a book collection
				look_for_ISBN	: in ISBN_type;			-- ISBN being searched for
				amount_changed	: in integer) is		-- Number of copies of a book to add or subtract
		found 	:	boolean := false;				-- Boolean indicating whether or not the book exists in the collection
	begin -- Begin Change_stock
		for N in 1 .. size(collection) loop
			if ISBN(collection.book_array(N)) = look_for_ISBN then
				Change_Stock(collection.book_array(N), amount_changed);
				found := true;
			end if;
		end loop; -- If the loop completes without finding the right book and changing its price, set Found to false and raise exception

		if not Found then
			raise Book_not_found;
		end if;
		
	end change_stock;
	
	-- Procedure will add a book to a given collection
	procedure add_book 	(collection	: in out book_collection;	-- Name of book collection to be added to
				book		: in book_type) is		-- Book to be added
		new_book 	: book_type := book;			-- Temporary book_type, will be added to the book_collection
	begin -- Begin add_book
		if Size(collection) = collection.book_limit then	-- Check to see there's an empty spot in the collection
			raise Collection_full;
		end if; -- End Empty check
		
		if ItemExists(collection, new_book) then		-- Check to see there's not already an entry for this book in the collection
			raise Duplicate_book;
		end if; -- End ItemExists check
		
		collection.curr_size := collection.curr_size + 1;	-- Increment the amount of books in the collection, final entry is empty and ready for new_book
		collection.book_array(collection.curr_size) := new_book;		-- Add a new book to the end of the current array
	end add_book;
	
	-- Function will take two collections and merge them together. If any book is found in both collections, only one instance shall be in the resulting collection, with the sum of the available stock,
	-- and price set to whichever of the two prices is lower. 
	function merge 		(collection1	: in book_collection;	-- Name of first book_collection being passed in
				 collection2 	: in book_collection) 	-- Second book_collection being passed in
			return book_collection is
			collection3		: book_collection;	-- Collection3, to be filled with values from both collection1 and collection2, then returned at the end
			lower_price		: dollars;		-- Variable which will hold the lower of the two prices for books
			item1_location		: natural;
	begin -- Begin merge
		-- First I take all the books from Collection1 and put them in Collection3
		for count in 1 .. size(collection1) loop
			collection3.curr_size := collection3.curr_size + 1;
			collection3.book_array(count) := collection1.book_array(count);
		end loop;
		
		-- Next I'll go through Collection2 and see if each book exists in Collection3
		for count in 1 .. size(collection2) loop
			if ItemExists(collection3, collection2.book_array(count)) then	-- If the current book in Collection 2 already exists in Collection3, I'll find which has a lower price
				item1_location := find_item(collection3, ISBN(collection2.book_array(count)));	-- Find where in Collection3 this same ISBN is located
				if Price(collection3.book_array(item1_location)) < Price(collection2.book_array(count)) then
					lower_price := Price(collection3.book_array(item1_location));		-- Check to see if Collection3 has the lower price
				else
					lower_price := Price(collection2.book_array(count));			-- Or if Collection2 has lower price
				end if; -- End lower_price checker
				
				Set_Price(collection3.book_array(item1_location), lower_price);			-- Set Price of this book to whichever price was lower
				-- Change stock of book in Collection3 to add the amount in stock of Collection2
				Change_Stock(collection3, ISBN(collection2.book_array(count)), Stock(collection2.book_array(count)));
			else	-- If current book in Collection2 doesn't exist in Collection3 already, append it to the end
				Add_Book(collection3, collection2.book_array(count));
			end if; -- End ItemExists if statement
		end loop; -- End reading through collection2
		
		-- Now if all that worked correctly, any books in collection2 will be added to or merged with collection1, and stored in temp_collection, which is then returned
		return collection3;
	end merge;
	
end Book_Collections;
