#!/bin/bash

echo "Compiling bootloader..."
echo "The result should be 3 binary files, 2 is bootloader parts, bootloader.bin is them merged and bootloader.img is the boot image that will be used in the ISO"
cd stage1
./compile.sh
cd ../stage2
./compile.sh
cd ..
cd build
cat stage1.bin stage2.bin > bootloader.bin
dd if=/dev/zero of=floppy.img bs=1024 count=1440
dd if=bootloader.bin of=floppy.img seek=0 count=2880 conv=notrunc
cd ..
echo "Done!"