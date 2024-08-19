#!/bin/bash

if [ "$1" = "-u" ]; then
	wget https://github.com/Demiyanit/OS_INIT/init.sh
	chmod +x ./init.sh
	exit 0
fi

echo "Initializing..."

echo "Creating folders and files..."
mkdir -p ./bootloader
# Both C and ASM files will be stored in the src folder
mkdir -p ./bootloader/stage1
mkdir -p ./bootloader/stage1/src
mkdir -p ./bootloader/stage2
mkdir -p ./bootloader/stage2/src
mkdir -p ./bootloader/build
mkdir -p ./bootloader/obj	
mkdir -p ./bootloader/obj/stage1	
mkdir -p ./bootloader/obj/stage2	
mkdir -p ./kernel
mkdir -p ./kernel/src
mkdir -p ./kernel/obj
mkdir -p ./kernel/build
mkdir -p ./dist
echo "Done"


echo "Installing dependencies..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo apt install make build-essential nasm genisoimage wget -y
else
	# Use pacman
	sudo pacman -Sy make build-essential nasm cdrtools wget gcc
fi

echo "Installing gcc-cross compiler $GCC_VERSION and binutils $BINUTILS_VERSION..."

if [ -d "./tools/build-i686-elf" ]; then
	echo "gcc is already installed, skipping"
else
# Install gcc and binutils locally in tools folder
mkdir -p ./tools
cd ./tools
wget https://github.com/Demiyanit/OS_INIT/tools/i686-elf.sh
./i686-elf.sh linux binutils gcc gdb
mkdir i686-elf-tools
cp -r ./build-i686-elf/linux/output/* ./i686-elf-tools/
rm -rf ./build-i686-elf
echo "Done!"
fi
exit 0
echo "Creating OS files..."

wget https://github.com/Demiyanit/OS_INIT/compile.sh
chmod +x ./compile.sh

cd ./bootloader
wget https://github.com/Demiyanit/OS_INIT/bootloader/compile.sh
chmod +x ./compile.sh
cd stage1
wget https://github.com/Demiyanit/OS_INIT/bootloader/stage1/compile.sh
chmod +x ./compile.sh
cd src
wget https://github.com/Demiyanit/OS_INIT/bootloader/stage1/src/entry.asm
cd ../../stage2
wget https://github.com/Demiyanit/OS_INIT/bootloader/stage2/compile.sh
wget https://github.com/Demiyanit/OS_INIT/bootloader/stage2/link.ld
chmod +x ./compile.sh
cd src
wget https://github.com/Demiyanit/OS_INIT/bootloader/stage2/src/entry.asm
wget https://github.com/Demiyanit/OS_INIT/bootloader/stage2/src/entry.c
cd ../../../kernel
wget https://github.com/Demiyanit/OS_INIT/kernel/compile.sh
wget https://github.com/Demiyanit/OS_INIT/kernel/link.ld
chmod +x ./compile.sh
cd src
wget https://github.com/Demiyanit/OS_INIT/kernel/src/entry.c
cd ../../../
echo "Done!"