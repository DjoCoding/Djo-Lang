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
        file_line: string;
    
    begin
        file_open(filehandle, filename, 'r');
        file_content := '';
        while (not eof(filehandle)) do 
            begin
                readln(filehandle, file_line);
                file_content := file_content + file_line; 
            end;
        
        get_file_content := file_content;
        close(filehandle);
    end;

begin 
end.