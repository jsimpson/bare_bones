/* Declare constants for the multiboot header. */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of the above, to prove we are multiboot */

/* Declare a multiboot header that marks the program as a kernel.
 * These are magic values that are documented in the multiboot standard. The bootloader
 * will search for this signature in the firt 8 KiB of the ketnel file, aligned at a
 * 32-bit boundary. The signature is in its own section so the header can be forced to
 * be within the first 8 KiB of the kernel file.
 */
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/* The multiboot standard does not define the value of the stack pointer register (esp)
 * and it is up to the kernel to provide a stack. This allocates room for a small stack
 * by creating a symbol at the top. The stack grows downwards on x86. The stack is in
 * its own section so it can be marked nobits, which means the kernel file is smaller
 * because it does not contain an uninitialized stack. The stack on x86 must be 16-byte
 * aligned according to the System V ABI standard and de-facto extensions. The compiler
 * will assume the stack is properly aligned and failure to align the stack will result
 * in undefined behavior.
 */
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

.section .text
.global _start
.type _start, @function
_start:
    mov $stack_top, %esp
    call kernel_main
    cli
1:  hlt
    jmp 1b

.size _start, . - _start