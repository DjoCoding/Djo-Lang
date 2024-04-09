#include <stdio.h>
#include <stdbool.h>

bool iswhitespace(char c)  {
    return (c == ' ');
}
bool issemi(char c) {
    return (c == ';');
}
bool isleftpar(char c) {
    return (c == '(');
}
bool isrightpar(char c) {
    return (c == ')');
}
bool isquote(char c) {  
    return (c == '"');
}

bool isoperator(char c) {
    return ((c == '+') || (c == '-') || (c == '*') || (c == '/'));
}

bool isnewline(char c) {
    return (c == '\n');
}

bool isdoublepoint(char c) {
    return (c == ':');
}

bool ispoint(char c) {
    return (c == '.');
}