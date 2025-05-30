-- Scott Felch
-- 12 October 2011
-- CSCI 141, Lab 3
-- This program will read in scores from text files of students in a class, and their 
-- scores on 7 labs and 5 assignments, and determine their overall score. The total data that 
-- must be outputted is: maximum total score in class, minimum total score in class,
-- average total score in class (using integer division), number of students with each
-- grade.

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Grader is
	-- Class variables
	ClassMax : 	integer := 0;	-- Variable to hold the maximum total score of any student
	ClassMin : 	integer := 100;	-- Variable to hold the minimum total score of any student
	RowCounter : 	integer := 0; 	-- Counter of the number of rows/number of students
	ClassTotal : 	integer := 0;	-- Accumulator of total class score, to calculate average 
	ClassAve : 	integer := 0;	-- Average score for the whole class
	NumAs : 	integer := 0;	-- Counter for number of students with an A in the course
	NumBs : 	integer := 0;	-- Counter for number of students with a B in the course
	NumCs : 	integer := 0;	-- Counter for number of students with a C in the course
	NumDs : 	integer := 0;	-- Counter for number of students with a D in the course
	NumFs : 	integer := 0;	-- Counter for number of students with an F in the course

	-- Student variables
	LabTotal :     	integer;	-- Total of student's lab scores, which will be divided as part of determining StudentTotal
	StudentTotal : 	integer;	-- Accumulator of current student's total score
	CurAssign :	integer;	-- Variable to hold the current assignment being analyzed
	lab1 :		integer;	-- Score for current student's lab 1
	lab2 :		integer;	-- Score for current student's lab 2
	lab3 :		integer;	-- Score for current student's lab 3	
	lab4 :		integer;	-- Score for current student's lab 4
	lab5 : 		integer;	-- Score for current student's lab 5
	lab6 :		integer;	-- Score for current student's lab 6
	lab7 :		integer;	-- Score for current student's lab 7
	ass8 :		integer;	-- Score for current student's assignment 8
	ass9 :		integer;	-- Score for current student's assignment 9
	ass10 :		integer;	-- Score for current student's assignment 10
	ass11 :		integer;	-- Score for current student's assignment 11
	ass12 :		integer;	-- Score for current student's assignment 12

	procedure GetScores is
		ColCounter :	integer := 0;	-- Counter of the number of column/what assignment is being analyzed
	begin -- GetScores
		while (ColCounter < 12) loop	-- Loop adds up all the scores for the current student/row.
			get (CurAssign);
			if ColCounter = 0 then
				lab1 := CurAssign;
			elsif ColCounter = 1 then
				lab2 := CurAssign;
			elsif ColCounter = 2 then
				lab3 := CurAssign;
			elsif ColCounter = 3 then
				lab4 := CurAssign;
			elsif ColCounter = 4 then
				lab5 := CurAssign;
			elsif ColCounter = 5 then						
				lab6 := CurAssign;		
			elsif ColCounter = 6 then
				lab7 := CurAssign;
			elsif ColCounter = 7 then
				ass8 := CurAssign;
			elsif ColCounter = 8 then
				ass9 := CurAssign;
			elsif ColCounter = 9 then
				ass10 := CurAssign;
			elsif ColCounter = 10 then
				ass11 := CurAssign;
			elsif ColCounter = 11 then
				ass12 := CurAssign;
			end if;
			ColCounter := ColCounter + 1;
		end loop; -- End loop for populating assignments in current line
	end GetScores;

	procedure CalcScores is
	begin -- CalcScores
		LabTotal := lab1 + lab2 + lab3 + lab4 + lab5 + lab6 + lab7;		
		-- Grading is performed as 15% labs, 85% assignments. In other words,
		StudentTotal := 15 * LabTotal / 70 + ass8 + ass9 + ass10 + ass11 + ass12;
		-- Increment the appropriate counter for letter grades
		if (90 <= StudentTotal) then
			NumAs := NumAs + 1;
		elsif (80 <= StudentTotal and StudentTotal < 90) then
			NumBs := NumBs + 1;
		elsif (70 <= StudentTotal and StudentTotal < 80) then
			NumCs := NumCs + 1;
		elsif (60 <= StudentTotal and StudentTotal < 70) then
			NumDs := NumDs + 1;
		elsif (StudentTotal < 60) then
			NumFs := NumFs + 1;
		end if;

		-- Add current student's score to class total, check if current student's total score is a class maximum or minimum
		if StudentTotal > ClassMax then
			ClassMax := StudentTotal;
		end if;
		if StudentTotal < ClassMin then
			ClassMin := StudentTotal;
		end if;
		ClassTotal := ClassTotal + StudentTotal;
	end CalcScores;			

	procedure DisplayInfo is
	begin -- DisplayInfo
		ClassAve := ClassTotal / RowCounter; -- Calculate average score of whole class
		-- Now all the data has been read in and calculated, output it all out in a pretty format
		New_Line;
		Put ("Data summary"); New_Line;
		Put ("----------------------"); New_Line;
		Put ("Maximum score in the class:"); Put (ASCII.ht); Put (ClassMax); New_Line;
		Put ("Minimum score in the class:"); Put (ASCII.ht); Put (ClassMin); New_Line;
		Put ("Average score in the class:"); Put (ASCII.ht); Put (ClassAve); New_Line;
		Put ("----------------------"); New_Line;
		Put ("Number of As in the class:"); Put (ASCII.ht); Put (NumAs); New_Line;
		Put ("Number of Bs in the class:"); Put (ASCII.ht); Put (NumBs); New_Line;
		Put ("Number of Cs in the class:"); Put (ASCII.ht); Put (NumCs); New_Line;
		Put ("Number of Ds in the class:"); Put (ASCII.ht); Put (NumDs); New_Line;
		Put ("Number of Fs in the class:"); Put (ASCII.ht); Put (NumFs); New_Line;
		Put ("Total number of students:"); Put (ASCII.ht); Put (RowCounter); New_Line;
		Put ("----------------------"); New_Line; New_Line;
	end DisplayInfo;
		
begin -- Begin Grader
	while (end_of_file = false) loop -- Loop will continue as long as there is a valid row/student to work with 
		GetScores;	-- Call GetScores to retrieve scores for this student from the current row
		CalcScores;	-- Call CalcScores to determine student's lab score, total score, and increment appropriate grades
		RowCounter := RowCounter + 1;	-- Increment row/student to the next line
	end loop; -- When end of file is reached, loop will exit and display totals for all information collected
	DisplayInfo;
end Grader;
