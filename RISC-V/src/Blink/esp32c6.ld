SECTIONS
{
    . = 0x42000000;
    .text : { *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss) }
}