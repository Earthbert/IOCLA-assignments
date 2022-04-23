%include "../include/io.mac"

section .text
    global is_square
    extern printf

is_square:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; dist
    mov eax, [ebp + 12]     ; nr
    mov ecx, [ebp + 16]     ; sq
    ;; DO NOT MODIFY
   
    ;; Your code starts here
    xor ecx, ecx
    mov esi, [ebp + 8]
    mov edi, [ebp + 16]
mov_in_dist_arr:
    mov ebx, 0
find_square:
    mov eax, ebx
    mul ebx
    cmp eax, [esi + 4 * ecx]
    jnz not_found_square
    mov dword [edi + 4 * ecx], 1
    jmp finish_search

not_found_square:
    inc ebx
    cmp ebx, [esi + 4 * ecx]
    jle find_square
    mov dword [edi + 4 * ecx], 0
    jl mov_in_dist_arr

finish_search:

    inc ecx
    cmp ecx, [ebp + 12]
    jl mov_in_dist_arr

    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY