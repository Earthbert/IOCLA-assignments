%include "../include/io.mac"

section .text
    global spiral
    extern printf

; void spiral(int N, char *plain, int key[N][N], char *enc_string);
spiral:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; N (size of key line)
    mov ebx, [ebp + 12] ; plain (address of first element in string)
    mov ecx, [ebp + 16] ; key (address of first element in matrix)
    mov edx, [ebp + 20] ; enc_string (address of first element in string)
    ;; DO NOT MODIFY
    ;; TODO: Implement spiral encryption
    ;; FREESTYLE STARTS HERE
    mov esi, [ebp + 12]
    mov edi, [ebp + 20]
    mov ebx, [ebp + 16]
    lea ebx, [ebx - 4]

    ;; Nr of the current step
    ;; A step is a doing a complete circle
    xor edx, edx
move_in_text:
    mov ecx, [ebp + 8]
    sub ecx, edx
    cmp ecx, 0
    jle skip_right
move_right:
    lea ebx, [ebx + 4]

    xor eax, eax
    mov al, [esi]
    inc esi
    
    add eax, [ebx]

    mov [edi], al
    inc edi

    loop move_right
skip_right:
    mov ecx, [ebp + 8]
    sub ecx, edx
    dec ecx
    cmp ecx, 0
    jle skip_down
move_down:
    mov eax, [ebp + 8]
    lea ebx, [ebx + 4 * eax]

    xor eax, eax
    mov al, [esi]
    inc esi
    add eax, [ebx]

    mov [edi], al
    inc edi

    loop move_down
skip_down:

    mov ecx, [ebp + 8]
    sub ecx, edx
    dec ecx
    cmp ecx, 0
    jle skip_left
move_left:
    lea ebx, [ebx - 4]

    xor eax, eax
    mov al, [esi]
    inc esi
    add eax, [ebx]

    mov [edi], al
    inc edi

    loop move_left
skip_left:

    mov ecx, [ebp + 8]
    sub ecx, edx
    sub ecx, 2
    cmp ecx, 0
    jle skip_up
move_up:
    mov eax, [ebp + 8]
    add eax, eax
    add eax, eax
    sub ebx, eax
    xor eax, eax
    mov al, byte [esi]
    inc esi

    add eax, [ebx]

    mov [edi], al
    inc edi

    loop move_up
skip_up:
    
    add edx, 2
    ;; Check if the spiral is complete
    cmp edx, [ebp + 8]
    jl move_in_text


    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
