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
            BOOLEAN_VALUE
        );

        token_t = ^my_token;
        my_token = record 
            value: string;
            _type: TOKEN_TYPE;
            next: token_t;
        end;

        token_list_type = record    
            head, tail: token_t;
        end;

    function tokenize(lexer: lexer_t): token_t;
    procedure get_tokens(filename: string);

    
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

procedure token_add(var token_list: token_list_type; token: token_t);

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
            if (starts_with(token_value, '"')) then
                result := STRING_LITERAL
            else 
                case token_value of 
                    '(': result := LEFT_PAREN;
                    ')': result := RIGHT_PAREN;
                    '{': result := LEFT_CURLY_BRACE;
                    '}': result := RIGHT_CURLY_BRACE;
                    '[': result := LEFT_BRACE;
                    ']': result := RIGHT_BRACE;
                    ';': result := SEMI_COLON;
                    ' ': result := WHITE_SPACE;
                    ':=': result := ASSIGNEMENT;
                    'int': result := INTEGER_TYPE;
                    'string': result := STRING_TYPE;
                    'bool': result := BOOLEAN_TYPE;
                    'TRUE', 'FALSE': result := BOOLEAN_VALUE;
                    NEW_LINE_CHAR: result := NEW_LINE; 
                else 
                    result := IDENTIFIER;
                end;
        
        get_token_type := result;
    end;

function token_handle_separator(lexer: lexer_t): string;

    var buffer: string;
        quote_type: char; 

    begin   

        // writeln(lexer_peek(lexer));

        if (is_quote(lexer_peek(lexer))) then 
            begin 
                quote_type := lexer_peek(lexer);
                buffer := lexer_consume(lexer);
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

    begin
        writeln('token_value: ', token^.value,  ', token_type: ', token^._type); 
    end;

function tokenize(lexer: lexer_t): token_t;

    var 
        token: token_t;
        buffer: string;
        _type: token_type;       

    begin
        buffer := '';

        if (is_separator(lexer_peek(lexer))) then 
            buffer := token_handle_separator(lexer) 
        else
            while ((not is_eof(lexer)) and (is_alnum(lexer_peek(lexer)))) do 
                buffer := buffer + lexer_consume(lexer);
        

        _type := get_token_type(buffer);
        token := token_create(buffer, _type);
        tokenize := token; 
    end;

procedure get_tokens(filename: string);

    var lexer: lexer_t;
        file_content: string;
        token: token_t;

    begin
        file_content := get_file_content(filename);
        lexer := lexer_create(file_content);
        while not is_eof(lexer) do 
            begin 
                token := tokenize(lexer);
                token_write(token);
                dispose(token);
            end;
    end;

begin 
end.
