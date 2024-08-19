#!/bin/bash

cd bootloader
./compile.sh
cd ..

cd kernel
./compile.sh
cd ..

echo "Creating ISO image..."
mkdir -p iso-files
cp bootloader/build/ iso-files/
cp kernel/build/kernel.elf64 iso-files/kernel.elf64
mkisofs -R -b stage1.bin -no-emul-boot -boot-load-size 4 -boot-info-table -o dist/OS.iso iso-files