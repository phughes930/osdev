#include <system.h>

void timer_phase(int hz) {
    int divisor = 1193180 / hz;

    outportb(0x43, 0x36);           // command byte 0011 0110
    outportb(0x40, divisor & 0xFF); // set low byte of divisor
    outportb(0x40, divisor >> 8);   // set high byte of divisor
}

/* track num ticks system has been running for */
int timer_ticks = 0;

/* handles the timer
 *  increments timer_ticks every time timer fires
 */
void timer_handler(struct regs *r) {
    timer_ticks++;

    if (timer_ticks % 18 == 0) {
        term_putstring("One second has passed", 21);
    }
}

/* sets up the system clock by installing the timer handler into IRQ0 */
void timer_install() {
    irq_install_handler(0, timer_handler);
}
