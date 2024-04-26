unit TOKENIZERF;

interface   

    uses LEXERF, ERRORF, PTYPE;

    type
        TOKEN_TYPE = (
            INTEGER_LITERAL,
            OPERATION,
            LEFT_PAREN,
            RIGHT_PAREN,
            WHITE_SPACE
        );

        token_t = ^token_node;
        token_node = record 
            value: string;
            _type: TOKEN_TYPE;
            next: token_t;
        end;

        token_list_t = ^token_list_type;
        token_list_type = record 
            head, tail: token_t;
        end;

    procedure token_list_print(token_list: token_list_t);
    procedure token_list_remove(var token_list: token_list_t);
    function get_token_list(lexer: lexer_t): token_list_t;

implementation

function token_create(value: string; _type: TOKEN_TYPE): token_t;

    var result: token_t;

    begin
        new(result);
        result^.value := value;
        result^._type := _type;
        result^.next := NIL;
        token_create := result;
        result := NIL; 
    end;

procedure token_set_value(token: token_t; value: string);

    begin
        token^.value := value; 
    end;

procedure token_set_type(token: token_t; _type: TOKEN_TYPE);

    begin
        token^._type := _type; 
    end;

function token_list_init(): token_list_t;

    var result: token_list_t;

    begin
        new(result);
        result^.head := NIL;
        result^.tail := NIL;
        token_list_init := result;
        result := NIL; 
    end;

procedure token_list_add(var token_list: token_list_t; token: token_t);

    begin
        writeln('[LEXER] adding token {', token^.value, ', ', token^._type, '}');

        if (token_list^.head = NIL) then 
            begin
                token_list^.head := token;
                token_list^.tail := token; 
            end
        else 
            begin 
                token_list^.tail^.next := token;
                token_list^.tail := token;
            end; 
    end;

procedure token_list_remove(var token_list: token_list_t);

    var token: token_t;

    begin
        if (token_list = NIL) then 
            exit();

        while (token_list^.head <> NIL) do 
            begin
                token := token_list^.head;
                writeln('[LEXER] removing token {', token^.value, ', ', token^._type, '}');
                token_list^.head := token^.next;
                dispose(token); 
            end; 
        token_list^.tail := NIL;
    end;

function get_next_token(lexer: lexer_t): token_t;

    var
        buffer: string;
        _type: TOKEN_TYPE;
    
    begin
        buffer := '';

        if (is_par(lexer_peek(lexer))) then 
            begin
                buffer := lexer_consume(lexer);
                case buffer of 
                    ')': _type := RIGHT_PAREN;
                    '(': _type := LEFT_PAREN; 
                end;
                get_next_token := token_create(buffer, _type);
                exit();
            end;

        if (is_whitespace(lexer_peek(lexer))) then 
            begin 
                buffer := lexer_consume(lexer);
                _type := WHITE_SPACE;
                get_next_token := token_create(buffer, _type);
                exit();
            end;
        
        if (is_operation(lexer_peek(lexer))) then 
            begin 
                buffer := lexer_consume(lexer);
                _type := OPERATION;
                get_next_token := token_create(buffer, _type);
                exit();
            end;

        if (is_num(lexer_peek(lexer))) then 
            begin 
                while (not (is_eof(lexer)) and (is_num(lexer_peek(lexer)))) do 
                    buffer := buffer + lexer_consume(lexer);
                _type := INTEGER_LITERAL;
                get_next_token := token_create(buffer, _type);
                exit();
            end;
        
        generate_lexer_error(TOKEN_ERROR, lexer);
        get_next_token := NIL;
    end;

procedure token_print(token: token_t);  

    begin
        writeln('TOKEN VALUE: ', token^.value, ' TOKEN TYPE: ', token^._type); 
    end;

procedure token_list_print(token_list: token_list_t);

    var current_token: token_t;

    begin
        current_token := token_list^.head;

        while (current_token <> NIL) do 
            begin
                token_print(current_token);
                current_token := current_token^.next; 
                if (current_token = token_list^.tail) then break;
            end;
    end;

function get_token_list(lexer: lexer_t): token_list_t;

    var 
        token: token_t;
        result: token_list_t;

    begin 
        result := token_list_init();

        while (not is_eof(lexer)) do 
            if (lexer_peek(lexer) = ' ') then 
                lexer_consume(lexer)
            else
                begin 
                    token := get_next_token(lexer);
                    if (token = NIL) then 
                        begin 
                            token_list_remove(result);
                            break;
                        end
                    else
                        token_list_add(result, token); 
                end;
        
        get_token_list := result;
    end;

begin 
end.


