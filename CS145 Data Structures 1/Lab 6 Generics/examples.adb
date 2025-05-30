-- The ADS file
generic
        type Item_Type is private;
        type Index_Type is (<>);
        type Array_Type is array (Index_Type range <>) of Item_Type;
        with function Compare (Left, Right : Item_Type) return Boolean;
    procedure Generic_Sort (X : in out Array_Type);
    
-- The ADB file
-- Procedure definition
    procedure Generic_Sort (X : in out Array_Type) is
        Position : Index_Type;
        Value    : Item_Type;
    begin
        for I in Index_Type'Succ(X'First)..X'Last loop
            if X(I) < X(Index_Type'Pred(I)) then
                Value := X(I);
                for J in reverse X'First .. Index_Type'Pred(I) loop
                    exit when X(J) < Value;
                    Position := J;
                end loop;
                X(Index_Type'Succ(Position)..I) := X(Position..Index_Type'Pred(I));
                X(Position) := Value;
            end if;
        end loop;
    end Generic_Sort;
    
-- The MAIN file
type Character_Count is
        record
            Char  : Character;
            Count : Integer := 0;
        end record;

    type Count_Array is array (Character) of Character_Count;

    function Less (X, Y : Character_Count) return Boolean is
    begin
        return X.Count < Y.Count;
    end Less;

    -- Instantiation of Generic_Sort to sort Count_Arrays:
    procedure Sort is new Generic_Sort (Item_Type => Character_Count,
                                        Index_Type => Character,
                                        Array_Type => Count_Array,
                                        Compare => Less);
type Character_Count is array (Character) of Integer;

    procedure Ascending_Sort  is new Generic_Sort (Item_Type => Integer,
                                                   Index_Type => Character,
                                                   Array_Type => Character_Count,
                                                   Compare => "<");
    procedure Descending_Sort is new Generic_Sort (Item_Type => Integer,
                                                   Index_Type => Character,
                                                   Array_Type => Character_Count,
                                                   Compare => ">");
