with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Characters.Handling, Ada.Exceptions; 
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Characters.Handling, Ada.Exceptions; 

Procedure letter_count is
--==Float_IO Packages
	type data is delta 0.001 range 0.0 .. 10000000.0; --Floating point data type
	package data_IO is new Fixed_IO(data);
		use data_IO;  
--==Custom Exceptions
	No_input : exception;
--==File Types
	Input : File_type; 
--==Arrays
	type count_array is array(character range 'A' .. 'Z') of data; 
	freq : count_array := (others => 0.0);
--==Data Variables
	totalCount : Data := 0.0;
	
	
--============================================================	
--Procedures--
--Skip_spaces skips over white space which includes spaces tabs and end of line
--============================================================
	Procedure Skip_spaces is
	--Look-ahead scans for a character and returns a true or false if it has reached the end of a line.
		Next : Character;
		EndLine : Boolean;
	begin
	--check what the next character is
	Look_ahead(Next, EndLine);

	--if character is space, tab, or end of line then
	while Next = ' ' or Next = ASCII.ht or EndLine = true 
		loop
			if EndLine = true then
				Skip_line;
			else
				Get(Next);
			end if; 
			Look_ahead(Next, EndLine); 
		end loop;
	end Skip_spaces; 

--countLetters, Counts the number of occurances of letters in a file
--============================================================
	Procedure countLetters (File_Name : in String)  is
	myChar : character;
	next : character;
	endline : boolean;
	begin
	--Open File
		Open(Input, In_File, File_Name);
		Set_Input(Input); --Set default input to my custom file variable type.
	--Get characters
		while not End_of_File loop
			Look_ahead(next, endline);
			if endline then
				skip_line;
			else 	
				get(myChar);
			end if; 

			--Put("char gotten");
		if mychar in 'a'..'z' or mychar in 'A'..'Z' then 
			if Is_Lower(myChar) then
				--Put("Upper conversion."); 
				myChar := To_Upper(myChar); 
			end if; 

				--Put("Occurance noted."); 
				freq(myChar) := freq(myChar) + 1.0;
				totalCount := totalCount + 1.0;
		end if;
		end loop; 
	--Close File
		Close(Input);

	end countLetters;

--Display, Puts the results of counting the letters onto the screen
--============================================================
	Procedure Display is
		value : data := 0.0;
	begin
	
	for I in freq'Range loop
		Put("The character "); Put(I); Put(" occured ");
		value := freq(I) / totalCount;   
		 Put(freq(I)); --Put(value);
		Put(" times.");
		Put (" "); Put(value); Put(" of"); Put(totalcount); Put(" letters."); 
		New_Line;
	end loop;

	end Display; 
--============================================================
--Main Program
--============================================================	
begin
	if Ada.Command_Line.Argument_Count = 0 then
	--raise error
		raise No_input with "You must provide file names to evalute on the command line when you run the executable. (./letter_count ''Data1.txt Data2.txt Data3.txt'' etc.)"; 
	else
	--main body
		for I in 1 .. Ada.Command_Line.Argument_Count loop
			Put_Line("Starting Evaluation of " & Ada.Command_Line.Argument(I) );
			countLetters(Ada.Command_Line.Argument(I));
			Put_Line(Ada.Command_Line.Argument(I) & " passed."); 
		end loop;  
	end if; 

	Display; 
Exception
	when NAME_ERROR =>
		Put ("The file specified does not exist.");
	when Event : No_input =>
		Put_Line(Exception_Message(Event));
		Put_Line("Program is Terminating");  
 
end letter_count; 
