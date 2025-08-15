#include <system.h>

void reverse(char *ptr, int len) {
    int i = 0;
    len--;

    while (i < len) {
        char temp = ptr[i];
        ptr[i] = ptr[len];
        ptr[len] = temp;
        i++;
        len--;
    }
}

void itoa(char *ptr, int num) {
    int i = 0;
    while (num > 0) {
        int rem = num % 10;
        ptr[i++] = '0' + rem;
        num /= 10;
    }
    reverse(ptr, i);
}