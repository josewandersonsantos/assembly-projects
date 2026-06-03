.global _start
.intel_syntax noprefix

.extern WriteFile
.extern ExitProcess

.section .data
hello_str: .asciz "hello, world!\n"
hStdOut: .quad 0xFFFFFFF5

.section .text
_start:
    CALL print_hello_world
    JMP exit

print_hello_world:
    MOV rdi, [hStdOut]
    LEA rsi, [hello_str]
    MOV rdx, 14
    MOV rax, 0x0
    CALL WriteFile
    RET

exit:
    MOV rdi, 0
    CALL ExitProcess
