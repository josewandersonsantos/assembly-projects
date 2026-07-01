.syntax unified
.cpu cortex-m3
.thumb

.section .isr_vector, "a", %progbits
.align 2
.global vector_table
vector_table:
    .word _estack               @ Initial Stack Pointer
    .word Reset_Handler + 1     @ Reset Handler (Thumb mode)
    .word NMI_Handler           @ NMI
    .word HardFault_Handler     @ HardFault
    .word MemManage_Handler     @ MemManage
    .word BusFault_Handler      @ BusFault
    .word UsageFault_Handler    @ UsageFault
    .word 0                     @ Reserved
    .word 0                     @ Reserved
    .word 0                     @ Reserved
    .word 0                     @ Reserved
    .word SVC_Handler           @ SVCall
    .word DebugMon_Handler      @ Debug Monitor
    .word 0                     @ Reserved
    .word PendSV_Handler        @ PendSV
    .word SysTick_Handler       @ SysTick


.text
.thumb_func
.global Reset_Handler
Reset_Handler:
    bl main                     @ Call main
    b .                         @ Loop infinito (don't hit here never)

.equ RCC_BASE,      0x40021000
.equ RCC_APB2ENR,   0x18
.equ GPIOC_BASE,    0x40011000
.equ GPIOC_CRH,     0x04
.equ GPIOC_BSRR,    0x10
.equ GPIOC_BRR,     0x14

.global main
.type main, %function

main:
    @ Enable clock GPIOC
    ldr r0, =RCC_BASE
    ldr r1, [r0, #RCC_APB2ENR]
    orr r1, #0x10
    str r1, [r0, #RCC_APB2ENR]

    @ Set PC8 and PC9 as output
    ldr r0, =GPIOC_BASE
    ldr r1, [r0, #GPIOC_CRH]
    ldr r2, =0xFFFFFF00
    and r1, r2
    ldr r2, =0x33          @ 0011 0011 → PC8 and PC9 output
    orr r1, r2
    str r1, [r0, #GPIOC_CRH]

loop:
    ldr r0, =GPIOC_BASE
    ldr r1, =0x00000100    @ PC8 = 1
    str r1, [r0, #GPIOC_BSRR]

    bl delay

    ldr r1, =0x01000200    @ PC8=0 (BRR), PC9=1 (BSRR)
    str r1, [r0, #GPIOC_BRR]   @ PC8 off
    str r1, [r0, #GPIOC_BSRR]  @ PC9 on

    bl delay

    b loop

delay:
    ldr r3, =0x200000      @ delay 500ms
delay_loop:
    subs r3, #1
    bne delay_loop
    bx lr

.thumb_func
.global NMI_Handler
NMI_Handler:
    b .

.thumb_func
.global HardFault_Handler
HardFault_Handler:
    b .

.thumb_func
.global MemManage_Handler
MemManage_Handler:
    b .

.thumb_func
.global BusFault_Handler
BusFault_Handler:
    b .

.thumb_func
.global UsageFault_Handler
UsageFault_Handler:
    b .

.thumb_func
.global SVC_Handler
SVC_Handler:
    b .

.thumb_func
.global DebugMon_Handler
DebugMon_Handler:
    b .

.thumb_func
.global PendSV_Handler
PendSV_Handler:
    b .

.thumb_func
.global SysTick_Handler
SysTick_Handler:
    b .
