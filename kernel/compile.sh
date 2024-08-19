#!/bin/bash

echo "Compiling kernel..."

ASM_FILES =  $(find ./src -name "*.asm")
ASM_FILES += $(find ./src -name "*.ASM")
ASM_FILES += $(find ./src -name "*.s")
ASM_FILES += $(find ./src -name "*.S")
C_FILES = $(find ./src -name "*.c")
CXX_FILES = $(find ./src -name "*.cpp")

ASM_FLAGS = -f elf64
C_FLAGS = -ffreestanding -nostdlib
LD_FLAGS = -T linker.ld -nostdlib
for file in ${ASM_FILES};
do
	nasm $ASM_FLAGS $file -o ../obj/kernel/$file.o
done

OBJECTS = $(find ./obj/kernel -name "*.o")
ld ${LD_FLAGS} -o ../build/kernel.elf64 ${OBJECTS}

echo "Done!"