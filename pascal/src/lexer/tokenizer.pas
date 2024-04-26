unit tokenizer;

interface 

    uses LEXER, PTYPE, FILE_HANDLE;

    type 
        TOKEN_TYPE = (
            IDENTIFIER,
            LEFT_PAREN,
            RIGHT_PAREN,
            QUOTES,
            STRING_LITERAL,
            SEMI_COLON,
            NEW_LINE,
            WHITE_SPACE,
            ASSIGNEMENT,
            NUMBER_LITERAL,
            INTEGER_TYPE,
            STRING_TYPE,
            BOOLEAN_TYPE,
            RIGHT_BRACE,
            LEFT_BRACE,
            LEFT_CURLY_BRACE,
            RIGHT_CURLY_BRACE,
            BOOLEAN_VALUE,
            FOR_LOOP,
            WHILE_LOOP,
            COMMA,
            FUNCTION_DECLARATION
        );

        token_t = ^my_token;
        my_token = record 
            value: string;
            _type: TOKEN_TYPE;
            next: token_t;
        end;

        token_list_t = record    
            head, tail: token_t;
        end;

    function get_token_list(source_code: string): token_list_t;
    procedure remove_token_list(var token_list: token_list_t); 
    procedure write_token_list(token_list: token_list_t);
    
implementation

function token_create(value: string; _type: TOKEN_TYPE): token_t;

    var token: token_t;

    begin
        new(token);
        token^.value := value;
        token^._type := _type;
        token^.next := NIL;
        token_create := token;
        token := NIL;
    end;

function token_list_init(): token_list_t;

    var result: token_list_t;

    begin
        result.head := NIL;
        result.tail := NIL; 
        token_list_init := result;
    end;

procedure token_add(var token_list: token_list_t; token: token_t);

    begin
        if (token_list.head = NIL) then 
            begin
                token_list.head := token;
                token_list.tail := token; 
            end
        else 
            begin
                token_list.tail^.next := token;
                token_list.tail := token; 
            end;
    end;

function get_token_type(token_value: string): token_type;

    var result: token_type;

    begin
        if (is_number(token_value)) then 
            result := NUMBER_LITERAL
        else
            if (starts_with(token_value, '"') or starts_with(token_value, '''')) then
                result := STRING_LITERAL
            else 
                case token_value of 
                    // SEPARATORS
                    '(': result := LEFT_PAREN;
                    ')': result := RIGHT_PAREN;
                    '{': result := LEFT_CURLY_BRACE;
                    '}': result := RIGHT_CURLY_BRACE;
                    '[': result := LEFT_BRACE;
                    ']': result := RIGHT_BRACE;
                    ';': result := SEMI_COLON;
                    ' ': result := WHITE_SPACE;
                    ':=': result := ASSIGNEMENT;
                    ',': result := COMMA;

                    // DATA TYPES
                    'int': result := INTEGER_TYPE;
                    'string': result := STRING_TYPE;
                    'bool': result := BOOLEAN_TYPE;

                    // SPECIAL VALUES
                    'TRUE', 'FALSE': result := BOOLEAN_VALUE;
                    NEW_LINE_CHAR: result := NEW_LINE; 

                    // LOOP KEYWORDS
                    'for': result := FOR_LOOP;
                    'while': result := WHILE_LOOP;

                    // OTHERS
                    'func': result := FUNCTION_DECLARATION;
                else 
                    result := IDENTIFIER;
                end;
        
        get_token_type := result;
    end;

function token_handle_separator(lexer: lexer_t): string;

    var buffer: string;
        quote_type: char; 

    begin   
        if (is_quote(lexer_peek(lexer))) then 
            begin 
                buffer := lexer_consume(lexer);
                quote_type := buffer[1];
                while ((not is_eof(lexer)) and (lexer_peek(lexer) <> quote_type)) do 
                    buffer := buffer + lexer_consume(lexer);
                token_handle_separator := buffer + lexer_consume(lexer);
                exit();
            end;

        if (is_newline(lexer_peek(lexer))) then 
            begin 
                inc(lexer^.current_line);
                token_handle_separator := lexer_consume(lexer);
                exit();
            end;
        
        if (is_colon(lexer_peek(lexer))) then 
            begin 
                buffer := lexer_consume(lexer);
                token_handle_separator := buffer + lexer_consume(lexer);
                exit()
            end; 

        token_handle_separator := lexer_consume(lexer);       
    end;

procedure token_write(token: token_t);

    var value: string;

    begin
        if (token^.value[1] = NEW_LINE_CHAR) then 
            value := '"\n"'
        else 
            value := token^.value;
        writeln('token_value: ', value,  ', token_type: ', token^._type); 
    end;

function get_next_token(lexer: lexer_t): token_t;

    var 
        token: token_t;
        buffer: string;
        _type: token_type;       

    begin
        buffer := '';

        // writeln(lexer_peek(lexer));

        if (is_separator(lexer_peek(lexer))) then 
            buffer := token_handle_separator(lexer) 
        else
            while ((not is_eof(lexer)) and (is_alnum(lexer_peek(lexer)))) do 
                buffer := buffer + lexer_consume(lexer);
        

        _type := get_token_type(buffer);
        token := token_create(buffer, _type);
        get_next_token := token; 
    end;

function get_token_list(source_code: string): token_list_t;

    var lexer: lexer_t;
        token: token_t;
        token_list: token_list_t;
        count: integer;

    begin
        lexer := lexer_create(source_code);
        token_list := token_list_init();

        while not is_eof(lexer) do 
            begin 
                token := get_next_token(lexer);
                token_add(token_list, token);
            end;
        
        get_token_list := token_list;
    end;

procedure remove_token_list(var token_list: token_list_t); 

    var current_token: token_t;
    
    begin
        while (token_list.head <> NIL) do 
            begin
                current_token := token_list.head;
                token_list.head := current_token^.next;
                dispose(current_token); 
            end; 
        token_list.tail := NIL;
    end;

procedure write_token_list(token_list: token_list_t);

    var current_token: token_t;

    begin 
        current_token := token_list.head;
        while (current_token <> NIL) do 
            begin
                token_write(current_token);
                current_token := current_token^.next; 
            end;
    end;

begin 
end.
