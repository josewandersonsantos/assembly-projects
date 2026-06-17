global _start

section .data
    prompt db 'Enter an expression (e.g. 3 + 4): ', 0
    prompt_len equ $ - prompt
    error_msg db 'Invalid input. Please enter a valid expression.', 0
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
    buffer resb 100   ; reserve 100 bytes for input buffer
    input_size resb 4 ; reserve 4 byte for input len 
    input_idx resb 4  ; reserve 4 byte for input index
    opr1 resb 4       ; reserve 4 bytes for operand 1 
    opr2 resb 4       ; reserve 4 bytes for operand 2
    operator resb 1   ; reserve 1 byte for the operator
    result resb 4     ; reserve 4 bytes for the result
    
section .text

get_input:
    ; Read input from the user
    ; You can use sys_read to read from stdin (file descriptor 0)
    ; Store the input in a buffer for processing
    
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

clean_input:
    ; Clean the input by removing any newline characters or extra spaces
    ; You can use a loop to iterate through the input buffer and remove unwanted characters
    ; After cleaning the input, you can proceed to process it

get_op1:
    ; Extract the first operand from the input
    ; You can use a loop to iterate through the input buffer until you find a space or an operator
    ; Store the first operand in a variable for later use

    MOV EAX, [input_idx]
    XOR EBX, EBX
    MOV EBX, [buffer + EAX]
    CMP EBX, ' '
    JE process_input

    INC BYTE [input_idx]
        
    CMP EBX, '0'
    JL invalid_input
    CMP EBX, '9'
    JG invalid_input
    
    MOV EAX, opr1
    MOV DL, 0x0A
    MUL DL
    
    SUB EBX, 0x30
    ADD EAX, EBX

    JMP get_op1

get_op2:
    ; Extract the second operand from the input
    ; You can use a loop to iterate through the input buffer until you find a space or an operator
    ; Store the second operand in a variable for later use
    JE process_input

get_operator:
    ; Extract the operator from the input
    ; You can use a loop to iterate through the input buffer until you find a space or an operator
    ; Store the operator in a variable for later use
    MOV EAX, [input_idx]
    XOR EBX, EBX
    MOV EBX, [buffer + EAX]
    
    JE process_input


process_input:
    ; Process the input to determine the operation and operands
    ; You can use simple parsing techniques to extract the operator and operands
    ; For example, you can look for spaces to separate the operator and operands
    ; Store the operator in a variable and the operands in another variable
    ; You can convert the operands from string to integer if necessary
    ; Based on the operator, jump to the corresponding operation label
    ; For example, if the operator is '+', jump to op_sum
    ; You can use a series of comparisons to determine the operator
    ; If the operator is not recognized, you can print an error message and exit
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
    JMP op_sum
    CMP BL, '-'
    JMP op_sub
    CMP BL, 'x'
    JMP op_mul
    CMP BL, '/'
    JMP op_div

    JMP exit

ascii_to_int:
    ; Convert the operand from ASCII string to integer
    ; You can use a loop to iterate through the characters of the operand
    ; For each character, you can subtract '0' (ASCII value 48) to get the integer value
    ; You can also handle negative numbers if necessary
    ; After converting the operand, you can store it in a variable for use in the operation

op_sum:
    ; Perform addition on the operands
    ; You can use the ADD instruction to add the operands
    ; Store the result in a variable for output
    ; After performing the operation, you can jump to a label to print the result
    ; For example, you can jump to print_result
    ; You can also handle any necessary cleanup before jumping to print_result
    ; For example, you can clear any registers used for the operation
    ; After printing the result, you can exit the program
    ; You can use sys_write to write the result to stdout (file descriptor 1)
    ; You can convert the result from integer to string if necessary before printing
    ; After printing the result, you can jump to the exit label to exit the program

    MOV EAX, [opr1]
    MOV EBX, [opr2]
    ADD EAX, EBX

    MOV [result], EAX
    JMP print_result

op_sub:
    ; Perform subtraction on the operands
    ; You can use the SUB instruction to subtract the operands
    ; Store the result in a variable for output
    ; After performing the operation, you can jump to a label to print the result
    ; For example, you can jump to print_result
    ; You can also handle any necessary cleanup before jumping to print_result
    ; For example, you can clear any registers used for the operation
    ; After printing the result, you can exit the program
    ; You can use sys_write to write the result to stdout (file descriptor 1)
    ; You can convert the result from integer to string if necessary before printing
    ; After printing the result, you can jump to the exit label to exit the program
    MOV EAX, [opr1]
    MOV EBX, [opr2]
    SUB EAX, EBX

    MOV [result], EAX
    JMP print_result

op_mul:
    ; Perform multiplication on the operands
    ; You can use the MUL instruction to multiply the operands
    ; Store the result in a variable for output
    ; After performing the operation, you can jump to a label to print the result
    ; For example, you can jump to print_result
    ; You can also handle any necessary cleanup before jumping to print_result
    ; For example, you can clear any registers used for the operation
    ; After printing the result, you can exit the program
    ; You can use sys_write to write the result to stdout (file descriptor 1)
    ; You can convert the result from integer to string if necessary before printing
    ; After printing the result, you can jump to the exit label to exit the program
    MOV EAX, [opr1]
    MOV EBX, [opr2]
    MUL EBX

    MOV [result], EAX
    JMP print_result
    
op_div:
    ; Perform division on the operands
    ; You can use the DIV instruction to divide the operands
    ; Store the result in a variable for output
    ; After performing the operation, you can jump to a label to print the result
    ; For example, you can jump to print_result
    ; You can also handle any necessary cleanup before jumping to print_result
    ; For example, you can clear any registers used for the operation
    ; After printing the result, you can exit the program
    ; You can use sys_write to write the result to stdout (file descriptor 1)
    ; You can convert the result from integer to string if necessary before printing
    ; After printing the result, you can jump to the exit label to exit the program
    MOV EAX, [opr1]
    MOV EBX, [opr2]
    DIV EBX

    MOV [result], EAX
    JMP print_result

invalid_input:
    JMP exit

print_result:
    ; Print the result to the user
    ; You can use sys_write to write the result to stdout (file descriptor 1)
    ; You can convert the result from integer to string if necessary before printing
    ; After printing the result, you can jump to the exit label to exit the program


    JMP get_input

_start:
    CALL get_input
    JMP exit

exit:
    ; Exit the program
    ; You can use sys_exit to exit the program with a status code
    MOV EAX, 1   ; sys_exit
    XOR EBX, EBX
    INT 0x80