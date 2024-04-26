unit CMDF;

interface
    
    uses PROCESS;

    procedure handle_input(input: string);
    procedure clear_screen();

implementation

procedure clear_screen();

    var output: ansistring;

    begin
        runCommand('clear', output); 
    end;

procedure handle_input(input: string);
    
    begin
        case (input) of 
            'clear': clear_screen();
            'quit': exit();
        end; 
    end;


begin
end.