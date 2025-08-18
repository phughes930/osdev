#include <system.h>

struct gdt_entry {
    unsigned short limit_lo;
    unsigned short base_lo;
    unsigned char base_mid;
    unsigned char access;
    unsigned char flags_lim;
    unsigned char base_hi;
} __attribute__((packed));

struct gdt_ptr {
    unsigned short size;
    unsigned long offset;
} __attribute((packed));

struct gdt_entry gdt[6];
struct gdt_ptr gdtp;
struct tss {
    unsigned short prev_task_link;
    unsigned short reserved1;
    unsigned long esp0;
    unsigned short ss0;
    unsigned short reserved2;
    unsigned long esp1;
    unsigned short ss1;
    unsigned short reserved3;
    unsigned long esp2;
    unsigned short ss2;
    unsigned short reserved4;
    unsigned long cr3;
    unsigned long eip;
    unsigned long eflags;
    unsigned long eax, ecx, edx, ebx;
    unsigned long esp, ebp, esi, edi;
    unsigned short es, reserved5;
    unsigned short cs, reserved6;
    unsigned short ss, reserved7;
    unsigned short ds, reserved8;
    unsigned short fs, reserved9;
    unsigned short gs, reserved10;
    unsigned short ldt_segment_selector;
    unsigned short reserved11;
    unsigned short trap_flag;
    unsigned short io_map_base_address;
} __attribute__((packed));

void gdt_set_gate(int num, unsigned long base, unsigned short lim, unsigned char access, unsigned char flags_lim) {
    gdt[num].base_lo = (base & 0xFFFF);
    gdt[num].base_mid = (base >> 16) & 0xFF;
    gdt[num].base_hi = (base >> 24) & 0xFF;

    gdt[num].access = access;
    gdt[num].flags_lim = flags_lim;

    gdt[num].limit_lo = lim;
}

extern void load_gdt();

void gdt_install() {

    // set up gdt_pointer
    gdtp.offset = (unsigned long)&gdt;
    gdtp.size = sizeof(struct gdt_entry) * 6 - 1;
    load_gdt();

    // install null descriptor
    gdt_set_gate(0, 0, 0, 0, 0);

    // install kernel segments
    //  code
    gdt_set_gate(1, 0, 0xFFFF, 0x9A, 0xCF);
    //  data
    gdt_set_gate(2, 0, 0xFFFF, 0x92, 0xCF);

    // install user segments
    //  code
    gdt_set_gate(3, 0, 0xFFFF, 0xFA, 0xCF);
    //  data
    gdt_set_gate(4, 0, 0xFFFF, 0xF2, 0xCF);

    // install task state segment
    // unsigned long tss_base = (unsigned long)&tss;
    // gdt_set_gate(5, tss_base, 104, 0x89, 0x00);
}