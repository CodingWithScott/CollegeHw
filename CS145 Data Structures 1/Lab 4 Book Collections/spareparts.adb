Spare parts
---------------------------

function get_one_book(file_name : string) return book_type is
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
		Get_Book_Info(book_file, Title, Author, Publisher, Year, Edition, Isbn, Price, Format);
		this_book := Book(Title, Author, Publisher, Year, Edition, Isbn, Price, Format);
	Close(book_file);
	return this_book;
end get_one_book;

testbookstring : string(1 .. book_string_length);
testbook : book_type;

	testbook := get_one_book(Argument(1));
	testbookstring := ToString(testbook);
	
	put(testbookstring); new_line;
