-- package body book_pack.adb
--
-- David Bover, WWU Computer Science, February, 2011
--
-- ADT for book_type
-- CSCI 145 lab 4

with Ada.Text_Io, Ada.Integer_Text_IO;
use  Ada.Text_Io, Ada.Integer_Text_IO;

package body book_pack is

	-- I/O package for the book price
	package dollar_io is new Fixed_IO(dollars);
	use dollar_io;

	-- I/O package for the book format
	package format_io is new Enumeration_IO(format_type);
	use format_io;

	
	-- constructor function	
	function Book(title, author, publisher : title_str;		
	              year 		: year_type;
	              edition 	: natural;
	              isbn	 	: isbn_type;
	              price 	: dollars;
	              format 	: format_type) return Book_type is
	              
		new_book : book_type := (title, author, publisher, year, 
		                         edition, isbn, price, 0, format);
	begin
		return new_book;
	end Book;


	-- accessor functions

	-- book title
	function Title(book : book_type) return title_str is
	begin
		return book.Title;
	end Title;

	-- book author
	function Author(book : book_type) return title_str is
	begin
		return book.Author;
	end Author;

	-- book publisher
	function Publisher(book : book_type) return title_str is
	begin
		return book.Publisher;
	end Publisher;

	-- book year of publication
	function Publication_year(book : book_type) return year_type is
	begin
		return book.Year;
	end Publication_year;

	-- book edition
	function Edition(book : book_type) return natural is
	begin
		return book.Edition;
	end Edition;

	-- book International Standard Book Number (ISBN)
	function ISBN(book : book_type) return isbn_type is
	begin
		return book.Isbn;
	end ISBN;

	-- book price
	function Price(book : book_type) return dollars is
	begin
		return book.Price;
	end;

	-- book stock on hand
	function Stock(book : book_type) return natural is
	begin
		return book.Stock;
	end Stock;

	-- book format
	function Format(book : book_type) return format_type is
	begin
		return book.Format;
	end Format;

	-- book stock value
	function Stock_value(book : book_type) return dollars is
	begin
		return dollars(book.stock) * book.Price;
	end Stock_value;


	-- return a string representation of the book details, exactly book_string_length characters long
	function ToString(book : book_type) return String is
		Price_str, format_str : String(1..10) := (others=>' ');
		result : String(1 .. book_string_length) := (others=>' ');
	begin
		Put(To=>price_str, Item=>book.Price, Aft=>2);
		Put(To=>format_str, Item=>book.Format);

		declare
			text : String := book.Title & book.Author & book.Publisher & Integer'image(book.Year) &
				             " " & book.Isbn & " $" & Price_str & " " & Integer'image(book.Stock) & " " & format_str;
			length : natural := text'length;
		begin
			result(1..length) := text;
		end;
		
		return result;
					
	end ToString;


	-- operations

	-- set the price of the book
	procedure Set_price(book : in out book_type; new_price : dollars) is
	begin
		book.Price := new_price;
	end Set_price;

	-- change the stock level of the book
	procedure Change_stock(book : in out book_type; change : integer) is
	begin
		if book.Stock + change < 0 then
			raise Book_Stock_Error;
		end if;
		
		book.stock := book.Stock + change;
	end Change_stock;


end book_pack;
