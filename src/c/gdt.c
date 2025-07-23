#include "../include/types.h"
#include <stdint.h>

struct seg_desc {
    u16 limit0;
    u16 base0;
    u8 base1;
    u8 access;
    u8 fl;
    u8 base2;
} __attribute__((packed));

struct gdt_desc {
    u16 size;
    u32 offset;
};

struct seg_desc gdt[3];
struct gdt_desc ptr;

void set_global_desc_segment(int num, u32 limit, u32 base, u8 access, u8 fl) {
    gdt[num].limit0 = (limit & 0xFFFF);
    gdt[num].fl = (limit >> 16) & 0x0F;

    gdt[num].base0 = (base & 0xFFFF);
    gdt[num].base1 = (base >> 16) & 0xFF;
    gdt[num].base2 = (base >> 24) & 0xFF;

    gdt[num].fl |= (fl & 0xF0);
    gdt[num].access = access;
}

void set_gdt_descriptor() {
    ptr.size = (sizeof(struct seg_desc) * 3) - 1;
    ptr.offset = (uint32_t)&gdt;
}

void install_gdt() {
    set_gdt_descriptor();

    set_global_desc_segment(0, 0, 0, 0, 0);
    set_global_desc_segment(
        1,
        0xFFFFFFFF,
        0,
        0x9A,
        0xCF);
    set_global_desc_segment(
        2,
        0xFFFFFFFF,
        0,
        0x92,
        0xCF);
}