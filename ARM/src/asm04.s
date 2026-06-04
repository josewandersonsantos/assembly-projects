.global _start

_start:
    MOV r0, #0xFF
    MOV r1, #0x22

    AND r2, r0, r1
    ;ANDS r2, r0, r1
    ORR r2, r0, r1
    ;ORRS r2, r0, r1
    EOR r2, r0, r1
    ;EORS r2, r0, r1
    MVN r2, r0
    ;MVNS r2, r0
    ;ANDS r2, r0, r1
    
    ;MOV r0, #0xFF
    ;MVN r2, r0
    ;AND r0, r0, #0x000000FF