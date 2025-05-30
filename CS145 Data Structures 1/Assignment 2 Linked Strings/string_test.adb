with Ada.Text_Io, linked_string, Ada.Command_line;
use  Ada.Text_Io, linked_string, Ada.Command_line;

procedure string_test is
	str1 : String := "Hello, my name is Alphose!";
	lstr1 : lstring;
	lstr2 : lstring;
	
	lstr3 : lstring;
	
	infile : file_type;
	outfile : file_type;
begin
	copy(toLstring(str1), lstr1);

	Put(lstr1);
	New_line;

	Put_Line("'" & toString(lstr1) & "'");

	if (lstr1 = toLstring("hello,")) then
		Put_line("equal");
	else
		Put_line("not equal");
	end if;
	
	
	if Argument_count > 0 then
		Open(infile, in_file, Argument(1));
		get(infile, lstr2);
		Close(infile);
	else	
		get(lstr2);
	end if; 
	
	put_line(lstr2);
	
	if Argument_count > 1 then
		Create(outfile, out_file, Argument(2));
		Put_Line(outfile, "'" & toString(lstr2) & "'");
		Close(outfile);
	else
		Put_Line("'" & toString(lstr2) & "'");
	end if;
	
	copy(lstr1 & lstr2, lstr3);
	put_line(lstr3);
	
	Put_line(slice(lstr3, 10, 16));

	Put(lstr1);
	if lstr1 < lstr2 then
		Put(" < ");
	else
		Put(" > ");
	end if;
	Put_line(lstr2);

end string_test;
