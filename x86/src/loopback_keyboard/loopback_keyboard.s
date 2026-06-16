global _start:

segment .data
    buffer db 100 dup(0) ; buffer to store input, initialized to 0

segment .text
_start:

    ; Read up to 100 bytes from standard input (stdin)

    MOV EAX, 3          ; syscall: sys_read
    MOV EBX, 0          ; file descriptor: stdin
    MOV ECX, buffer     ; buffer to store input
    MOV EDX, 100        ; number of bytes to read
    INT 0x80            ; call kernel
    ; SYSCALL

    ; Save the number of bytes actually read
    ; sys_read returns this value in EAX

    MOV EDX, EAX        ; Number of bytes to write

    CALL print_input    ; call the function to print the input


print_input:
    MOV EAX, 4          ; syscall: sys_write
    MOV EBX, 1          ; file descriptor: stdout
    MOV ECX, buffer     ; buffer to write
    INT 0x80            ; call kernel
    ; SYSCALL

    CALL exit           ; call the function to exit the program

exit:
    MOV EAX, 1          ; syscall: sys_exit
    XOR EBX, EBX        ; status: 0
    INT 0x80            ; call kernel
    ; SYSCALL