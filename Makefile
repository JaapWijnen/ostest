C_SOURCES = $(wildcard kernel/*.c wildcard drivers/*.c)
HEADERS = $(wildcard kernel/*.h wildcard drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

CC = x86_64-elf-gcc
LD = x86_64-elf-ld
GDB = x86_64-elf-gdb
QEMU = qemu-system-x86_64

CFLAGS = -g -Wall -std=gnu99 -ffreestanding

all: moOS-image

run: all
	${QEMU} -fda moOS-image

debug: moOS-image kernel.elf
	${QEMU} -s -S -fda moOS-image &
	${GDB} -ex "set architecture i386:x86_64" -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

moOS-image: boot/boot_sect.bin kernel.bin
	cat $^ > moOS-image

kernel.bin: kernel/kernel_entry.o ${OBJ}
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

# for debugging purposes
kernel.elf: kernel/kernel_entry.o ${OBJ}
	${LD} -o $@ -Ttext 0x1000 $^

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@

%.o: %.asm
	nasm $< -f elf64 -o $@

%.bin: %.asm
	nasm $< -f bin -I './boot/' -o $@

clean:
	rm -fr *.bin *.o moOS-image *.elf
	rm -fr kernel/*.o boot/*.bin drivers/*.o
