/* See LICENSE file for the license details of MIT */
/* Copyright 2020 Marno van der Maas */

OUTPUT_ARCH( "riscv" )

__mem   = 0xC0000000; /* Compile starting with 8 for simulation or C for hardware */

SECTIONS
{
    . = __mem;

    /* code segment */
    .text : {
        *(.text.init) /* add the instruction from init.s */
        *(.text) /* add the instructions compiled from enclave.c */
    }

    . = ALIGN(0x1000);
    .tohost : { *(.tohost) }

    . = ALIGN(0x1000);
    /* data segment */
    .data : { *(.data) }
    .sdata : { *(.sdata) }
    .sbss : { *(.sbss) }
    .bss : { *(.bss) }
    _end = .;
}
