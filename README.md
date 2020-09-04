# Bare bones

A simple kernel for a 32-bit x86, following the OS Dev Wiki article.

## Usage

You need to build a cross-compiler for the target system...

Assemble the bootloader:

```bash
$ i686-elf-as boot.s -o boot.o
```

Compile the kernel:

```bash
$ i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
```

Link the kernel:

```bash
i686-elf-gcc -T linker.ld -o sos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
```

Test the OS with QEMU:

```bash
$ qemu-system-i386 -kernel myos.bin
```
