global _start

segment .bss
    input resb 1

segment .data
    msg_init db   "Insert the pivot: "
    len_init equ $- msg_init
    msg_equal db   "The input is equal to 0x05", 0x0A
    len_equal equ $- msg_equal
    msg_less db    "The input is less to 0x05", 0x0A
    len_less equ $- msg_less
    msg_greater db "The input is greater to 0x05", 0x0A
    len_greater equ $- msg_greater
    pivot db 0x05

segment .text
_start:
    MOV EAX, 0x04      ; sys_write
    MOV EBX, 0x01      ; stdout
    MOV ECX, msg_init  ; dst write
    MOV EDX, len_init  ; size write
    INT 0x80

    MOV EAX, 0x03      ; sys_read
    MOV EBX, 0x00      ; stdin
    MOV ECX, input     ; dst read
    MOV EDX, 0x02      ; size read
    INT 0x80
    
    ; convert ASCII to decimal
    MOV AL, [input]
    SUB AL, 0x30

    ; compare input 
    CMP AL, [pivot]
    JE EQUAL
    JL LESS
    JG GREATER

    JMP EXIT

EQUAL:
    MOV ECX, msg_equal ; dst write
    MOV EDX, len_equal ; size write
    CALL PRINT

    JMP EXIT
LESS:
    MOV ECX, msg_less  ; dst write
    MOV EDX, len_less  ; size write
    CALL PRINT

    JMP EXIT
GREATER:
    MOV ECX, msg_greater  ; dst write
    MOV EDX, len_greater  ; size write
    CALL PRINT
    
    JMP EXIT
PRINT:
    MOV EAX, 0x04      ; sys_write
    MOV EBX, 0x01      ; stdout
    INT 0x80
    ret

EXIT:
    MOV EAX, 0x01  ; sys_exit
    XOR EBX, EBX  ; ret 0
    INT 0x80