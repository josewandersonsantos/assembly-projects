global _start

section .data
    item db 'A'     ; char to print
    eof db 0x0A     ; break line.. Can i change this?

section .text

_start:
    MOV ECX, 0x0F   ; quantity of steps
    JMP loop

loop:
    PUSH ECX        ; put ECX value on stack

    ; print character
    MOV  EAX, 0x04  ; syscall (sys_write)
    MOV  EBX, 0x01  ; file descriptor (std_out)
    MOV  ECX, item  ; address of char to print
    MOV  EDX, 0x01  ; size of char
    INT  0x80       ; syscall

    ; verify loop condition
    POP ECX         ; get ECX value from stack
    DEC ECX         ; decrement ECX value
    JNZ loop        ; verify if ECX is zero

    ; print break line
    MOV  EAX, 0x04  ; syscall (sys_write)
    MOV  EBX, 0x01  ; file descriptor (std_out)
    MOV  ECX, eof   ; char to print (EOF)
    MOV  EDX, 0x01  ; size of char
    INT  0x80       ; syscall

exit:
    MOV EAX, 0x01   ; syscall (sys_exit) 
    XOR EBX, EBX    ; put zero value to return to kernel
    INT 0x80        ; syscall
