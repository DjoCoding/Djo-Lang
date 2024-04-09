#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NULL_TERMINATOR '\0'

char *substring(char *string, int start, int end) {
    int length = end - start;
    char *result = (char *)malloc(sizeof(char) * (length + 1));
    for (int i = 0; i < length; i++) {
        result[i] = string[start + i];
    }
    result[length] = NULL_TERMINATOR;

    return result;
}

char *char_to_string(char c) {
    char *result = (char *)malloc(sizeof(char) * 2);
    result[0] = c;
    result[1] = NULL_TERMINATOR;

    return result;
}

char *file_to_string(const char *filename) {
    FILE *file = fopen(filename, "r");

    fseek(file, 0, SEEK_END);
    size_t size = ftell(file);
    fseek(file, 0, SEEK_SET);

    char *result = (char *)malloc(sizeof(char) * (size + 1));
    fread(result, sizeof(char), size, file);
    result[size] = NULL_TERMINATOR;

    fclose(file);

    return result;
}