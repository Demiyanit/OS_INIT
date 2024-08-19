#!/bin/bash

echo "Compiling stage 2..."
cd src
ASM_FILES=$(find . -name "*.asm")
ASM_FILES+=$(find . -name "*.ASM")
ASM_FILES+=$(find . -name "*.s")
ASM_FILES+=$(find . -name "*.S")
C_FILES=$(find . -name "*.c")
cd ..
ASM_FLAGS='-f elf '
C_FLAGS='-ffreestanding -nostdlib -I include'
LD_FLAGS='-T link.ld -nostdlib'

CC=../../tools/i686-elf-tools/bin/i686-elf-gcc
LD=../../tools/i686-elf-tools/bin/i686-elf-ld
for file in ${ASM_FILES};
do
	nasm $ASM_FLAGS src/$file -o ../obj/stage2/$file.o
done

for file in ${C_FILES};
do
	# -c compile only, no link
	$CC $C_FLAGS -c src/$file -o ../obj/stage2/$file.o
done

OBJECTS=$(find ../obj/stage2 -name "*.o")
echo ${OBJECTS}
${LD} ${LD_FLAGS} -o ../build/stage2.bin ${OBJECTS}