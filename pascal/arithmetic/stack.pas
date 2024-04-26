unit STACK;

interface 

    type    
        node_t = ^node_type;
        node_type = record 
            value: string;
            next: node_t;
        end;

        stack_t = ^stack_type;
        stack_type = record 
            top: node_t;
        end;

    function stack_init(): stack_t;
    function is_empty(stack: stack_t): boolean;
    procedure push(stack: stack_t; value: string);
    function pop(stack: stack_t): string;
    function peek(stack: stack_t): string;    

implementation

function node_create(value: string): node_t;

    var result: node_t;

    begin
        new(result);
        result^.value := value;
        result^.next := NIL;
        node_create := result;
        result := NIL; 
    end;

function stack_init(): stack_t;

    var result: stack_t;

    begin
        new(result);
        result^.top := NIL;
        stack_init := result;
        result := NIL; 
    end;

function is_empty(stack: stack_t): boolean; 

    begin
        is_empty := (stack^.top = NIL); 
    end;

procedure push(stack: stack_t; value: string);

    var node: node_t;

    begin
        node := node_create(value);
        node^.next := stack^.top;
        stack^.top := node;
        node := NIL; 
    end;

function pop(stack: stack_t): string;

    var node: node_t;

    begin
        pop := stack^.top^.value;
        node := stack^.top;
        stack^.top := node^.next;
        dispose(node);
        node := NIL; 
    end;

function peek(stack: stack_t): string;

    begin
        peek := stack^.top^.value; 
    end;

begin 
end.