-- Scott Felch
-- 5 March 2012
-- CSCI 145
-- Assignment 3. Online Store inventory tracker. This program will handle a store's inventory and backorder requirements using generics, queues, and it'll probably sort some things too.

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line;

procedure OnlineStore is
	Not_Enough_Arguments	:	exception; 	-- Exception raised if user provides fewer than 2 arguments on the command line
	Too_Many_Arguments	:	exception;	-- Exception raised if user provides more than 2 arguments on the command line
	Books_Input		:	file_type;	-- File_type for the Books.txt input file
	Transactions_Input	:	file_type;	-- File_type for the Transactions.txt input file
	
	procedure Initialize is		-- This procedure will check validity of command line arguments and open the input text files for Stock and Transactions
	begin
		-- I'll go through the Arguments and set my program's settings accordingly.
		if Argument_Count < 2 then
			raise Not_Enough_Arguments;
		elsif Argument_Count > 2 then
			raise Too_Many_Arguments;
		else
			Put("Opening Book_Input from "); put(Argument(1)); new_line;
			Open (Books_Input, In_File, Argument(1));
			Put("Opening Transactions_Input from "); put(Argument(2)); new_line;
			Open (Transactions_Input, In_File, Argument(2));
		end if; -- End Argument counter
	end Initialize;

begin -- Onlinestore
	Initialize;
exception
	when Event : Not_Enough_Arguments =>
		Put_Line ("Error: You didn't enter enough arguments! You need to have 2 command line arguments for the program to work.");
		put_line("Usage: ./onlinestore Books.txt Transactions.txt");
	when Event : Too_Many_Arguments =>
		Put_Line ("Error: You entered too many arguments! You need to have 2 command line arguments for the program to work.");
		put_line("Usage: ./onlinestore Books.txt Transactions.txt");
	when Name_Error =>
		Put_Line("Usage: You entered an invalid filename! Check you didn't spell it wrong, or maybe the file has moved.");

end OnlineStore;
