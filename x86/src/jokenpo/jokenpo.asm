global _start

section .data
    prompt db "Choice your trick! (e.g. 'P for paper, 'S' for scissors and 'R' for rock.):"
    prompt_len equ $ - prompt
    msg_choice_error db 0x0A, "--> Invalid choice dude! (e.g. 'P for paper, 'S' for scissors and 'R' for rock.)", 0x0A
    msg_choice_error_len equ $ - msg_choice_error

section .bss
    choice resb 0x01

section .text
; MACROS DEFINITIONS
%macro print 2
    MOV EAX, 0x04
    MOV EBX, 0x01
    MOV ECX, %1
    MOV EDX, %2
    INT 0x80
%endmacro

%macro get_input 2
    MOV EAX, 0x03
    MOV EBX, 0x00
    MOV ECX, %1
    MOV EDX, %2
    INT 0x80
%endmacro

_start:
    print prompt, prompt_len
    get_input choice, 0x01

    CMP byte [choice], 'P'
    JE play
    CMP byte [choice], 'S'
    JE play
    CMP byte [choice], 'R'
    JE play

    JMP invalid_choice
play:
    ;
    ;
    ;
    JMP exit

invalid_choice:
    print msg_choice_error, msg_choice_error_len

exit:
    MOV EAX, 0x01
    XOR EBX, EBX
    INT 0x80