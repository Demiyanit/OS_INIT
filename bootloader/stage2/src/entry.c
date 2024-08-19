#include <print.h>

void bootloader_entry() {
	print_clear();
	print_str("Hello, World!\n");
}