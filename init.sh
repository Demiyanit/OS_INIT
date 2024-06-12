#!/bin/bash

if [ "$1" = "-u" ]; then
	wget https://raw.githubusercontent.com/michael-seifrieds-coding-hub/OS_Bootloader/main/init.sh
fi


set GCC_VERSION=13.2.0
set BINUTILS_VERSION=2.41
set OS_NAME=OS

echo "Initializing..."

echo "Creating folders and files..."
mkdir -p ./bootloader
# Both C and ASM files will be stored in the src folder
mkdir -p ./bootloader/src
mkdir -p ./bootloader/obj
mkdir -p ./bootloader/build
mkdir -p ./kernel
mkdir -p ./kernel/src
mkdir -p ./kernel/obj
mkdir -p ./kernel/build
mkdir -p ./dist
mkdir -p ./tools
echo "Done"

echo "Installing dependencies..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# Use apt
	sudo apt update
	sudo apt install make build-essential nasm genisoimage wget gcc libgmp3-dev libmpfr-dev libisl-dev libmpc-dev texinfo bison flex bzip2 patch -y
else
	# Use pacman
	sudo pacman -Sy make build-essential nasm cdrtools wget gcc libgmp3-dev libmpfr-dev libisl-dev libmpc-dev texinfo bison flex bzip2 patch
fi

echo "Installing gcc-cross compiler $GCC_VERSION and binutils $BINUTILS_VERSION..."

# Install gcc and binutils locally in tools folder
cd ./tools
wget -q https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.gz
wget -q https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
tar zxf binutils-${BINUTILS_VERSION}.tar.gz
tar zxf gcc-${GCC_VERSION}.tar.gz
rm binutils-${BINUTILS_VERSION}.tar.gz gcc-${GCC_VERSION}.tar.gz
cd binutils-${BINUTILS_VERSION}
mkdir build
cd build
../configure --prefix=$(pwd)/..
make -j$(nproc)
make install
cd ../../gcc-${GCC_VERSION}
mkdir build
cd build
../configure --prefix=$(pwd)/.. --with-newlib --target=i686-pc-elf --disable-nls --enable-languages=c,c++ --without-headers
make -j$(nproc) all-gcc
make -j$(nproc) all-target-libgcc
make install

echo "Done!"