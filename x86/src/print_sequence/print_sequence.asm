global _start

section .data
    output db '0'

section .text
_start:
    MOV ECX, 0x0A

L1:
    MOV byte DL, output[0]
    INC byte DL
    MOV byte output[0], DL
    
    PUSH ECX

    MOV EAX, 0x04 ; sys_write
    MOV EBX, 0x01 ; stdout
    MOV ECX, output
    MOV EDX, 0x01
    INT 0x80

    POP ECX
    LOOP L1

EXIT:
    MOV EAX, 0x01 ; sys_exit
    XOR EBX, EBX
    INT 0x80