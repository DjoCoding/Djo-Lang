unit QUEUE;

interface

    uses ASTF;
    
    const MAX_SIZE = 10;

    type 
        queue_t = ^queue_type;
        queue_type = record 
            nodes: array[1..MAX_SIZE] of ast_node;
            back: integer;
        end;
    
    procedure bfs(ast: ast_tree);

implementation

function queue_init(): queue_t;

    var result: queue_t;

    begin
        new(result);
        result^.back := 0;
        queue_init := result;
        result := NIL; 
    end;

function is_empty(queue: queue_t): boolean;

    begin
        is_empty := (queue^.back = 0); 
    end;

function is_full(queue: queue_t): boolean;

    begin
        is_full := (queue^.back = MAX_SIZE);
    end;

procedure enqueue(queue: queue_t; node: ast_node);

    begin
        if (is_full(queue)) then 
            begin 
                writeln('QUEUE IS FULL!');
                exit();
            end;
        
        inc(queue^.back);
        queue^.nodes[queue^.back] := node;
    end;

function dequeue(queue: queue_t): ast_node;

    var i: integer;

    begin
        dequeue := (queue^.nodes[1]);
        dec(queue^.back); 
        for i := 1 to queue^.back do 
            queue^.nodes[i] := queue^.nodes[i + 1];
    end;

procedure queue_remove(var queue: queue_t);

    begin
        dispose(queue);
        queue := NIL; 
    end;

procedure print_indent(indent: integer);

    var i: integer;

    begin
        for i := 1 to indent do 
            write(' ');
    end;

procedure bfs(ast: ast_tree);

    var queue: queue_t;
        current: ast_node;
        indent, count, num_nodes: integer;

    begin
        queue := queue_init(); 
        enqueue(queue, ast.root);
        num_nodes := 1;
        count := 0;
        indent := 20;
        print_indent(indent + 1);

        while not ((is_empty(queue)) or (is_full(queue))) do 
            begin
                current := dequeue(queue);
                inc(count);
                if (current <> NIL) then 
                    begin
                        enqueue(queue, current^.left);
                        enqueue(queue, current^.right);
                        write(current^.value, '   '); 
                    end
                else 
                    begin 
                        write('  ');
                        enqueue(queue, NIL);
                        enqueue(queue, NIL);
                    end;
                if (count = num_nodes) then 
                    begin
                        writeln();
                        print_indent(indent);
                        num_nodes := num_nodes * 2;
                        count := 0;
                        indent := indent - 2;
                    end;
            end;
        queue_remove(queue);
    end;

begin 
end.

