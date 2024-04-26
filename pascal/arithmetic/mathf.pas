unit MATHF;

interface

    function eval(left: integer; op: string; right: integer): integer;

implementation

function eval(left: integer; op: string; right: integer): integer;

    begin
        case op of 
            '+': eval := left + right;
            '-': eval := left - right;
            '*': eval := left * right;
            '/': eval := left div right;
        end;
    end;   

begin 
end.