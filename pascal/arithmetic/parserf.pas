unit PARSERF;

interface

    uses TOKENIZERF;

    type 
        parser_t = ^parser_type;
        parser_type = record 
            tokens: token_list_t;
            current_token: token_t;
        end;
    
    function parser_create(tokens: token_list_t): parser_t;
    function parser_peek(parser: parser_t; offset: integer): token_t;
    function parser_peek(parser: parser_t): token_t;
    function parser_consume(parser: parser_t): token_t;
    function parser_match(parser: parser_t; _type: token_type): boolean;
    function no_tokens(parser: parser_t): boolean;
    procedure skip_whitespace(parser: parser_t); 
    procedure parser_remove(var parser: parser_t);

implementation

function parser_create(tokens: token_list_t): parser_t;

    var result: parser_t;

    begin   
        new(result);
        result^.tokens := tokens;
        result^.current_token := tokens^.head;
        parser_create := result;
        result := NIL; 
    end;

function parser_peek(parser: parser_t): token_t;

    begin
        parser_peek := parser^.current_token; 
    end;

function parser_peek(parser: parser_t; offset: integer): token_t;

    var current: token_t; 

    begin
        current := parser^.current_token; 
        while ((current <> NIL) and (offset <> 0)) do 
            begin
                current := current^.next;
                dec(offset); 
            end;
        parser_peek := current;
        current := NIL;
    end;

function parser_consume(parser: parser_t): token_t;

    var current: token_t;

    begin
        current := parser^.current_token;
        parser_consume := current;
        parser^.current_token := current^.next;
        current := NIL;
    end;

function no_tokens(parser: parser_t): boolean;

    begin
        no_tokens := (parser^.current_token = NIL); 
    end;

function parser_match(parser: parser_t; _type: token_type): boolean;

    begin 
        if (no_tokens(parser)) then 
            parser_match := FALSE 
        else 
            parser_match := (_type = parser_peek(parser)^._type);
    end;

procedure skip_whitespace(parser: parser_t); 

    begin
        while ((not no_tokens(parser)) and (parser_match(parser, WHITE_SPACE))) do 
            parser_consume(parser); 
    end;

procedure parser_remove(var parser: parser_t);

    begin
        dispose(parser);
        parser := NIL; 
    end;


begin 
end.