global _start

section .data
    prompt db "Enter an expression (e.g. 3 + 4), use '*', '+', '-' and '/': ", 0x00
    prompt_len equ $ - prompt
    error_msg db 'Invalid input. Please enter a valid expression.', 0x0A
    error_len equ $ - error_msg

    ; variable to store the actual state of the calculator
    ; 0 = waiting for input,
    ; 1 = getting first operand,
    ; 2 = getting operator,
    ; 3 = getting second operand,
    ; 5 = calculatting result
    ; 4 = ready to output result
    state db 0

section .bss
    buffer resb 64    ; reserve 100 bytes for input buffer
    input_size resb 4 ; reserve 4 byte for input len s
    input_idx resb 4  ; reserve 4 byte for input index
    opr1 resb 4       ; reserve 4 bytes for operand 1 s
    opr2 resb 4       ; reserve 4 bytes for operand 2
    operator resb 1   ; reserve 1 byte for the operator
    result resb 4     ; reserve 4 bytes for the result
    
section .text

_start:
    CALL get_input
    JMP exit

    ; MOV dword [result], 123006789
    ; JMP print_result

get_input:
    ; Read input from the user
    
    MOV EAX, 0x04       ; syscall (sys_write)
    MOV EBX, 0x01       ; file descriptor stdout
    MOV ECX, prompt     ; buffer to store the input
    MOV EDX, prompt_len ; number of bytes to read
    INT 0x80            ; call kernel 

    MOV EAX, 0x03    ; syscall (sys_read)
    MOV EBX, 0x00    ; file descriptor stdin   
    MOV ECX, buffer  ; buffer to store the input
    MOV EDX, 0x64    ; number of bytes to read
    INT 0x80         ; call kernel 

    MOV DWORD [input_size], EAX ; get input len
    MOV WORD  [input_idx], 0x00
    MOV BYTE  [state], 0x00
    MOV WORD  [opr1], 0x00
    MOV WORD  [opr2], 0x00
    MOV BYTE  [operator], 0x00

    JMP process_input

process_input:
    ; Process the input to determine the operation and operands
    INC BYTE [state]
    MOV BYTE BL, [state]
    CMP BL, 0x01
    JE get_op1
    CMP BL, 0x02
    JE get_operator
    CMP BL, 0x03
    JE get_op2

    MOV BYTE BL, [operator]
    CMP BL, '+'
    JE op_sum
    CMP BL, '-'
    JE op_sub
    CMP BL, '*'
    JE op_mul
    CMP BL, '/'
    JE op_div

    JMP exit

get_digit:
    MOV EAX, [input_idx]
    MOV EDX, [input_size]
    CMP EAX, EDX
    JE invalid_input

    XOR EBX, EBX
    MOV BL, [buffer + EAX]    
    
    CMP BL, ' '
    JE process_input
    
    CMP BL, '0'
    JL process_input
    CMP BL, '9'
    JG process_input

    INC BYTE [input_idx]

    ret

get_op1:
    ; Extract the first operand from the input
    ; Iterate through the input buffer until you find a space or an operator
    CALL get_digit
    
    MOV EAX, [opr1]
    MOV DL, 0x0A
    MUL DL
    
    SUB BL, 0x30
    ADD EAX, EBX
    MOV [opr1], EAX

    JMP get_op1

get_op2:
    ; Extract the second operand from the input
    ; Iterate through the input buffer until you find a space or an operator
    CALL get_digit
    
    MOV EAX, [opr2]
    MOV DL, 0x0A
    MUL DL
    
    SUB BL, 0x30
    ADD EAX, EBX
    MOV [opr2], EAX

    JMP get_op2

get_operator:
    ; Extract the operator from the input
    MOV EAX, [input_idx]
    MOV EDX, [input_size]
    CMP EAX, EDX
    JE invalid_input

    INC BYTE [input_idx]

    XOR EBX, EBX
    MOV BL, [buffer + EAX]    
    
    CMP BL, ' '
    JE get_operator

    MOV [operator], BL

    CMP BL, '*'
    JE process_input
    CMP BL, '+'
    JE process_input
    CMP BL, '-'
    JE process_input
    CMP BL, '/'
    JE process_input

    JMP get_operator

op_sum:
    ; Perform addition on the operands
    MOV EAX, [opr1]
    MOV EBX, [opr2]
    ADD EAX, EBX

    MOV [result], EAX
    JMP print_result

op_sub:
    ; Perform subtraction on the operands
    MOV EAX, [opr1]
    MOV EBX, [opr2]
    SUB EAX, EBX

    MOV [result], EAX
    JMP print_result

op_mul:
    ; Perform multiplication on the operands
    MOV EAX, [opr1]
    MOV EBX, [opr2]
    MUL EBX

    MOV [result], EAX
    JMP print_result
    
op_div:
    ; Perform division on the operands
    MOV EAX, [opr1]
    MOV EBX, [opr2]
    DIV EBX

    MOV [result], EAX
    JMP print_result

invalid_input:

    MOV EAX, 0x04
    MOV EBX, 0x00
    MOV ECX, error_msg
    MOV EDX, error_len
    INT 0x80

    JMP exit

int_to_ascii:
    CMP EAX, 0x00
    JE end_int_to_ascii

    XOR EDX, EDX
    MOV ECX, 0x0A
    DIV ECX

    ADD DL, 0x30

    PUSH EAX
    PUSH EDX
    
    CALL int_to_ascii

    MOV EAX, 0x04
    MOV EBX, 0x00
    MOV ECX, ESP
    MOV EDX, 0x01
    INT 0x80

    POP EDX
    POP EAX

end_int_to_ascii:
    ret

print_result:
    ; Print the result to the user
    MOV EAX, [result]
    CMP EAX, 0x00
    JE print_zero_char
    CALL int_to_ascii
    JMP print_break_line

print_zero_char:
    XOR EDX, EDX
    MOV EDX, 0x30

    PUSH EDX
    
    MOV EAX, 0x04
    MOV EBX, 0x00
    MOV ECX, ESP
    MOV EDX, 0x01
    
    INT 0x80
    POP EDX

print_break_line:

    XOR EDX, EDX
    MOV EDX, 0x0A
    
    PUSH EDX
    
    MOV EAX, 0x04
    MOV EBX, 0x00
    MOV ECX, ESP
    MOV EDX, 0x01
    
    INT 0x80
    POP EDX

    ; JMP exit
    JMP get_input

exit:
    ; Exit the program
    ; You can use sys_exit to exit the program with a status code
    MOV EAX, 1   ; sys_exit
    XOR EBX, EBX
    INT 0x80