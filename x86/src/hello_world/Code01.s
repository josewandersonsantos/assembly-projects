.global _start
.intel_syntax noprefix

.section .data
hello_str: .asciz "hello, world!\n"

_start:
    CALL print_hello_world
    JMP exit

print_hello_world:
    MOV rax, 0x01
    MOV rdi, 0x01
    LEA rsi, [hello_str]
    MOV rdx, 14
    SYSCALL
    RET

exit:
    MOV rax, 0x3C
    MOV rdi, 1
    SYSCALL