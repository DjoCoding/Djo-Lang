unit file_handle;

interface

    procedure file_open(var filehandle: text; filename: string; mode: char);
    function get_file_content(filename: string): string;


implementation

procedure file_open(var filehandle: text; filename: string; mode: char);

    begin
        assign(filehandle, filename);
        case mode of 
            'r': reset(filehandle);
            'w': rewrite(filehandle);
            'a': append(filehandle);
        end;
    end;

function get_file_content(filename: string): string;

    var filehandle: textfile;
        file_content: string;
        file_char: char;
    
    begin
        file_open(filehandle, filename, 'r');
        file_content := '';
        while (not eof(filehandle)) do 
            begin
                read(filehandle, file_char);
                file_content := file_content + file_char; 
            end;
        
        get_file_content := file_content;
        close(filehandle);
    end;

begin 
end.