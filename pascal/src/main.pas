uses lexer, tokenizer, file_handle;

procedure main();

    var filename: string;
        file_content: string;

    begin
        filename := '../exemples/main.djo';
        get_tokens(filename);
    end;

begin 
    main();
end.