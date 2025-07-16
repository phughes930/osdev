#include <stdlib.h>

struct struct_example {
    short x;         // 2 byte
    long y;          // 4 byte
    float z;         // 4 byte
    unsigned char k; // 1 byte
};
// size = 16 bytes

void init_struct(struct struct_example **ptr) {
    *(ptr) = (struct struct_example *)malloc(
        sizeof(struct struct_example));
    (*ptr)->x = 127;
    (*ptr)->y = 32764;
    (*ptr)->z = 45613.523;
    (*ptr)->k = 64;
}