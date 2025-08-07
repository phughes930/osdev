unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count) {
    unsigned char *dest_cpy = dest;
    for (int i = 0; i < count; src++, dest_cpy++) {
        *dest_cpy = *src;
    }
    return dest;
}

unsigned char *memset(unsigned char *dest, unsigned char val, int count) {
    unsigned char *p = dest;
    for (int i = 0; i < count; i++) {
        *p++ = val;
    }
    return dest;
}

unsigned short *memsetw(unsigned short *dest, unsigned short val, int count) {
    unsigned short *p = dest;
    for (int i = 0; i < count; i += 2) {
        *p = val;
        p += 2;
    }
    return dest;
}

int strlen(const char *str) {
    int count = 0;
    while (str[count] != '\0') {
        count++;
    }
    return count;
}
/* We will use this later on for reading from the I/O ports to get data
 *  from devices such as the keyboard. We are using what is called
 *  'inline assembly' in these routines to actually do the work */
unsigned char inportb(unsigned short _port) {
    unsigned char rv;
    asm volatile("inb %1, %0" : "=a"(rv) : "dN"(_port));
    return rv;
}
/* We will use this to write to I/O ports to send bytes to devices. This
 *  will be used in the next tutorial for changing the textmode cursor
 *  position. Again, we use some inline assembly for the stuff that simply
 *  cannot be done in C */
void outportb(unsigned short _port, unsigned char _data) {
    asm volatile("outb %1, %0" : : "dN"(_port), "a"(_data));
}