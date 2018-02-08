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

static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg)
{
	return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
	return (uint16_t) uc | (uint16_t) color << 8;
}

size_t strlen(const char* str)
{
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;

void terminal_initialize()
{
  uint16_t* terminal_buffer;
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = 0x0f;//vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	terminal_buffer = (uint16_t*) 0xB8000;

  size_t index;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry('y', terminal_color);
		}
	}
}

void main()
{
	/* Initialize terminal interface */
	terminal_initialize();
	/* Newline support is left as an exercise. */
	//terminal_writestring("Hello, kernel World!\n");
}

/*

void main() {
  clear_screen();
  char * video_memory = (char*) VIDEO_ADDRESS;
  *(video_memory) = 'X';
  // *(video_memory+3) = 0xf4;
  clear_screen();
  *(video_memory+41) = '8';
  *(video_memory+42) = 0xf4;
}

void clear_screen() {
  int screen_size = MAX_COLS * MAX_ROWS;
  int i;
  char *screen = VIDEO_ADDRESS;

  for (i=0; i<screen_size; i++) {
    screen[i*2] = 'x';
    screen[i*2+1] = 0xf0;
  }

  //set_cursor_offset(get_screen_offset(0, 0));
}
*/
