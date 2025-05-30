-- Scott Felch
-- 15 January 2012
-- CSCI 145, Lab 1
-- This program will accept inputted data and encrypt it using the Vigenere Cypher algorithm, or decrypt it. The program will accept 2-4 command line arguments,
-- first one being the encryption keyword, second one being an E or a D to flag whether encrypting or decrypting, third one (optional) name of text file to read 
-- input from, fourth one (optional) name of text file to write output to. I/O redirection commands could also be used at command line instead. 

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions, Ada.Characters.Handling;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions, Ada.Characters.Handling;

procedure Vigenere is
	Not_Enough_Arguments	:	exception;		-- Custom exception which will be raised if user enters less than 2 command line arguments
	Too_Many_Arguments	:	exception;		-- Custom exception which will be raised if user enters more than 2 command line arguments
	Invalid_Password	:	exception;		-- Custom exception which will be raised if user doesn't enter a purely alphabetic password
	Invalid_Mode		:	exception;		-- Custom exception which will be raised if user doesn't enter E or D for program mode.	
	Invalid_File		:	exception;		-- Custom exception which will be raised if user enters an input text file that doesn't exist
	password		:	string(1..1024) := (others => ' ');	-- String holding the password the user enters at command prompt, assigned at program runtime 
	pass_length		:	natural := 0;		-- Length of the password, since it likely won't be 1024 characters
	mode			:	character;		-- Character denoting whether program is Encrypt mode or Decrypt mode
	phrase			:	string(1..1024) := (others => ' '); 	-- String holding the phrase that will either be encrypted or decrypted, prior to removal of non-alphabetic characters
	phrase_length		:	natural;		-- Length of the phrase, prior to removal of non-alphabetic characters
	Input			:	file_type;		-- Variable for the input file
	Output			:	file_type;		-- Variable for the output file

	procedure Skip_spaces is		-- Procedure for skipping spaces that I may or may not use in this program
		Next	: Character; 		-- The current character being analyzed in a line of text
		Endline : Boolean; 		-- Whether or not the current character is the end of the line
	begin 
		Endline := false;
		look_Ahead(Next, Endline);
		while Next = ' ' or Next=ASCII.ht or Endline = true loop
			if Endline = true then
				Skip_line;
			else
				Get(Next);
			end if;	
		look_Ahead(Next, Endline);
		end loop;
	end Skip_spaces;
	
	function Capitalize (input : string) return string is	-- Pass in a string, return an all capitals version of it
		temp	:	string := input;		-- Mutable version of input string
	begin
		for count in 1 .. input'last loop
			temp(count) := To_Upper(input(count));
		end loop;
		return temp;		
	end Capitalize;
	
	function Uncapitalize (input : string) return string is	-- Pass in a string, return an all lower case version of it
		temp	:	string := input;		-- Mutable version of input string
	begin
		for count in 1 .. input'last loop
			temp(count) := To_Lower(input(count));
		end loop;
		return temp;		
	end Uncapitalize;

	procedure Verification is
		valid_password	:	boolean;		-- Flag to check for password being valid, used only in this procedure
		end_of_pass	:	boolean := false;	-- Flag to see if end of password has been reached, so that when first space is reached the program knows it's done reading the password instead of erroring out
	begin
		if Argument_Count <= 1 then			-- Check for insufficient command line arguments...
			raise Not_Enough_Arguments;
		elsif Argument_Count >= 5 then 			-- ...or too many command line arguments.
			raise Too_Many_Arguments;
		else
			for count in 1 .. Argument(1)'last loop	-- Go through password char by char and make sure it is all alphabetic, no numbers or symbols allowed. If it is valid, add
								-- char by char from Argument(1) to 'password'. If it's determined to be invalid, raise exception and terminate.
				if (character'pos(Argument(1)(count)) >= 65 and character'pos(Argument(1)(count)) <= 90) or (character'pos(Argument(1)(count)) >= 97 and character'pos(Argument(1)(Count)) <= 122) then
					valid_password := true;
					password(count)	:= Argument(1)(count);
					pass_length := pass_length + 1;	
				elsif Argument(1)(count) = ' ' then 
					valid_password := true; -- If a space is encountered then the end of the password has been reached, can quit reading and exit loop
					exit; 
				else -- If a symbolc other than letters or a space is encountered then the password is invalid and the program will display an error and terminate
					valid_password := false;
					exit;
				end if; -- End alphabetic-checking loop (no numbers, symbols, spaces allowed)
			end loop; -- End 'password' populating loop
		end if; -- End command line argument check
		
		if valid_password = false then
			raise Invalid_Password;			-- If password is invalid raise an error and stop
		elsif valid_password = true then
			password := Capitalize(password);	-- If password is valid then capitalize it and we'll move on		
		end if;
		
		if Argument(2) = "E" or Argument(2) = "e" then	-- If there's the appropriate number of arguments, check if the program mode is correct
			mode := 'E';
		elsif Argument(2) = "D" or Argument(2) = "d" then
		 	mode := 'D';
		else
			raise Invalid_Mode;
		end if; -- End mode verification
	end Verification;
	
	procedure SetFileModes is	-- This procedure opens/creates the appropriate input and output text files, if necessary
	begin
		new_line;
		if Argument_Count = 2 then
			put_line("Encryption key and mode have been entered.");
			put("Password: "); put(ASCII.ht); 
				for I in 1 .. pass_length loop
					put(password(I));
				end loop; new_line;
			Put("Password length: "); Put(pass_length); new_line;
		elsif Argument_Count = 3 then	-- If user has specified an input text file, open it and use the text file for all data input
			Open (Input, In_File, Argument(3));		
			Set_Input(Input);
			put_line("Encryption key, mode and input text file have been entered.");
			put("Password: "); 	
				for I in 1 .. pass_length loop
					put(password(I));
				end loop; new_line; 
			Put("Password length: "); Put(pass_length); new_line;
		elsif Argument_Count = 4 then	-- If user has specified both input and output text files, open them and set them to be default input and output
			Open (Input, In_File, Argument(3));		
			Set_Input(Input);
			Create (Output, Out_File, Argument(4));
			put_line("Encryption key, mode, input text and output text file have been entered.");
			put("Password: ");
				for I in 1 .. pass_length loop
					put(password(I));
				end loop;  new_line;
			Put("Password length: "); Put(pass_length); new_line;
		end if; -- If user did not provide either of the text files, all input/output will be done standard with keyboard and display
	end SetFileModes;
	
	function CleanPhrase (phrase_before : in string) return string is	-- This procedure will strip out all non-alphabetic characters and return the cleaned up phrase.
		phrase_after	:	string(1..1024) := (others => ' ');	-- String to hold the cleaned up version of the phrase
		char_counter	:	natural := 1;				-- Counter that will keep track of where I'm writing to in the string, starts at 1 for indexing reasons
	begin
		for N in 1 .. phrase_before'length loop
			if character'pos(phrase_before(N)) >= 65 and character'pos(phrase_before(N)) <= 90 then 	-- If current character is an upper case letter, store it in "phrase"
				phrase_after(char_counter) := phrase_before(N);
				char_counter := char_counter + 1;
			elsif character'pos(phrase_before(N)) >= 97 and character'pos(phrase_before(N)) <= 122 then 	-- If current character is a lower case letter, store it in "phrase"
				phrase_after(char_counter) := phrase_before(N);
				char_counter := char_counter + 1;
			else -- If current character is anything but a letter, skip over it and do nothing
				char_counter := char_counter;
			end if;
		end loop; -- End non-alphabet remover	
		phrase_length := char_counter - 1;	-- Set the phrase length to be however many actual characters were counted in the cleanup process, minus 1 due to indexing earlier
		return phrase_after;
	end CleanPhrase;
	
	procedure GetPhrase is	-- This procedure will read in and store the user's phrase either from the keyboard or a text file
		char_counter		:	natural := 1;	-- Counter to determine how many characters are in a phrase, after stripping out all non-alphabetic characters
	begin
		if mode = 'E' then 
			put("Program mode: "); put_line("ENCRYPTION");
			if Argument_Count > 2 then			-- If input text file is specified, print that it was read from text file, instead of displaying a prompt for it
				Get_line(phrase, phrase_length);
				phrase := CleanPhrase(phrase);		-- Strip out all non-alphabetic characters
				phrase := Capitalize(phrase);		-- Capitalize all the letters
				Put("Phrase received from "); Put_line(Argument(3));
			else
				Put_line("Please enter the phrase to be encrypted:  "); 
				Get_line(phrase, phrase_length);
				phrase := CleanPhrase(phrase);		-- Strip out all non-alphabetic characters				
				phrase := Capitalize(phrase);		-- Capitalize all the letters
			end if; -- End check for input file, in encryption mode
		elsif mode = 'D' then
			put("Program mode: "); put_line("DECRYPTION");
			if Argument_Count > 2 then
				Get_line(phrase, phrase_length);
				Put("Phrase received from "); Put_line(Argument(3));
			else
				Put_line("Please enter the phrase to be decrypted:  ");
				Get_line(phrase, phrase_length);
			end if; -- End check for input file, in decryption mode
		end if; -- End mode check
	
		put("Phrase:   "); put(ASCII.ht); put(ASCII.ht);
		for i in 1 .. phrase_length loop
			put(phrase(i));
		end loop; new_line;
		Put("Phrase length:   "); put(phrase_length); new_line;
	end GetPhrase;		
	
	procedure Encrypt (phrase : in string; password : in string) is
		curr_pass_char		:	character;			-- The current character being analyzed in the user's encryption key
		curr_pass_char_value	:	natural;			-- The numerical value of the current password character
		curr_phrase_char	:	character;			-- The current character being analyzed in the user's plaintext phrase
		curr_phrase_char_value	:	natural;			-- The numerical value of hte current phrase character
		new_phrase_char		:	character;			-- New character determined by combining the characters from encryption key and plaintext phrase
		offset			:	integer;			-- The amount of offset based on current character of the encryption key
		encrypted_string	:	string(1 .. phrase_length);	-- String to hold new encrypted phrase
	begin -- Begin Encrypt
		for N in 1 .. phrase_length loop
			curr_phrase_char := phrase(N);						-- Example: first letter in thiscourseisfun is 'T'
			curr_phrase_char_value := character'pos(curr_phrase_char);		-- Example: value for 'T' translates to 84

			if N mod pass_length = 0 then					-- This will loop through the password char by char, the if clause ensures that if it's on the final
				curr_pass_char := password(pass_length);			-- letter in the password, it will be the password length and not 0.
			elsif N mod pass_length /= 0 then
				curr_pass_char := password(N mod pass_length);
			end if; -- End password character looper
			
			curr_pass_char_value := character'pos(curr_pass_char);			-- Example: value for 'V' translates to 86
			offset := (curr_pass_char_value - 64) + (curr_phrase_char_value - 65);	-- Example: subtract 64 to go from ASCII value to just amount of offset
			if offset > 26 then							-- If value is greater than 26, need to wrap around alphabet so subtract 26
				new_phrase_char := character'val(offset - 26 + 64);
			else 
				new_phrase_char := character'val(offset + 64);
			end if;
			encrypted_string(N) := new_phrase_char;
		end loop;

		encrypted_string := Capitalize(encrypted_string);

		if Argument_Count /= 4 then -- If user has not specified an output file, print the encrypted phrase to screen
			put("Here's your encrypted phrase:  ");
			for N in 1 .. phrase_length loop
				if not (encrypted_string(N) = ' ') then			-- The encrypted string is actually much longer than the data in it, so this leaves all the empty spaces out
					put(encrypted_string(N));
				end if;
			end loop;
			new_line;
		elsif Argument_Count = 4 then
			put_line("Encrypted phrase has been written to output file");
			for N in 1 .. phrase_length loop
				if not (encrypted_string(N) = ' ') then			-- The encrypted string is actually much longer than the data in it, so this leaves all the empty spaces out
					put(Output, encrypted_string(N));
				end if;
			end loop;
		end if; -- End End if statement checking whether to output to text file or screen
	end Encrypt;
	
	procedure Decrypt (phrase : in string; password : in string) is
		curr_pass_char		:	character;			-- The current character being analyzed in the user's decryption key
		curr_pass_char_value	:	natural;			-- The numerical value of the current password character
		curr_phrase_char	:	character;			-- The current character being analyzed in the user's encrypted phrase
		curr_phrase_char_value	:	natural;			-- The numerical value of the current phrase character
		new_phrase_char		:	character;			-- New character determined by combining the characters from encryption key and plaintext phrase
		offset			:	integer;			-- The amount of offset based on current character of the encryption key
		decrypted_string	:	string(1 .. phrase_length);	-- String to hold new decrypted phrase
	begin
		for N in 1 .. phrase_length loop
			curr_phrase_char := phrase(N);					-- Example: first letter in OPKLQFSMAGBGWSI is 'O'
			curr_phrase_char_value := character'pos(curr_phrase_char);	-- Example: value for 'O' translates to 79
			
			if N mod pass_length = 0 then				-- This will loop through the password char by char, the if clause ensures that if it's on the final
				curr_pass_char := password(pass_length);		-- letter in the password, it will be the password length and not 0.
			elsif N mod pass_length /= 0 then
				curr_pass_char := password(N mod pass_length);
			end if; -- End password character looper
			
			curr_pass_char_value := character'pos(curr_pass_char);		-- Example: value for 'V' translates to 86
			offset := (curr_phrase_char_value) - (curr_pass_char_value);	-- Example: Subtract password char from plaintext to determine offset, if A and A then offset is 0, etc
			if offset < 0 then						-- If offset goes lower than 26, need to wrap around alphabet so add 26
				new_phrase_char := character'val(offset + 26 + 65);	-- Add 65 to offset to get back in A-Z range of characters
			else 
				new_phrase_char := character'val(offset + 65);
			end if;
			decrypted_string(N) := new_phrase_char;			-- Take the transformed character and store it in decrypted_string, then move on
		end loop;
		
		decrypted_string := Uncapitalize(decrypted_string);		-- Convert the decrypted string to all lower case
		
		if Argument_Count /= 4 then 					-- If user has not specified an output file, print the encrypted phrase to screen
			put("Here's your decrypted phrase:  ");
			for N in 1 .. phrase_length loop
				if not (decrypted_string(N) = ' ') then		-- The decrypted string is actually much longer than the data in it, so this leaves all the empty spaces out
					put(decrypted_string(N));
				end if; 
			end loop; new_line;
		elsif Argument_Count = 4 then
			put("Decrypted phrase has been written to output file");
			for N in 1 .. phrase_length loop
				if not (decrypted_string(N) = ' ') then		-- The decrypted string is actually much longer than the data in it, so this leaves all the empty spaces out
					put(Output, decrypted_string(N));
				end if;
			end loop;
			new_line;
		end if; -- End End if statement checking whether to output to text file or screen
	end Decrypt;
begin
	Verification;	-- Before I do anything else I'll check for errors in the command line paramenters. Program will not proceed past here unless command line arguments are valid and usable
	SetFileModes;	-- Check to see if user specified an input or output text file
	GetPhrase;	-- Get phrase to be encrypted/decrypted 
	
	if mode = 'E' then	-- Encrypt and print the encrypted phrase
		Encrypt(phrase, password);
	elsif mode = 'D' then	-- Decrypt and print the decrypted phrase
		Decrypt(phrase, password);
	end if;
	
	put_line("Work complete. Program shutting down...");
	
exception
	when Event : Not_Enough_Arguments =>
		Put_Line ("Error: You didn't enter enough arguments! You need to have 2-4 command line arguments for the program to work.");
		put_line("example: ./vigenere PASSWORD E input.txt output.txt");
	when Event : Too_Many_Arguments =>
		Put_Line ("Error: You entered too many arguments! You need to have 2-4 command line arguments for the program to work.");
		put_line("example: ./vigenere PASSWORD E input.txt output.txt");
	when Event : Invalid_Password =>
		Put_Line ("Error: The password can contain only letters, no numbers or symbols are allowed or else the program won't work.");
		put_line("example: ./vigenere PASSWORD E input.txt output.txt");
	when Event : Invalid_Mode =>
		Put_Line ("Error: You must specify either Encrypt mode (E) or Decrypt mode (D).");
		put_line("example: ./vigenere PASSWORD E input.txt output.txt");
	when others => -- The only other exception that should be raised would be for an invalid input file, so I'm just using "when others =>". I can't think of any other exceptions that would be raised so this should be fine
		Put_Line ("Error: You tried to use an input file that doesn't exist. Please check your input file.");
end Vigenere;
