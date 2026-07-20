global _start
section .bss
    buf resb 1024
    lenIn resd 0x01

    filePath resb 24
    fd resb 0x4

section .data
    prompt1 db "Type file name:"
    prompt1Len equ $ - prompt1
    prompt2 db "Type file content:"
    prompt2Len equ $ - prompt2

section .text
_start:
    ; Prompt 1
    MOV EAX, 0x04
    MOV EBX, 0x01
    MOV ECX, prompt1
    MOV EDX, prompt1Len
    INT 0x80

    ; Get file name
    MOV EAX, 0x03
    MOV EBX, 0x00
    MOV ECX, buf
    MOV EDX, 1024
    INT 0x80
    
    ; Create file
    MOV EAX, 0x08
    MOV EBX, buf
    MOV ECX, 0777 ;read, write and execute
    INT 0x80

    ; PUSH EAX

    ; get file descriptor from EAX
    MOV [fd], EAX

    ; Prompt 2
    MOV EAX, 0x04
    MOV EBX, 0x01
    MOV ECX, prompt2
    MOV EDX, prompt2Len
    INT 0x80

    ; Get content file from stdin
    MOV EAX, 0x03
    MOV EBX, 0x00
    MOV ECX, buf
    MOV EDX, 1024
    INT 0x80

    MOV [lenIn], EAX

    ; Loopback
    MOV EAX, 0x04
    MOV EBX, 0x01
    MOV ECX, buf
    MOV EDX, lenIn
    INT 0x80
    
    ; Write content on file
    MOV EAX, 0x04
    MOV EBX, [fd]
    MOV ECX, buf
    MOV EDX, [lenIn]
    INT 0x80

    ; Close file
    MOV EAX, 0x06
    MOV EBX, [fd]
    INT 0x80

    JMP exit

;     POP EAX

;     ; Open file
;     MOV EBX, buf
;     MOV EAX, 0x05
;     MOV ECX, 0x00 ; 0 read-only, 1 write-only, 2 read-write
;     MOV EDX, 0777 ; read, write and execute
;     INT 0x80

;     ; Get content from file
;     MOV EAX, 0x03
;     MOV EBX, [fd]
;     MOV EBX, buf
;     MOV EDX, 1024
;     INT 0x80

;     ; Print content
;     MOV EDX, EAX
;     MOV EBX, 0x01
;     MOV ECX, buf
;     MOV EAX, 0x04
;     INT 0x80

;     ; Close file again
;     MOV EAX, 0x06
;     MOV EBX, [fd]
;     INT 0x80

;     ; JMP exit

; error:


exit:
    MOV EAX, 0x01
    XOR EBX, EBX
    INT 0x80
