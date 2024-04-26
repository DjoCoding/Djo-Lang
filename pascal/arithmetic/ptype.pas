unit ptype;

interface

    function is_whitespace(c: char): boolean;
    function is_operation(c: char): boolean;
    function is_num(c: char): boolean;
    function is_par(c: char): boolean;

implementation

function is_whitespace(c: char): boolean;

    begin
        is_whitespace := (c = ' '); 
    end;

function is_operation(c: char): boolean;

    begin 
        is_operation := (c = '+') or (c = '-') or (c = '*') or (c = '/');
    end;

function is_num(c: char): boolean;

    begin
        is_num := (c >= '0') and (c <= '9'); 
    end;

function is_par(c: char): boolean;

    begin
        is_par := (c = '(') or (c = ')'); 
    end;

begin 
end.

