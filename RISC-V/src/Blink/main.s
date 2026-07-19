.section .text
.global _start
.global main

.equ GPIO_BASE,         0x60091000
.equ GPIO_OUT_W1TS,     0x0008   # Set bits (write 1 to set)
.equ GPIO_OUT_W1TC,     0x000C   # Clear bits (write 1 to clear)
.equ GPIO_ENABLE_W1TS,  0x0024   # Enable output
.equ GPIO_FUNC8_OUT_SEL,0x0574   # GPIO_FUNCn_OUT_SEL_CFG (n=8)

_start:
main:
    # GPIO8 as output by GPIO Matrix
    li   t0, GPIO_BASE
    li   t1, 0x80                # Special valur to "GPIO" (128)
    sw   t1, GPIO_FUNC8_OUT_SEL(t0)

    # Enable GPIO8 as output
    li   t1, 1 << 8
    sw   t1, GPIO_ENABLE_W1TS(t0)

loop:
    # TUrn on LED (set)
    sw   t1, GPIO_OUT_W1TS(t0)
    
    # Delay (~500ms @ ~160MHz)
    li   t2, 8000000
delay1:
    addi t2, t2, -1
    bnez t2, delay1

    # Turn off LED (clear)
    sw   t1, GPIO_OUT_W1TC(t0)

    # Delay
    li   t2, 8000000
delay2:
    addi t2, t2, -1
    bnez t2, delay2

    j    loop