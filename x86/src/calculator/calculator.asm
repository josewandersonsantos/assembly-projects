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
    
    actual_state b db 0

section .bss
    buffer resb 100  ; reserve 100 bytes for input buffer
    opr1 resb 4      ; reserve 4 bytes for operand 1 
    opr2 resb 4      ; reserve 4 bytes for operand 2
    operator resb 1  ; reserve 1 byte for the operator
    result resb 4    ; reserve 4 bytes for the result
    
section .text

_start:

get_input:
    ; Read input from the user
    ; You can use sys_read to read from stdin (file descriptor 0)
    ; Store the input in a buffer for processing
    
    MOV EAX, 3
    MOV EBX, 0
    MOV ECX, buffer ; buffer to store the input
    MOV EDX, 100     ; number of bytes to read
    INT 0x80        ; call kernel 

    jmp process_input

clean_input:
    ; Clean the input by removing any newline characters or extra spaces
    ; You can use a loop to iterate through the input buffer and remove unwanted characters
    ; After cleaning the input, you can proceed to process it

get_op1:
    ; Extract the first operand from the input
    ; You can use a loop to iterate through the input buffer until you find a space or an operator
    ; Store the first operand in a variable for later use

get_op2:
    ; Extract the second operand from the input
    ; You can use a loop to iterate through the input buffer until you find a space or an operator
    ; Store the second operand in a variable for later use

get_operator:
    ; Extract the operator from the input
    ; You can use a loop to iterate through the input buffer until you find a space or an operator
    ; Store the operator in a variable for later use
    l1: 
        mov al, [buffer + actual_state]
        cmp al, ' '
        je l2
        cmp al, '+'
        je l3
        cmp al, '-'
        je l4
        cmp al, '*'
        je l5
        cmp al, '/'
        je l6
        inc actual_state
        jmp l1
    l2:
        ; store opr1
        ; you can use a loop to copy the characters from the buffer to opr1 until you find a space or an operator
        ; you can also convert the characters from ASCII to integer if necessary
        jmp get_op2
    l3:
        ; store operator as '+'
        jmp get_op2
    l4:
        ; store operator as '-'
        jmp get_op2
    l5:
        ; store operator as '*'
        jmp get_op2
    l6:
        ; store operator as '/'
        jmp get_op2

process_input:
    ; Process the input to determine the operation and operands
    ; You can use simple parsing techniques to extract the operator and operands
    ; For example, you can look for spaces to separate the operator and operands
    ; Store the operator in a variable and the operands in another variable
    ; You can convert the operands from string to integer if necessary
    ; Based on the operator, jump to the corresponding operation label
    ; For example, if the operator is '+', jump to op_sum
    ; You can use a series of comparisons to determine the operator
    ; For example:
    ; cmp operator, '+'
    ; je op_sum
    ; cmp operator, '-'
    ; je op_sub
    ; cmp operator, '*'
    ; je op_mul
    ; cmp operator, '/'
    ; je op_div
    ; If the operator is not recognized, you can print an error message and exit

    CMP actual_state, 1
    JE get_op1
    CMP actual_state, 2
    JE get_operator
    CMP actual_state, 3
    JE get_op2
    


    jmp clean_input

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

print_result:
    ; Print the result to the user
    ; You can use sys_write to write the result to stdout (file descriptor 1)
    ; You can convert the result from integer to string if necessary before printing
    ; After printing the result, you can jump to the exit label to exit the program

exit:
    ; Exit the program
    ; You can use sys_exit to exit the program with a status code
    MOV EAX, 1
    MOV EBX, 0
    INT 0x80