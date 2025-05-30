with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure sandbox is
	-- This procedure swaps two money values, will make sorting my category totals easier
	procedure SwapMoney (Val1, Val2 : in out money) is
		temp 		:	money;
	begin -- Begin swap
		temp := Val1;
		Val1 := Val2;
		Val2 := temp;
	end SwapMoney;
	
	-- This procedure swaps two Sales_Total type records
	procedure Swap (Val1, Val2 : in out Sales_Total) is
		temp1 		:	Category_Type;
		temp2		:	money;
	begin -- Begin swap
		temp1 := Val1.category;
		temp2 := Val2.total;
		Val1.category := Val2.category;
		Val1.total := Val2.total;
		Val2.category := temp1;
		Val2.total := temp2;
	end Swap;

end sandbox;
