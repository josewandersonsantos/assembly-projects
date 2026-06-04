; nasm -felf64 hello_world.asm -o hello_world.o
; ld -o hello_world hello_world.o
; chmod u+x hello_world
; ./hello_world
global _start

section .data
msg: db 'hello, world!',10
section .text
_start:
    mov rax,1    ; comando write (syscall 1)
    mov rdi,1    ; onde escrever (stdout 1)
    mov rsi,msg  ; o que escrever, ponteiro de msg 
    mov rdx,14   ; quanto escrever, tamanho de msg
    syscall

    mov rax,60   ; comando exit (syscall 60)
    xor rdi,rdi
    syscall 
