unit lexerf;

interface

    type 
        lexer_t = ^lexer_type;
        lexer_type = record 
            content: string;
            content_size: int64;
            current_index: int64;
        end;
    
    function lexer_create(content: string): lexer_t;
    function lexer_peek(lexer: lexer_t): char;
    function is_eof(lexer: lexer_t): boolean;
    function lexer_consume(lexer: lexer_t): char;
    procedure lexer_remove(var lexer: lexer_t);

implementation

function lexer_create(content: string): lexer_t;

    var result: lexer_t;

    begin
        new(result);
        result^.content := content;
        result^.content_size := length(content);
        result^.current_index := 1; 
        lexer_create := result;
        result := NIL;
    end;

function is_eof(lexer: lexer_t): boolean;

    begin
        is_eof := (lexer^.current_index > lexer^.content_size); 
    end;

function lexer_peek(lexer: lexer_t): char;

    begin
        lexer_peek := (lexer^.content[lexer^.current_index]); 
    end;

function lexer_consume(lexer: lexer_t): char;

    begin
        lexer_consume := lexer_peek(lexer);
        inc(lexer^.current_index); 
    end;


procedure lexer_remove(var lexer: lexer_t);

    begin
        dispose(lexer);
        lexer := NIL; 
    end;


begin 
end.