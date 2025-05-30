-- bookstats.ada
--
-- David Bover, WWU Computer Science, February, 2011
--
-- statistics and sorting of a list of books
--
-- CSCI 145 Lab 6
--
-- depends on package book_pack, provided
-- depends on generic procedure gen_sort, provided
-- depends on generic function gen_average, to be completed by students


with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;

with book_pack;			-- provided for Lab 4, 5, 6
use  book_pack;

with gen_sort;			-- provided for Lab 6

with gen_average;		-- to be defined by students for Lab 6

procedure bookstats is

	max_books : constant := 100; 									-- the maximum number of books
	type Book_array is array(positive range <>) of book_type;		-- the array type for generics

	type book_list is record											-- the element type for generics
		contents : Book_array(1..max_books);
		how_many : natural := 0;
	end record;
	
	package dollar_io is new Fixed_IO(dollars);
	use dollar_io;

	package format_io is new Enumeration_IO(format_type);
	use format_io;


	-- procedure Get_Book_Info
	-- purpose:	read the information for one book from a nominated file
	procedure Get_Book_Info(infile 			: in file_type;
					title, 
					author, 
					publisher 	: out title_str;		
	              			year 		: out year_type;
	              			edition 	: out natural;
	              			isbn		: out isbn_type;
	              			price 		: out dollars;
	              			stock 		: out natural;
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
		Get(infile, stock);
		Get(infile, space);
		Get(infile, format);
		Skip_line(infile);

	end Get_Book_Info;

	-- procedure get_books
	-- purpose: get the books from an input file and add them to a collection
	procedure get_books(file_name : string; list : in out book_list) is
	
		book_file : file_type;
		
		-- book data components
		Title, 
		Author, 
		Publisher 	: title_str;
		Year			: year_type;
		Edition		: natural;
		Isbn			: isbn_type;
		Price		: dollars;
		Stock		: natural;
		Format		: format_type;		

		this_book : book_type;						-- a book
	begin
		open(book_file, in_file, file_name);
		while not End_of_file(book_file) loop

			-- get the book information
			Get_Book_Info(book_file, Title, Author, Publisher, Year, Edition, Isbn, Price, Stock, Format);
			this_book := Book(Title, Author, Publisher, Year, Edition, Isbn, Price, Format);
			Change_stock(this_book, Stock);

			-- add this book to the book list
			if list.how_many < max_books then
				list.how_many := list.how_many + 1;
				list.contents(list.how_many) := this_book;
			else
				exit;		-- the book list is full so ignore the rest
			end if;
			
		end loop;
		
		Close(book_file);
		
	exception

		when Name_Error =>
			Put_Line("Input file cannot be opened for input");
			
	end get_books;
	
	-- procedure display
	-- purpose:	display the details of books from a book list
	procedure display(list : in book_list) is
	begin
		for i in 1 .. list.how_many loop
			Put(toString(list.contents(i)) & "$");
			Put(stock_value(list.contents(i)), fore=>0, aft=>2);
			New_line;
		end loop;
	end display;
	
--==============================================================================================================--
--	My nifty bunch of overloaded math operators for use in the instantiations of my Gen_Average function	--
--==============================================================================================================--
	function PriceAdd(Left : book_type; Right : dollars) return dollars is		-- Adding prices of books for computing average
	begin	-- Left = price of current book being looked at, Right = running total of value of all the books
		return price(Left) + right;
	end PriceAdd;
	
	function StockAdd(Left : book_type; Right : natural) return natural is		-- Adding stock of books 
	begin	-- Left = stock of current book, Right = running total of stock
		return stock(Left) + right;
	end StockAdd;
	
	function StockValueAdd(Left : book_type; Right : dollars) return dollars is	-- Adding stock value of books
	begin	-- Left = stock value of current book, Right = running total of stock_value
		return (stock_value(left)) + right;	-- Add stock_value of current book to the running total of stock_value and return
	end StockValueAdd;
--------------------------------------------------------------------- End of addition functions -------------------------------------------------------------------
	function PriceSubtract(Left : dollars; Right : dollars) return dollars is	-- Subtracting dollars from dollars, when setting sum to 0 in PriceAverage
	begin	
		return left - right;
	end PriceSubtract;
	
	function StockSubtract(Left : natural; Right : natural) return natural is	-- Subtracting natural from natural, when setting sum to 0 in StockAverage
	begin	
		return left - right;
	end StockSubtract;
	
	function StockValueSubtract(Left : dollars; Right : dollars) return dollars is	-- Subtracting dollars from dollars, when setting sum to 0 in StockValueAverage
	begin	
		return left - right;
	end StockValueSubtract;
--------------------------------------------------------------------- End of subtraction functions -------------------------------------------------------------------
	function PriceDivide(Left : dollars; Right : natural) return dollars is		-- Dividing total price of books by number of books
	begin	-- Left = Total value of books, Right = running total of how many books
		return Left / dollars(right);
	end PriceDivide;
	
	function StockDivide(Left : natural; Right : natural) return natural is		-- Dividing total number of books on hand by how many unique books
	begin	-- Left = Total copies of books, Right = how many ISBNs there are
		return left / right;
	end StockDivide;
	
	function StockValueDivide(Left : dollars; Right : natural) return dollars is	-- Dividing total stock value of each individual book by how many unique books
	begin	-- Left = Total value of books, Right = running total of ISBNs
		return left / dollars(right);
	end StockValueDivide;
--------------------------------------------------------------------- End of division functions -------------------------------------------------------------------
--===============================================================================================================================================================--
--====================================================  Comparison functions for different data types  ==========================================================--
--===============================================================================================================================================================--	
	function ISBN_less (Left, Right : book_type) return boolean is
	begin
		if ISBN(Left) < ISBN(Right) then
			return true;
		end if;
		return false;
	end ISBN_less;
	
	function Price_less (Left, Right : book_type) return boolean is
	begin 
		if price(Left) < price(Right) then
			return true;
		end if;
		return false;
	end Price_less;
	
	function Stock_less (Left, Right : book_type) return boolean is
	begin
		if stock(Left) > stock(Right) then
			return true;
		end if;
		return false;
	end Stock_less;
	
	function StockValue_less (Left, Right : book_type) return boolean is
	begin
		if stock_value(Left) > stock_value(Right) then
			return true;
		end if;
		return false;
	end StockValue_less;

--===============================================================================================================================================================--
--================================================  Instantiaion of the three different Average functions  ======================================================--
--===============================================================================================================================================================--	
	function PriceAverage is new gen_average (Item_Type => book_type,	
                                                  Index_Type => positive,
                                                Array_Type => book_array,
                                                 Average_Type => dollars,		-- Dollars because keeping track of average prices of books
						         "+" => PriceAdd,
						    "-" => PriceSubtract,
						     "/" => PriceDivide);
                                                  
          function StockAverage is new gen_average (Item_Type => book_type,
                                                    Index_Type => positive,
                                                  Array_Type => book_array,
                                                   Average_Type => natural,		-- Natural because it's keeping track of how many copies of books there are
               		                                   "+" => StockAdd,
						      "-" => StockSubtract,
					               "/" => StockDivide);

          function StockValueAverage is new gen_average (Item_Type => book_type,
							 Index_Type => positive,
						       Array_Type => book_array,
						        Average_Type => dollars,	-- Dollars because it's keeping track of average value of each stock
							   "+" => StockValueAdd,
						      "-" => StockValueSubtract,
						       "/" => StockValueDivide);
						       
--===============================================================================================================================================================--
--==================================================  Instantiaion of the four different Sort functions  ========================================================--
--===============================================================================================================================================================--

	-- Sort books in ascending order of ISBN using string comparisons
	procedure ISBN_SortAsc is new gen_sort(Item_Type =>   book_type,	-- Book_types are the items being compared in the sort, in the custom "less than" functions it compares contents within book_types
	   				     Index_Type  =>    positive,	-- Index of array is positive integers
					     Array_Type   => book_array,	-- Array being sorted is a book_array
					     	      "<" => ISBN_Less);	-- My custom defined "less than" function
				  
	-- Sort books in ascending order of price using fixed point comparisons
	procedure PriceSortAsc is new gen_sort(Item_Type  =>  book_type,	-- Book_types are the items being compared in the sort, in the custom "less than" functions it compares contents within book_types
					       Index_Type =>   positive,	-- Index of array is positive integers
 					    Array_Type   =>  book_array,	-- Array being sorted is a book_array
 					    	     "<" => Price_less);	-- My custom defined "less than" function
 					    
	-- Sort books in descending order of stock
	procedure StockSortDesc is new gen_sort(Item_Type => book_type,		-- Book_types are the items being compared in the sort, in the custom "less than" functions it compares contents within book_types
					       Index_Type =>  positive,		-- Index of array is positive integers
 					      Array_Type => book_array,		-- Array being sorted is a book_array
 					    	    "<" => Stock_less);		-- My custom defined "less than" function
 					    
	-- Sort books in descending order of stock value
	procedure StockValSortDesc is new gen_sort(Item_Type => book_type,	-- Book_types are the items being compared in the sort, in the custom "less than" functions it compares contents within book_types
					          Index_Type =>  positive,	-- Index of array is positive integers
 					         Array_Type => book_array,	-- Array being sorted is a book_array
 					          "<" => StockValue_less);	-- My custom defined "less than" function

	Argument_Error : exception;	-- raised if something wrong with the command line arguments

	list : book_list;

begin
	-- get the booklists from the files listed on the command_line
	-- two file names are expected
	if Argument_Count /= 1 then
		raise Argument_Error;
	end if;

	-- open the first file and add each book to a collection
	get_books(Argument(1), list);

	-- display the book list as input
	New_line;
	Put_line("The original list");
	Put_line("-----------------");
	display(list);
	New_line;

	-- sort the book list on ISBN and display
	-- ****** call your ISBN sort procedure here (sort in ascending order of ISBN) ******
	Put_line("Sorted in ascending order of ISBN");
	Put_line("---------------------------------");
	ISBN_SortAsc(list.contents(1 .. list.how_many));
	display(list);
	New_line;

	-- sort the book list on price and display
	-- ****** call your price sort procedure here (sort in ascending order of price) ******
	Put_line("Sorted in ascending order of price");
	Put_line("----------------------------------");
	PriceSortAsc(list.contents(1 .. list.how_many));
	display(list);
	New_line;
	
	-- find the average price of the books in list
	Put("Average book price is $");
	-- ****** call your average_price function here and display the result ******
	put(PriceAverage(list.contents(1 .. list.how_many)));
	New_line;
	New_line;

	-- sort the book list on stock and display
	-- ****** call your stock sort routine here (sort in descending order of stock) ******
	Put_line("Sorted in descending order of stock");
	Put_line("-----------------------------------");
	StockSortDesc(list.contents(1 .. list.how_many));
	display(list);
	New_line;

	-- find the average stock of the books in list
	Put("Average book stock is ");
	-- ****** call your average_stock function here and display the result ******
	Put(StockAverage(list.contents(1 .. list.how_many)));
	New_line;
	New_line;

	-- sort the book list on stock value and display
	-- ****** call your stock_value sort procedure here (sort in descending order of stock value) ******
	Put_line("Sorted in descending order of stock value");
	Put_line("-----------------------------------------");
	StockValSortDesc(list.contents(1 .. list.how_many));
	display(list);
	New_line;
	
	-- find the average stock value of the books in the list
	Put("Average stock value is $");
	-- ****** call your average_stock_value function here and display the result ******
	put(StockValueAverage(list.contents(1 .. list.how_many)));
	New_line;
	New_line;	

exception
	when Argument_Error =>
		Put_Line("Usage: bookstats filename");

		
end bookstats;
