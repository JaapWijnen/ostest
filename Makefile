C_SOURCES = $(wildcard kernel/*.c wildcard drivers/*.c)
HEADERS = $(wildcard kernel/*.h wildcard drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

CC = x86_64-elf-gcc
LD = x86_64-elf-ld
GDB = x86_64-elf-gdb
QEMU = qemu-system-x86_64

CFLAGS = -g -Wall -std=gnu99 -ffreestanding

EXEC = os-image

all: ${EXEC}

run: all
	${QEMU} -fda ${EXEC}

debug: ${EXEC} kernel.elf
	${QEMU} -s -S -fda ${EXEC} &
	${GDB} -ex "set architecture i386:x86_64" -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

${EXEC}: boot/boot_sect.bin kernel.bin
	cat $^ > ${EXEC}

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
	rm -fr *.bin *.o ${EXEC} *.elf
	rm -fr kernel/*.o boot/*.bin 
