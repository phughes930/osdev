#include "include/types.h"
#include <stdint.h>
#include <system.h>

struct seg_desc {
    u16 limit0;
    u16 base0;
    u8 base1;
    u8 access;
    u8 fl;
    u8 base2;
} __attribute__((packed));