%include "random.asm"
global _start

section .data
    prompt db "Choice your trick! (e.g. 'P for paper, 'S' for scissors and 'R' for rock.):"
    prompt_len equ $ - prompt
    msg_choice_error db "--> Invalid choice dude! (e.g. 'P for paper, 'S' for scissors and 'R' for rock.)", 0x0A
    msg_choice_error_len equ $ - msg_choice_error
    msg_my_choice db "# My choice: "
    msg_my_choice_len equ $ - msg_my_choice
    msg_win db "# You win!", 0x0A
    msg_win_len equ $ - msg_win
    msg_lose db "# You lose!", 0x0A
    msg_lose_len equ $ - msg_lose
    msg_draw db "# We draw!", 0x0A
    msg_draw_len equ $ - msg_draw

section .bss
    choice resb 0x01
    my_choice resb 0x01

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
    CALL seed_init
    print prompt, prompt_len
    get_input choice, 0x01

    CMP BYTE [choice], 'P'
    JE play
    CMP BYTE [choice], 'S'
    JE play
    CMP BYTE [choice], 'R'
    JE play

    JMP invalid_choice
play:
    CALL get_random
    
    CMP EAX, 0x02
    JL play_p
    JE play_s
    JG play_r

play_p: ; if number if disible for 3
    print msg_my_choice, msg_my_choice_len
    MOV BYTE [my_choice], 'P'
    print my_choice, 0x01
    MOV BYTE [my_choice], 0x0A
    print my_choice, 0x01

    MOV BYTE DL, [choice]
    CMP BYTE [choice], 'P'
    JE print_draw
    CMP BYTE [choice], 'S'
    JE print_win

    JMP print_lose
    
play_s: ; if number if disible for 5
    print msg_my_choice, msg_my_choice_len
    MOV BYTE [my_choice], 'S'
    print my_choice, 0x01
    MOV BYTE [my_choice], 0x0A
    print my_choice, 0x01

    MOV BYTE DL, [choice]
    CMP BYTE [choice], 'S'
    JE print_draw
    CMP BYTE [choice], 'R'
    JE print_win

    JMP print_lose

play_r:
    print msg_my_choice, msg_my_choice_len
    MOV BYTE [my_choice], 'R'
    print my_choice, 0x01
    MOV BYTE [my_choice], 0x0A
    print my_choice, 0x01

    MOV BYTE DL, [choice]
    CMP BYTE [choice], 'R'
    JE print_draw
    CMP BYTE [choice], 'P'
    JE print_win

    JMP print_lose

print_draw:
    print msg_draw, msg_draw_len
    JMP exit

print_win:
    print msg_win, msg_win_len
    JMP exit

print_lose:
    print msg_lose, msg_lose_len
    JMP exit

invalid_choice:
    print msg_choice_error, msg_choice_error_len

exit:
    MOV EAX, 0x01
    XOR EBX, EBX
    INT 0x80