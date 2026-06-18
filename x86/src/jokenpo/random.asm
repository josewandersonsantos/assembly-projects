section .bss
    seed RESW 0x01

section .text
seed_init:
    MOV EAX, 0x0D    ; sys_time
    XOR EBX, EBX
    INT 0x80
    MOV [seed], AX
    ret

get_random:
    ; Formula LCG: Semente = (Semente * 1103515245 + 12345)
    mov eax, [seed]
    imul eax, 1103515245
    add eax, 12345
    mov [seed], eax  ; Atualiza a semente para a próxima chamada

    ; Limitar o número para o intervalo de 1 a 3 usando a instrução DIV
    ; O resto da divisão por 3 (EAX mod 3) resultará em 0, 1 ou 2.
    ; Somando 1 no final, o resultado vira 1, 2 ou 3.
    xor edx, edx        ; Limpa EDX antes da divisao (importante!)
    mov ecx, 3          ; Queremos um intervalo de 3 possibilidades
    div ecx             ; Divide EDX:EAX por ECX. O resto vai para EDX!

    mov eax, edx        ; Move o resto (0, 1 ou 2) para EAX
    inc eax             ; Soma 1 para virar (1, 2 ou 3)
    ret            ; AX now holds your random number
