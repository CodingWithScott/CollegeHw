-- generic sort routine

procedure gen_sort(A : in out Array_Type) is
	temp : Item_Type;
begin
	for i in A'range loop
		for j in Index_Type'Succ(i) .. A'Last loop
			if A(j) < A(i) then
				temp := A(j);
				A(j) := A(i);
				A(i) := temp;
			end if;
		end loop;
	end loop;

end gen_sort;
