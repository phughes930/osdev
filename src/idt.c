#include "system.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

struct idt_entry {
    unsigned short base_low;
    unsigned short sel;
    unsigned char always0;
    unsigned char flags;
    unsigned short base_high;
} __attribute__((packed));

struct idt_ptr {
    unsigned short limit;
    unsigned int base;
} __attribute__((packed));

struct idt_entry idt[256];
struct idt_ptr idtp;

extern void idt_load();

void idt_set_gate(unsigned char num,
                  unsigned long base,
                  unsigned char flags,
                  unsigned char sel) {
    idt[num].base_low = base & 0xFFFF;
    idt[num].base_high = (base >> 16) & 0xFFFF;
    idt[num].sel = sel;
    idt[num].flags = flags;
    idt[num].always0 = 0U;
}

void idt_install() {
    idtp.limit = (sizeof(struct idt_entry) * 256) - 1;
    idtp.base = (unsigned int)&idt;

    memset(
        (unsigned char *)&idt,
        0,
        sizeof(struct idt_entry) * 256);

    idt_load();
}