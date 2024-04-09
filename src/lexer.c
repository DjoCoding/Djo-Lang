#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

#include "type.h"
#include "string.h"


typedef enum {
    STRING_LITERAL,
    INTEGER_LITERAL,
    CHAR_LITERAL,
    SEMICOLON,
    LEFT_PAR,
    RIGHT_PAR,
    PLUS, 
    MINUS,
    STAR, 
    SLASH,
    QUOTES,
    POINT,
    DOUBLEPOINT,
    KEYWORD
} TokenType;

const char *enum_elements[] = {"STRING_LITERAL",
    "INTEGER_LITERAL",
    "CHAR_LITERAL",
    "SEMICOLON",
    "LEFT_PAR",
    "RIGHT_PAR",
    "PLUS", 
    "MINUS",
    "STAR", 
    "SLASH",
    "QUOTES",
    "POINT",
    "DOUBLEPOINT",
    "KEYWORD"};

typedef struct {
    char *value;
    TokenType type;
} Token;

Token *create_Token(char *value, TokenType type) {
    Token *token;
    token -> value = value;
    token -> type = type;
    return token;
}

void destruct_Token(Token **token) {
    free((*token) -> value);
}

TokenType get_type(char c) {
    switch(c) {
        case ';': return SEMICOLON;
        case '.': return POINT;
        case '"': return QUOTES;
        case '(': return LEFT_PAR;
        case ')': return RIGHT_PAR;
        case '+': return PLUS;
        case '-': return MINUS;
        case '*': return STAR;
        case '/': return SLASH;
        default: return CHAR_LITERAL;
    }
}

void write_type(TokenType type) {
    printf("TOKEN TYPE: %s\n", enum_elements[type]);
}

void write_Token(Token *token) {
    printf("TOKEN VALUE: %s", token -> value);
    write_type(token -> type);
}

typedef struct {
    char *content;
    size_t content_size;
    size_t cursor;
    size_t line;
    size_t start;
    bool in_string;
} View;

View *create_view(char *content) {   
    View *view = (View *) malloc(sizeof(View)); 
    view -> content = content;
    view -> content_size = strlen(content);
    view -> cursor = 0;
    view -> line = 1;
    view -> start = 0; 
    view -> in_string = false;
    return view;
}

void destruct_view(View **view) {
    free((*view) -> content);
    free(*view);
    *view = NULL;
}

size_t get_view_start(View *view) {
    return view -> start;
}

char *get_view_content(View *view) {
    return (view -> content);
}

size_t get_view_cursor(View *view) {
    return (view -> cursor);
}

size_t get_view_content_size(View *view) {
    return (view -> content_size);
}

bool get_view_state(View *view) {
    return (view -> in_string);
}

void set_view_start(View *view, int start) {
    view -> start = start;
}

// EOF = -1
int get_current_char(View *view) {
    return get_view_content(view)[get_view_cursor(view)];
}

void set_view_cursor(View *view, size_t cursor) {
    view -> cursor = cursor;
}

void move_view_cursor(View *view) {
    set_view_cursor(view, get_view_cursor(view) + 1);
}

void inc_view_line(View *view) {
    (view -> line)++;
}

bool is_end(View *view) {
    return (get_view_cursor(view) >= get_view_content_size(view));
}

void set_view_state(View *view, bool state) {
    view -> in_string = state;
}

Token *get_next_token(View *view, char **value) {
    char c = get_current_char(view);

    if (isquote(c) || ispoint(c) || isdoublepoint(c) || iswhitespace(c) || issemi(c) || isleftpar(c) || isrightpar(c) || isoperator(c)) {
        *value = char_to_string(c);
        Token *token = create_Token(*value, get_type(c));
        set_view_cursor(view, get_view_cursor(view) + 1);
        set_view_start(view, get_view_cursor(view));
        if (isquote(c)) set_view_state(view, !get_view_state(view));
        return token;
    } 

    if (get_view_state(view)) {
        while ((!is_end(view)) && (!isquote(c))) {
            move_view_cursor(view);
            c = get_current_char(view);
        }
        *value = substring(get_view_content(view), get_view_start(view), get_view_cursor(view));
        Token *token = create_Token(*value, STRING_LITERAL);
        set_view_start(view, get_view_cursor(view));
        return token;
    }

    if (isdigit(c)) {
        while (!is_end(view) && isdigit(c)) {
            move_view_cursor(view);
            c = get_current_char(view);
        }
        *value = substring(get_view_content(view), get_view_start(view), get_view_cursor(view));
        Token *token = create_Token(*value, INTEGER_LITERAL);
        set_view_start(view, get_view_cursor(view));
        return token;
    }

    if (isalpha(c)) {
        while (!is_end(view) && isalpha(c)) {
            move_view_cursor(view);
            c = get_current_char(view);
        }
        *value = substring(get_view_content(view), get_view_start(view), get_view_cursor(view));
        Token *token = create_Token(*value, KEYWORD);
        set_view_start(view, get_view_cursor(view));
        return token;
    }

    if (isnewline(c)) {
        inc_view_line(view);
        set_view_cursor(view, get_view_cursor(view) + 1);
        set_view_start(view, get_view_cursor(view));
        return NULL; 
    }


    printf("ERROR FOUND, WRONG CHARACTER AT LINE %ld , THE CHAR IS: %c\n", view -> line, c);
    return NULL;
}

int main(void) {
    const char filename[] = "main.djo";
    char *file_content = file_to_string(filename);
    View *view = create_view(file_content);
    Token *token;
    char *value = NULL;
    while (!is_end(view)) {
        token = get_next_token(view, &value);
        write_Token(token);
        destruct_Token(&token);
    }
    destruct_view(&view);
}