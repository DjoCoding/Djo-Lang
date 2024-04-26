unit convert;

interface
    
    type 
        OPERATION_TYPE = (ADDITION, SUBSTRACTION, MULTIPLICATION, DIVISION);

    function to_integer(int_string: string): integer;
    function to_string(number: integer): string;
    function to_string(OPERATION_T: OPERATION_TYPE): string;
    function to_operation(s: string): OPERATION_TYPE;

implementation

function to_integer(int_string: string): integer;

    var result: integer;
        string_length: integer;
        i: integer;     

    begin
        result := 0;
        string_length := length(int_string);
        
        for i := 1 to string_length do
            result := result * 10 + ord(int_string[i]) - ord('0');
        
        to_integer := result;
    end;

function to_string(number: integer): string;

    var result: string;
        number_sign: boolean; // TRUE if negative!

    begin
        if (number = 0) then 
            begin 
                to_string := '0';
                exit();
            end;
        
        number_sign := (number < 0);
        number := abs(number);
        result := '';

        while (number <> 0) do 
            begin 
                result := chr(number mod 10 + ord('0')) + result;
                number := number div 10;
            end;
        
        if (number_sign) then 
            result := '-' + result;
        
        to_string := result;
    end;


function to_string(OPERATION_T: OPERATION_TYPE): string;

    var result: string;

    begin
        case OPERATION_T of 
            ADDITION: result := 'ADDITION'; 
            SUBSTRACTION: result := 'SUBSTRACTION';
            MULTIPLICATION: result := 'MULTIPLICATION';
            DIVISION: result := 'DIVISION';
        end;
    
        to_string := result;
    end;

function to_operation(s: string): OPERATION_TYPE;

    var result: OPERATION_TYPE;
    
    begin 
        case s of 
            '+': result := ADDITION;
            '-': result := SUBSTRACTION;
            '*': result := MULTIPLICATION;
            '/': result := DIVISION;
        end;

        to_operation := result;        
    end;


begin 
end.