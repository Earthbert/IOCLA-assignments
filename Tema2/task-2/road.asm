%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global road
    extern printf

road:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]      ; points
    mov ecx, [ebp + 12]     ; len
    mov ebx, [ebp + 16]     ; distances
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    dec ecx
mov_in_dist_arr:
    xor edx, edx

    mov dx, word [eax + point_size + point.x]
    sub dx, word [eax + point.x]
    jnz distance_calculated

    mov dx, word [eax + point_size + point.y]
    sub dx, word [eax + point.y]

distance_calculated:
    cmp dx, 0
    jge distance_is_positive
    NEG dx

distance_is_positive:

    ; Go the next 
    add eax, point_size
    mov [ebx], edx
    add ebx, 4

    loop mov_in_dist_arr


    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY