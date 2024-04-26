unit EVAL;

interface 

    uses QUEUE, CRT, ASTF, AST_GENERATIONF, TOKENIZERF, PARSERF, LEXERF;

    procedure repl();

implementation

procedure repl();

    var 
        input: string;
        lexer: lexer_t;
        parser: parser_t;
        tokens: token_list_t;
        ast: ast_tree;
    
    begin
        repeat
            write('eval> ');
            readln(input);

            if (input <> 'q') then 
                case input of 
                    'clear': 
                        clrscr();
                else 
                    begin
                        lexer := lexer_create(input);
                        tokens := get_token_list(lexer);
                        parser := parser_create(tokens);
                        ast := get_ast(parser);

                        writeln();

                        bfs(ast);
                        writeln();
                        
                        writeln('result is: ', evalute_expression(ast));

                        writeln();
                        
                        token_list_remove(tokens);
                        lexer_remove(lexer);
                        parser_remove(parser);
                        ast_remove(ast.root);
                        writeln();
                    end;
                end;
        until (input = 'q'); 
    end;

begin 
end.

