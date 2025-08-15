#ifndef __SYSTEM_H
#define __SYSTEM_H

/* MAIN.C */
extern unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count);
extern unsigned char *memset(unsigned char *dest, unsigned char val, int count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
extern int strlen(const char *str);
extern unsigned char inportb(unsigned short _port);
extern void outportb(unsigned short _port, unsigned char _data);

/* KERNEL.C */
extern void cls();
extern void term_putchar(char c);
extern void term_putstring(const char *string, int len, ...);
extern void term_init();
extern void term_main();

/* IDT.C */
void idt_set_gate(unsigned char num, unsigned long base, unsigned char flags, unsigned char sel);
void idt_install();

/* ISRS.C */
struct regs {
    unsigned int gs, fs, es, ds;
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;
    unsigned int int_no, err_no;
    unsigned int eip, cs, eflags, useresp, ss;
};
void isrs_install();

/* IRQS.C */
void irq_install();
void irq_install_handler(int irq, void (*handler)(struct regs *r));
void irq_uninstall_handler(int irq);

/* CLOCK.C */
void timer_phase(int hz);
void timer_install();

#endif