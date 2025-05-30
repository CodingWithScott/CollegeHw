-- package specification book_pack.ads
--
-- David Bover, WWU Computer Science, February, 2011
--
-- ADT for book_type
-- CSCI 145 lab 4

package book_pack is

	max_str : constant := 30;						-- maximum length of strings for title, author, publisher
	
	--data types for the book_type components
	subtype 	title_str 	is string(1..30);
	subtype 	year_type 	is integer range 1901..2099;
	subtype 	isbn_type is string(1..10);
	type 	dollars 	is delta 0.01 range 0.0 .. 9999.0;
	type 	format_type is (hardcover, paperback, ebook);

	book_string_length : constant := 140	;					-- the length of string returned by ToString
	
	type book_type is private;
	
	Book_Stock_Error : exception;							-- caused by a sale of more books than are in stock

	-- constructor function	
	function Book(title, author, publisher : title_str;		
	              year 		: year_type;
	              edition 	: natural;
	              isbn 		: isbn_type;
	              price 		: dollars;
	              format 	: format_type) return Book_type;

	-- accessor functions
	function Title(book : book_type) return title_str;
	function Author(book : book_type) return title_str;
	function Publisher(book : book_type) return title_str;
	function Publication_year(book : book_type) return year_type;
	function Edition(book : book_type) return natural;
	function ISBN(book : book_type) return isbn_type;
	function Price(book : book_type) return dollars;
	function Stock(book : book_type) return natural;
	function Format(book : book_type) return format_type;
	function Stock_value(book : book_type) return dollars;

	-- return a string representation of the book details
	function ToString(book : book_type) return String;


	-- operations
	procedure Set_price(book : in out book_type; new_price : dollars);
	procedure Change_stock(book : in out book_type; change : integer);  
	-- raises Book_Stock_Error if the change would make the book stock negative

private

	type book_type is record
		Title, 
		Author, 
		Publisher 	: title_str;
		Year			: year_type;
		Edition		: natural;
		Isbn			: isbn_type;
		Price		: dollars;
		Stock		: natural;
		Format		: format_type;		
	end record; 	-- book_type	

end book_pack;
