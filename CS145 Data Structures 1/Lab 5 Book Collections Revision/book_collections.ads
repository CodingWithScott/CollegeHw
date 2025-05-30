-- Scott Felch
-- 17 February 2012
-- CSCI 145 
-- Lab 5, Book Collections Specification. This package provides the specifications of the ADT Book_Collection, now being implemented with a linked list instead of an array.

with Book_Pack;
use  Book_Pack;

package Book_Collections is
	MAX_BOOKS 	:	constant := 200;	-- Maximum number of books in a Book_Collection, as provided in lab specification file
	Book_not_found 	:	exception;		-- Custom exception raised if a book being searched for doesn't exist
	Collection_full :	exception;		-- Custom exception raised if a user tries to add books to a collection that's full of books already
	Duplicate_book 	:	exception;		-- Custom exception raised if a user tries to add a book which already exists
	
	-- Book_collection ADT is private, NO LOOKING!!! Defined at bottom of this file.
	type book_collection is private;
	
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
	type book_node; 
	type bt_access is access book_node;	-- BT_Access (book_type access) is a pointer that lets me have a linked list of book_nodes

	type book_node is record		-- One book node will contain a book, and a pointer to the next book node
		book	:	book_type;
		next	:	bt_access := null;
	end record;
	
	-- Book_collection is a record containing a pointer to the first node of a linked list, and a natural to indicate current length of the book_collection
	type book_collection is record 			-- Book_collection holds a pointer to the first book_node in the linked list, and the current length of the list
		first	:	bt_access := null;	-- Set to null by default, will be initialized later
		length	:	natural := 0;		-- Set to 0, will be incremented each time Add_Book successfully adds a book
	end record;


end Book_Collections;
