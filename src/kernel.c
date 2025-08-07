#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

enum vga_color {
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GREY = 7,
    VGA_COLOR_DARK_GREY = 8,
    VGA_COLOR_LIGHT_BLUE = 9,
    VGA_COLOR_LIGHT_GREEN = 10,
    VGA_COLOR_LIGHT_CYAN = 11,
    VGA_COLOR_LIGHT_RED = 12,
    VGA_COLOR_LIGHT_MAGENTA = 13,
    VGA_COLOR_LIGHT_BROWN = 14,
    VGA_COLOR_WHITE = 15,
};

uint8_t vga_color(enum vga_color fg, enum vga_color bg) {
    uint16_t new_bg = bg << 4;
    uint16_t color = fg | new_bg;
    return color;
}

uint16_t vga_entry(uint8_t color, unsigned char c) {
    uint16_t big_color = color << 8;
    uint16_t entry = c | big_color;
    return entry;
}

size_t mystrlen(char *str) {
    size_t len = 0;
    while (str[len++] != '\0')
        ;
    return len;
}

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_MEM    0xB8000

size_t term_x;
size_t term_y;
uint8_t term_color;
uint16_t *term_mem = (uint16_t *)VGA_MEM;

size_t get_index(size_t x, size_t y) {
    size_t index = y * 80 + x;
    return index;
}

void cls() {
    for (int y = 0; y < VGA_HEIGHT; y++) {
        for (int x = 0; x < VGA_WIDTH; x++) {
            size_t index = get_index(x, y);
            *(term_mem + index) = vga_entry(term_color, ' ');
        }
    }
}

void term_init() {
    term_x = 0;
    term_y = 0;
    term_color = vga_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);

    // cls();
}

void term_putc_at(size_t x, size_t y, uint16_t entry) {
    size_t index = get_index(x, y);
    *(term_mem + index) = entry;
}

void term_putchar(char c) {
    uint16_t entry = vga_entry(term_color, c);
    term_putc_at(term_x, term_y, entry);
    term_x++;
    if (term_x >= 80) {
        term_x = 0;
        term_y++;
    }
    if (term_y >= VGA_HEIGHT) {
        cls();
        term_y = 0;
    }
}

void term_main() {
    term_init();
}