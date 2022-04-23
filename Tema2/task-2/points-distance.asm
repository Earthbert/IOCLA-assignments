%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global points_distance
    extern printf

points_distance:
    ;; DO NOT MODIFY
    
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; points
    mov eax, [ebp + 12]     ; distance
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor edx, edx
    mov dx, word [ebx + point_size + point.x]
    sub dx, word [ebx + point.x]
    jnz distance_calculated

    mov dx, word [ebx + point_size + point.y]
    sub dx, word [ebx + point.y]

distance_calculated:
    
    cmp dx, 0
    jge distance_is_positive
    NEG dx

distance_is_positive:
    mov [eax], edx
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret

    ;; DO NOT MODIFY