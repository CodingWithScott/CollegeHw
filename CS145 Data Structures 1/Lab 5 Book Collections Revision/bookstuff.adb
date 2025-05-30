-- bookstuff.ada
--
-- David Bover, WWU Computer Science, February, 2011
--
-- doing stuff with books
--
-- CSCI 145 Lab 4
--
-- depends on package book_pack, provided
-- depends on package book_collections, to be completed by students


with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;

with book_pack;			-- provided for Lab 4
use  book_pack;

with book_collections;	-- to be defined by students for Lab 4
use  book_collections;

procedure bookstuff is

	package dollar_io is new Fixed_IO(dollars);
	use dollar_io;

	package format_io is new Enumeration_IO(format_type);
	use format_io;
	

	-- procedure Get_Book_Info
	-- purpose:	read the information for one book from a nominated file
	procedure Get_Book_Info(infile 		: in file_type;
							title, 
							author, 
							publisher 	: out title_str;		
	              			year 		: out year_type;
	              			edition 		: out natural;
	              			isbn			: out isbn_type;
	              			price 		: out dollars;
	              			format 		: out format_type) is
		space : character;
	begin
		Get(infile, title);
		Get(infile, author);
		Get(infile, publisher);
		Get(infile, year);
		Get(infile, edition);
		Get(infile, space);
		Get(infile, isbn);
		Get(infile, price);
		Get(infile, space);
		Get(infile, format);
		Skip_line(infile);

	end Get_Book_Info;


	-- procedure Put
	-- purpose: output the contents of a collection, one book per line
	procedure Put(collection : book_collection) is
		start : positive := 1;
		text : String := ToString(collection);
	begin
		for i in 1 .. size(collection) loop
			Put_Line(text(start .. start + book_string_length - 1));
			New_Line;
			start := start + book_string_length;
		end loop;

	end Put;


	-- procedure change_price
	-- purpose: change the price of a book in a collection, searching with either ISBN for the book
	procedure try_change_price(collection : in out book_collection; isbn : isbn_type; price : dollars) is
	begin
		change_price(collection, isbn, price);
	exception
		when Book_not_found =>
			Put_line("Book with ISBN " & isbn & " not found in the collection.  Cannot change price");
	end try_change_price;


	-- procedure sale
	-- purpose: adjust the stock of this book in the collection after a sale
	procedure try_sale(collection : in out book_collection; isbn : isbn_type; quantity : natural) is
	begin
		Change_stock(collection, isbn, -quantity);
	exception
		when Book_not_found => 
			Put_line("Book with ISBN " & isbn & " not found in the collection.  Cannot process sale");
			
		when Book_Stock_Error =>
			Put_line("Book with ISBN " & isbn & " has insufficient stock for sale");
	end try_sale;


	-- procedure new_stock
	-- purpose: add to the inventory of this book
	procedure try_new_stock(collection : in out book_collection; isbn : isbn_type; quantity : natural) is
	begin
		Change_stock(collection, isbn, quantity);
	exception
		when Book_not_found => 
			Put_line("Book with ISBN " & isbn & " not found in the collection.  Cannot add to stock");
			
	end try_new_stock;

	-- procedure get_books
	-- purpose: get the books from an input file and add them to a collection
	procedure get_books(file_name : string; collection : in out book_collection) is
		book_file : file_type;
		
		-- book data components
		Title, 
		Author, 
		Publisher 	: title_str;
		Year			: year_type;
		Edition		: natural;
		Isbn			: isbn_type;
		Price		: dollars;
		Format		: format_type;		

		this_book : book_type;						-- a book
	begin
		open(book_file, in_file, file_name);
		while not End_of_file(book_file) loop
			Get_Book_Info(book_file, Title, Author, Publisher, Year, Edition, Isbn, Price, Format);
			this_book := Book(Title, Author, Publisher, Year, Edition, Isbn, Price, Format);
			Add_book(collection, this_book);
		end loop;
		Close(book_file);
	exception
		when Duplicate_book =>
			Put_line("Duplicate book, not added to the collection");	

		when Name_Error =>
			Put_Line("Input file cannot be opened for input");
	end get_books;

	-- procedure display_collection
	-- purpose: display the contents of a book collection
	procedure display_collection(collection : in book_collection; heading : in string) is
	begin
		New_Line;
		Put_Line(heading);
		for i in 1 .. heading'length loop
			Put('*');
		end loop;
		New_line;
		Put(collection);
		Put("The total value of this collection is $");
		Put(Stock_value(collection), Aft=>2);
		New_line; 
	end display_collection;

	-- procedure change_collection1
	-- purpose : do some stuff to a collection
	procedure change_collection(collection : in out book_collection) is
	begin
		try_new_stock(collection, "0061781231", 20);
		try_new_stock(collection, "0849946158", 2);
		try_new_stock(collection, "030746363X", 12);
		try_new_stock(collection, "0123456789", 1);
		try_new_stock(collection, "1400064163", 10);
		try_new_stock(collection, "0978806506", 5);
		try_new_stock(collection, "1594202842", 5);
		try_new_stock(collection, "1455503304", 2);
		try_new_stock(collection, "0929701836", 3);
		try_new_stock(collection, "0061781231", 4);
		try_change_price(collection, "159523067X", 19.99);
		try_sale(collection, "0316037915", 12);
		try_change_price(collection, "0123456789", 22.99);
		try_sale(collection, "1401324312", 1);
		try_change_price(collection, "159562015X", 17.99);
		try_sale(collection, "0929701836", 1);
	end change_collection;

	procedure modify_collection(collection : in out book_collection) is
	begin
		try_new_stock(collection, "1602861331", 1);
		try_new_stock(collection, "159523067X", 20);
		try_new_stock(collection, "030726999X", 12);
		try_new_stock(collection, "0061781231", 15);
		try_new_stock(collection, "030746363X", 10);
		try_new_stock(collection, "0316037915", 3);
		try_new_stock(collection, "1565129520", 5);
		try_sale(collection, "0385738838", 12);
		try_change_price(collection, "1101475455", 22.99);
		try_sale(collection, "0316037915", 8);
		try_change_price(collection, "159562015X", 17.99);
		try_sale(collection, "1455503304", 1);
	end modify_collection;


	Argument_Error : exception;					-- raised if something wrong with the command line arguments


	collection1 : book_collection; 	-- some collections
	collection2 : book_collection;	
	collection3 : book_collection;

begin
	-- get the booklists from the files listed on the command_line
	-- two file names are expected
	if Argument_Count /= 2 then
		raise Argument_Error;
	end if;

	-- open the first file and add each book to a collection
	get_books(Argument(1), collection1);
	put_line("Successfully got books from List1.txt");
	
	-- make some changes to the first book collection
	change_collection(collection1);
	
	-- display the first collection
	display_collection(collection1, "First collection");
	
	-- open the second file and add each book to a collection
	get_books(Argument(2), collection2);

	-- make some changes to the second book collection
	modify_collection(collection2);
	
	-- display the second collection
	display_collection(collection2, "Second collection");
	
	-- now merge the first two collections to make the third collection
	collection3 := merge(collection1, collection2);

	-- display the third collection
	display_collection(collection3, "Third collection");

exception
	when Argument_Error =>
		Put_Line("Usage: bookstuff file1 file2");

		
end bookstuff;
