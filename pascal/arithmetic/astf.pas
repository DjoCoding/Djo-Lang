unit ASTF;

interface 

    uses PARSERF, STACK, TOKENIZERF, ERRORF, CONVERT;

    type 
        ast_node = ^ast_node_type;
        
        ast_node_type = record  
            value: string;
            _type: TOKEN_TYPE;
            left, right: ast_node;
        end;

        ast_tree = record 
            root: ast_node;
        end;



    function ast_tree_create(root: ast_node): ast_tree;
    function convert_token_to_node(token: token_t): ast_node;

    procedure traverse(ast: ast_tree);
    procedure ast_remove(current: ast_node); 

implementation

function node_create(value: string; _type: TOKEN_TYPE): ast_node;

    var result: ast_node;

    begin
        new(result);
        result^.value := value;
        result^._type := _type;
        result^.left := NIL;
        result^.right := NIL;
        node_create := result;
        result := NIL; 
    end;

function ast_tree_create(root: ast_node): ast_tree;

    var result: ast_tree;

    begin 
        result.root := root;
        ast_tree_create := result;
    end;

function convert_token_to_node(token: token_t): ast_node;

    begin
        convert_token_to_node := node_create(token^.value, token^._type);
    end;

function get_node_type(node: ast_node): TOKEN_TYPE;

    begin       
        get_node_type := node^._type; 
    end;

function get_node_value(node: ast_node): string;

    begin 
        get_node_value := node^.value;        
    end;

procedure node_print(node: ast_node);

    begin
        writeln(get_node_type(node), ' { ', get_node_value(node), ' }');
    end;

procedure node_remove(var node: ast_node);

    begin
        dispose(node);
        node := NIL; 
    end;

procedure print_indent(indent: integer);

    var i: integer;

    begin   
        for i := 1 to indent do 
            write('     '); 
    end;

procedure traverse(current: ast_node; indent: integer);

    begin
        if (current <> NIL) then 
            begin
                writeln('-- '  , '"', current^.value, '"');
                print_indent(indent + 1);
                traverse(current^.left, indent + 1);
                print_indent(indent + 1);
                traverse(current^.right, indent + 1);
                writeln();
            end;
    end;

procedure traverse(ast: ast_tree);

    begin
        traverse(ast.root, 0);
    end;


procedure ast_remove(current: ast_node); 

    var left, right: ast_node;

    begin 
        if (current <> NIL) then 
            begin
                left := current^.left;
                right := current^.right;
                dispose(current);
                ast_remove(left);
                ast_remove(right); 
            end;
    end;


begin 
end.