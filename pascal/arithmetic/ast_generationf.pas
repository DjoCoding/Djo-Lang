unit AST_GENERATIONF;

interface

    uses CONVERT, TOKENIZERF, PARSERF, ASTF, MATHF;
    
    function get_ast(parser: parser_t): ast_tree;
    function evalute_expression(ast: ast_tree): integer;

implementation

function parse_primary_expression(parser: parser_t): ast_node;

    begin
        if (no_tokens(parser)) then 
            begin
                parse_primary_expression := NIL;
                exit(); 
            end;

        case (parser_peek(parser)^._type) of 
            OPERATION, INTEGER_LITERAL: parse_primary_expression := convert_token_to_node(parser_consume(parser));
        else 
            parse_primary_expression := NIL;
        end;
    end;

function parse_paren_expression(parser: parser_t): ast_node;

    var left, right, current: ast_node;

    begin
        if (parser_peek(parser)^._type <> LEFT_PAREN) then 
            begin   
                parse_paren_expression := parse_primary_expression(parser);
                exit(); 
            end;
        
        parser_consume(parser); // consuming the left paren token!

        left := parse_paren_expression(parser);

        if (left <> NIL) then 
            while ((not no_tokens(parser)) and (parser_peek(parser)^._type <> RIGHT_PAREN)) do 
                begin
                    current := parse_primary_expression(parser);
                    right := parse_paren_expression(parser);
                    if ((right = NIL) or (current = NIL)) then 
                        begin
                            writeln('ERROR, NOT A VALID EXPRESSION IN PAREN');
                            parse_paren_expression := NIL;
                            exit(); 
                        end;
                    current^.left := left;
                    current^.right := right;
                    left := current;
                end; 
        
        if (parser_peek(parser)^._type = RIGHT_PAREN) then 
            parser_consume(parser)
        else 
            begin 
                writeln('ERROR: EXPECTED A ")"');
                ast_remove(left);
                left := NIL;
            end;

        parse_paren_expression := left;
    end;

function parse_multiplicative_expression(parser: parser_t): ast_node;

    var current, left, right: ast_node;
    
    begin
        left := parse_paren_expression(parser);

        while (not no_tokens(parser)) do 
            begin   
                if ((parser_peek(parser)^.value <> '*') and (parser_peek(parser)^.value <> '/')) then 
                    break;

                current := parse_primary_expression(parser);
                right := parse_paren_expression(parser);

                if ((right = NIL) or (current = NIL)) then 
                    begin
                        writeln('ERROR, NOT A VALID EXPRESSION IN MULTIPLICATION');
                        // generate_parser_error(TOKEN_ERROR, parser);
                        parse_multiplicative_expression := NIL;
                        exit();
                    end;
                current^.left := left;
                current^.right := right;
                left := current;
            end; 
        
        parse_multiplicative_expression := left;
    end;

function parse_additive_expression(parser: parser_t): ast_node;

    var current, left, right: ast_node;

    begin 
        left := parse_multiplicative_expression(parser);
        
        while (not no_tokens(parser)) do 
            begin
                if ((parser_peek(parser)^.value <> '+') and (parser_peek(parser)^.value <> '-')) then 
                    break;

                current := parse_primary_expression(parser);
                right := parse_multiplicative_expression(parser);
                if ((right = NIL) or (current = NIL)) then 
                    begin 
                        writeln('ERROR, NOT A VALID EXPRESSION IN ADDITION');
                        // generate_parser_error(TOKEN_ERROR, parser);
                        parse_additive_expression := NIL;
                        exit(); 
                    end;
                current^.left := left;
                current^.right := right;
                left := current;
            end;
        
        parse_additive_expression := left;
    end;

function get_ast(parser: parser_t): ast_tree;

    begin
        get_ast := ast_tree_create(parse_additive_expression(parser));
    end;

function evaluate(current: ast_node): integer;

    begin
        if (current = NIL) then 
            evaluate := 0 
        else 
            if (current^._type = INTEGER_LITERAL) then 
                evaluate := to_integer(current^.value)
        else 
            evaluate := eval(evaluate(current^.left), current^.value, evaluate(current^.right));

    end;

function evalute_expression(ast: ast_tree): integer;

    begin
        evalute_expression := evaluate(ast.root);
    end;

begin 
end.
