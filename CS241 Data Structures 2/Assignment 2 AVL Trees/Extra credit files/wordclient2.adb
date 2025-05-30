with wordpkg; use wordpkg;
with wordpkg.pals; use wordpkg.pals;
with ada.integer_text_io; use ada.integer_text_io; 
with ada.text_io; use ada.text_io; 
 
procedure wordclient2 is
    w: word;
    p: boolean;
    s: string := "racecar" ;
begin
    loop
        w := new_Word(s);
        -- get(w);
        exit when length(w) = 0;

        if ispal(w) = true then 
            put(w);
            put(" is a palindrome");
            new_line;
        else
            put(w);
            put(" is not a palindrome");
        end if;
        
        p := ispal(w);
        put(p'img & " ");
        put(w);
        put(length(w));
        new_line;
    end loop;
end wordclient2;
        
