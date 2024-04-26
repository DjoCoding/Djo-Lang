unit errorf;

interface

    uses LEXERF;

    type 
        ERROR_TYPE = (TOKEN_ERROR);
    
    procedure generate_lexer_error(error: ERROR_TYPE; lexer: lexer_t);    
    // procedure generate_parser_error(error: ERROR_TYPE; parser: parser_t);

implementation

procedure generate_lexer_error(error: ERROR_TYPE; lexer: lexer_t);
    
    var i: integer;

    begin
        writeln();
        case error of 
            TOKEN_ERROR: 
                begin  
                    writeln('ERROR:      UNEXPECTED TOKEN FOUND ');
                    writeln('=>' , '           ''', lexer_peek(lexer), '''' , ' at index: ', lexer^.current_index);
                    writeln();
                    writeln(lexer^.content);
                    for i := 1 to lexer^.current_index - 1 do 
                        write(' ');
                    writeln('^');
                    writeln();
                end;
        end;
        writeln();
    end;

// procedure generate_parser_error(error: ERROR_TYPE; parser: parser_t);

    // begin
    //     writeln();
    //     case error of 
    //         TOKEN_ERROR: 
    //             begin  
    //                 writeln('EXPECTED TOKEN');
    //                 writeln();
    //             end;
    //     end;
    //     writeln();
    // end;

begin 
end.