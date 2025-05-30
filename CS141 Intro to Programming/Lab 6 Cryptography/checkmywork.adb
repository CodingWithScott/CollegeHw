with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Ada.Exceptions;

procedure checkmywork is
	type string is array (positive range <>) of character;
	cipher : string := "SXWKXIMKCOCXEWLOBCKBOEXCESDKLVOPYBBOZBOCOXDSXQDRODIZOCYPNKDKBOAESBONLIKZBYQBKWMYXCSNOBDRONKICYPDROGOOUKCKXOHKWZVOGOMYEVNECODROXEWLOBCDYYBDYDYBOZBOCOXDDRONKICYPDROGOOULEDDROINYXDVOXNDROWCOVFOCDYDRSCXKDEBKVVIDROXKDEBKVGKIDYBOZBOCOXDNKICYPDROGOOUSCLIECSXQDROSBXKWOCWYXNKIDEOCNKIGONXOCNKIKXNCYYX";
	
	-- Decode shit
	procedure decode(str : string) is
		decoded_string : string(str'range);
	begin -- Begin toUpper
		for n in str'range loop
			decoded_string(n) := character'val(character'pos(str(n)) + character'pos('K') - character'pos('A'));
		end loop;
		cipher := decoded_string;
	end decode;
begin
	Decode(cipher);
	for n in cipher'range loop
		put (cipher(n));
	end loop;

end checkmywork;
		

