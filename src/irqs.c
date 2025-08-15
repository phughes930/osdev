#include <system.h>

extern void irq0();
extern void irq1();
extern void irq2();
extern void irq3();
extern void irq4();
extern void irq5();
extern void irq6();
extern void irq7();
extern void irq8();
extern void irq9();
extern void irq10();
extern void irq11();
extern void irq12();
extern void irq13();
extern void irq14();
extern void irq15();

/* Array of function pointers to handle custom IRQ handlers
 *  for a given IRQ */
void *irq_routines[16] = {
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0};

/* installs a custom IRQ handler for the given IRQ */
void irq_install_handler(int irq, void (*handler)(struct regs *r)) {
    irq_routines[irq] = handler;
}

/* clears the handler for a given IRQ */
void irq_uninstall_handler(int irq) {
    irq_routines[irq] = 0;
}

/* IRQs 0 to 7 are mapped to IDT entries 8 to 15
 *  Need to remap IRQs 0 to 15 to 32 to 47 instead */
void irq_remap() {
    // ICW 1: signals beginning of ICW seq. and says ICW 4 is needed
    outportb(0x20, 0x11); // send '17' to port 0x20 // ICW 1
    outportb(0xA0, 0x11); // send '17' to port 0xA0

    // ICW 2: interrupt vector address
    outportb(0x21, 0x20); // send '32' to port 0x21 // ICW 2
    outportb(0xA1, 0x28); // send '40' to port 0xA1

    // ICW 3: (master) IR2 has a slave, (slave) slave ID is 2
    outportb(0x21, 0x04); // send '4' to port 0x21 // ICW 3
    outportb(0xA1, 0x02); // send '2' to port 0xA1

    // ICW 4: sets 8086 mode
    outportb(0x21, 0x01); // send '1' to port 0x21 // ICW 4
    outportb(0xA1, 0x01); // send '1' to port 0xA1

    // OCW 1: resets all interrupt masks
    outportb(0x21, 0x0); // send '0' to port 0x21 // OCW 1
    outportb(0xA1, 0x0); // send '0' to port 0xA1
}

void irq_install() {
    irq_remap();

    idt_set_gate(32, (unsigned)irq0, 0x08, 0x8E);
    idt_set_gate(33, (unsigned)irq1, 0x08, 0x8E);
    idt_set_gate(34, (unsigned)irq2, 0x08, 0x8E);
    idt_set_gate(35, (unsigned)irq3, 0x08, 0x8E);
    idt_set_gate(36, (unsigned)irq4, 0x08, 0x8E);
    idt_set_gate(37, (unsigned)irq5, 0x08, 0x8E);
    idt_set_gate(38, (unsigned)irq6, 0x08, 0x8E);
    idt_set_gate(39, (unsigned)irq7, 0x08, 0x8E);
    idt_set_gate(40, (unsigned)irq8, 0x08, 0x8E);
    idt_set_gate(41, (unsigned)irq9, 0x08, 0x8E);
    idt_set_gate(42, (unsigned)irq10, 0x08, 0x8E);
    idt_set_gate(43, (unsigned)irq11, 0x08, 0x8E);
    idt_set_gate(44, (unsigned)irq12, 0x08, 0x8E);
    idt_set_gate(45, (unsigned)irq13, 0x08, 0x8E);
    idt_set_gate(46, (unsigned)irq14, 0x08, 0x8E);
    idt_set_gate(47, (unsigned)irq15, 0x08, 0x8E);
}

void irq_handler(struct regs *r) {
    // blank function pointer
    void (*handler)(struct regs *r);

    // find out if we have a custom handler for this IRQ
    // if so, run it
    handler = irq_routines[r->int_no - 32];
    if (handler) {
        handler(r);
    }

    /* If the IDT entry invoked was greater than 40, send EOI to
     *  slave PIC */
    if (r->int_no > 40) {
        outportb(0xA0, 0x20);
    }

    /* Send EOI to the master PIC */
    outportb(0x20, 0x20);
}