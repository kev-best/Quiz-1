section .data
    a dd 10       ; Define variable a with value 10
    b dd 20       ; Define variable b with value 20
    c dd 30       ; Define variable c with value 30
    d dd 40       ; Define variable d with value 40
    result dd 0   ; Define variable result to store the final result

section .bss
    result_str resb 12  ; Buffer to store the result string

section .text
    global _start

_start:
    ; Load the values of a and b into registers
    mov eax, [a]
    mov ebx, [b]
    
    ; Perform multiplication: eax = a * b
    imul ebx
    
    ; Store the result temporarily in edx
    mov edx, eax

    ; Load the values of c and d into registers
    mov eax, [c]
    mov ebx, [d]

    ; Perform multiplication: eax = c * d
    imul ebx

    ; Add the two results: eax = (a * b) + (c * d)
    add eax, edx

    ; Store the result in the variable 'result'
    mov [result], eax

    ; Convert integer result to string
    mov esi, result_str + 11  ; Point to the end of the buffer
    mov byte [esi], 0         ; Null terminator
    mov ecx, 10               ; Divisor for converting to string

convert_loop:
    xor edx, edx              ; Clear edx
    div ecx                   ; Divide eax by 10, quotient in eax, remainder in edx
    add dl, '0'               ; Convert remainder to ASCII
    dec esi                   ; Move backward in the buffer
    mov [esi], dl             ; Store character
    test eax, eax             ; Check if quotient is zero
    jnz convert_loop          ; Repeat if not zero

    ; Calculate string length
    mov edi, result_str + 11
    sub edi, esi
    mov edx, edi              ; Length of the string
    mov ecx, esi              ; Pointer to the string
    mov ebx, 1                ; File descriptor for stdout
    mov eax, 4                ; Syscall number for sys_write
    int 0x80                  ; Call kernel

    ; Exit the program
    mov eax, 1                ; Syscall number for sys_exit
    xor ebx, ebx              ; Status 0
    int 0x80                  ; Call kernel

