.global _start

_start:
    MOV r0, #5
    MOV r1, #7

    ADD r2, r1, r0
    SUB r3, r1, r0
    MUL r4, r1, r0
    ADC r5, r1, r0

    ;ADDS r2, r1, r0
    ;SUBS r3, r1, r0
    ;MULS r4, r1, r0