-- Scott Felch
-- 17 February 2012
-- CSCI 145 
-- Lab 4, Book Collections Specification. This package provides the specifications of the ADT Book_Collection.

with Book_Pack;
use  Book_Pack;

package Book_Collections is

	Max_Books 	:	constant := 200;	-- Maximum number of books in a Book_Collection, as provided in lab specification file
	Book_not_found 	:	exception;		-- Custom exception raised if a book being searched for doesn't exist
	Collection_full :	exception;		-- Custom exception raised if a user tries to add books to a collection that's full of books already
	Duplicate_book 	:	exception;		-- Custom exception raised if a user tries to add a book which already exists
	
	-- Book_collection ADT is private, NO LOOKING!!! Defined at bottom of this file.
	type book_collection is private;
	type book_array_type is array (1 .. Max_Books) of book_type;
	
	
	function collection (limit 	: in positive) return book_collection;	-- Function receives a limit on how big of a collection to make, and returns an empty book_collection instance
	function size (collection 	: book_collection) return natural;	-- This function will return the number of books in a given collection		
	function stock_value (collection: book_collection) return dollars;	-- This function will return the total dollar value of all the books in a collection
	
	-- This function will receive two book_collections and merge the contents into a single book_collection
	function merge (collection1 	: book_collection; collection2 : book_collection) return book_collection;
	function ToString (collection 	: book_collection) return string;	-- This function will return the concatenated strings of all the values for all the books in the collection

	
	-- This procedure will find an ISBN in a book_collection and then change the price for it
	procedure change_price(	collection	: in out book_collection;	-- Name of a book collection
				new_ISBN	: in ISBN_type;			-- ISBN being searched for
				new_price	: in dollars);			-- New price to set the book to
	
	-- The procedure will find an ISBN in a book collection and chnage the number of copies in stock
	procedure change_stock( collection	: in out book_collection;	-- Name of a book collection
				look_for_ISBN	: in ISBN_type;			-- ISBN being searched for
				amount_changed	: in integer);			-- New value for number of copies of the book

	-- This procedure will read in a book_collection and a book_type and add that book to the collection, if there is room. If there is no room, Collection_full will be raised, or Duplicate_book
	-- if that book already exists.
	procedure add_book ( collection		: in out book_collection;	-- Collection the book is to be added to
				book		: in book_type);		-- Book_type that is to be added
				
private -- This part is private, DON'T LOOK!!! 
	-- Book_collection is a record containing an array to hold all the book_types, and integers to indicate current number of books and user specified limit of books in this collection
	type book_collection (Maximum 	: 	positive := Max_Books) is record	
		book_array		:	book_array_type;		-- An array of book_type to hold all the data about books in this collection.
		book_limit		:	positive := maximum;		-- Limit to number of books in the collection, will default to 200 books but user can set it lower if they wish.
		curr_size		:	natural := 0;			-- Current number of books in the collection, starts at 0 and will be incremented as necessary.
	end record; 	
				
end Book_Collections;
