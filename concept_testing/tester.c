#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int mystrlen(const char *str) {
    int count = 0;
    while (str[count] != '\0') {
        count++;
    }
    return count;
}

unsigned char *mymemset(unsigned char *dest, unsigned char val, int count) {
    unsigned char *p = dest;
    for (int i = 0; i < count; i++) {
        *p++ = val;
    }
    return dest;
}

int main() {
    char *string1 = "Hello World";

    size_t len = mystrlen(string1);
    printf("string len is %zu\n", len);

    char *new_str = (char *)malloc(12);
    strcpy(new_str, string1);
    unsigned char *loc = mymemset((unsigned char *)new_str, ' ', 11);
    printf("new string is '%s'\n", new_str);
    return 0;
}