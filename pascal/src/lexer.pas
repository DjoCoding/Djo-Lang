unit lexer;

interface

    type 
        lexer_t = ^lexer_type;
        lexer_type = record 
            content: string;
            content_size: int64;
            current_line: integer;
            current_index: int64;
            in_string: boolean;
        end;
    
    function lexer_create(content: string): lexer_t;
    function lexer_peek(lexer: lexer_t): char;
    function lexer_consume(lexer: lexer_t): char;
    function is_eof(lexer: lexer_t): boolean;

implementation 

function lexer_create(content: string): lexer_t;

    var lexer: lexer_t;

    begin
        new(lexer);
        lexer^.content := content;
        lexer^.content_size := length(content);
        lexer^.current_index := 1;
        lexer^.current_line := 1;
        lexer^.in_string := FALSE;
        lexer_create := lexer;
        lexer := NIL;
    end;

function lexer_peek(lexer: lexer_t): char;

    begin
        lexer_peek := lexer^.content[lexer^.current_index];
    end;

function lexer_consume(lexer: lexer_t): char;

    begin
        lexer_consume := lexer_peek(lexer);
        inc(lexer^.current_index); 
    end;

function is_eof(lexer: lexer_t): boolean;

    begin
        is_eof := lexer^.current_index > lexer^.content_size; 
    end;

procedure lex(filename: string);

    var filehandle: text;

    begin 
    end;

begin 
end.




