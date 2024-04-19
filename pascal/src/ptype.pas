unit ptype;

interface   

    const  NEW_LINE_CHAR = #10;

    function is_al(c: char): boolean;
    function is_num(c: char): boolean;
    function is_number(my_string: string): boolean;
    function is_alnum(c: char): boolean;
    function is_par(c: char): boolean;
    function is_quote(c: char): boolean;
    function is_semi(c: char): boolean;
    function is_whitespace(c: char): boolean;
    function is_newline(c: char): boolean;
    function is_colon(c: char): boolean;
    function is_equal(c: char): boolean;
    function is_separator(c: char): boolean;
    

    function starts_with(my_string: string; target_string: string): boolean;

implementation

function is_al(c: char): boolean;

    begin
        is_al := ((c = '_') or (c >= 'A') and (c <= 'Z')) or ((c >= 'a') and (c <= 'z')); 
    end;

function is_num(c: char): boolean;

    begin
        is_num := (c >= '0') and (c <= '9'); 
    end;

function is_alnum(c: char): boolean;

    begin
        is_alnum := is_al(c) or is_num(c);
    end;

function is_par(c: char): boolean;

    begin
        is_par := (c = ')') or (c = '('); 
    end;

function is_quote(c: char): boolean;

    begin
        is_quote := (c = '"') or (c = ''''); 
    end;

function is_semi(c: char): boolean;

    begin
        is_semi := (c = ';'); 
    end;

function is_whitespace(c: char): boolean;

    begin
        is_whitespace := (c = ' '); 
    end;

function is_newline(c: char): boolean;

    begin
        is_newline := (c =     NEW_LINE_CHAR); 
    end;

function is_colon(c: char): boolean;

    begin
        is_colon := (c = ':'); 
    end;

function is_equal(c: char): boolean;

    begin
        is_equal := (c = '='); 
    end;

function is_left_curly_brace(c: char): boolean;   
    
    begin
        is_left_curly_brace := (c = '{'); 
    end;

function is_right_curly_brace(c: char): boolean;

    begin
        is_right_curly_brace := (c = '}'); 
    end;

function is_leftbrace(c: char): boolean;   
    
    begin
        is_leftbrace := (c = '['); 
    end;

function is_rightbrace(c: char): boolean;

    begin
        is_rightbrace := (c = ']'); 
    end;


function is_separator(c: char): boolean;

    begin
        is_separator := is_left_curly_brace(c) or is_right_curly_brace(c) or is_rightbrace(c) or is_leftbrace(c) or is_equal(c) or is_colon(c) or is_newline(c) or is_whitespace(c) or is_semi(c) or is_quote(c) or is_par(c); 
    end;

function is_number(my_string: string): boolean;

    var string_length, i: integer;

    begin   
        i := 1;
        is_number := TRUE;
        string_length := length(my_string);
        while ((is_number) and (i <= string_length)) do 
            begin
                is_number := (is_num(my_string[i]));
                inc(i); 
            end; 
    end;


function starts_with(my_string: string; target_string: string): boolean;

    var target_length: integer;
        string_length: integer;
        i: integer;
    
    begin      
        target_length := length(target_string);
        string_length := length(my_string);

        if (target_length > string_length) then 
            starts_with := FALSE
        else 
            begin
                starts_with := TRUE;
                i := 1;
                while ((i <= target_length) and (starts_with)) do 
                    begin 
                        starts_with := (target_string[i] = my_string[i]);
                        inc(i);
                    end; 
            end; 
    end;


begin 
end.