#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>

#include "file.h"
#include "string.h"

#define NULL_TERMINATOR '\0'

typedef enum {
    _INTEGER,
    _CHAR,
    _WHITESPACE,
    _SEMI,
    _QUOTES,
    _OPENPAR,
    _CLOSEPAR,
} TokenType;

typedef struct {
    char *value;
    TokenType type;
} TokenLiteral;

char *get_number(View view) {
    char *buffer = (char *) malloc(sizeof(char) * (256));
    int size = 0;
    char c = get_next_char(view);

    while (c != EOF) {
        if(!isdigit(c)) break;
        buffer[size++] = c;
        move_cursor(&view);
        c = get_next_char(view);
    }
    view.cursor--;
    buffer[size] = NULL_TERMINATOR;
    return buffer;
}

void Lexer(char *filename) {
    char *file_content = file_to_string(filename);
    View view = create_view(file_content);
    char *buffer;

    int c = get_next_char(view);
    
    while (c != NULL_TERMINATOR) {
        if (isdigit(c)) { 
            buffer = get_number(view);
            printf("buffer is: %s\n", buffer);
        }
        c = get_next_char(view);
        move_cursor(&view);
    }

    free(buffer);
    free(file_content);
}


int main(void) {
    char filename[] = "main.djo";
    Lexer(filename);

    return 0;
}