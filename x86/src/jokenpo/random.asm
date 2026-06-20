section .bss
    seed RESW 0x01

section .data
    time dq 0

section .text
seed_init:
    MOV EAX, 13    ; sys_time
    XOR EDI, EDI
    ; MOV RDI, time
    INT 0x80

    MOV [seed], AX
    ; MOV DWORD EAX, [time]
    ret

get_random:
    ; Formula LCG: Semente = (Semente * 1103515245 + 12345)
    MOV EAX, [seed]
    IMUL EAX, 1103515245
    ADD EAX, 12345
    MOV [seed], EAX  ; Atualiza a semente para a próxima chamada

    ; Limitar o número para o intervalo de 1 a 3 usando a instrução DIV
    ; O resto da divisão por 3 (EAX mod 3) resultará em 0, 1 ou 2.
    ; Somando 1 no final, o resultado vira 1, 2 ou 3.
    xor EDX, EDX        ; Limpa EDX antes da divisao (importante!)
    MOV ECX, 3          ; Queremos um intervalo de 3 possibilidades
    DIV ECX             ; Divide EDX:EAX por ECX. O resto vai para EDX!

    MOV EAX, EDX        ; Move o resto (0, 1 ou 2) para EAX
    INC EAX             ; Soma 1 para virar (1, 2 ou 3)
    ret            ; AX now holds your random number
