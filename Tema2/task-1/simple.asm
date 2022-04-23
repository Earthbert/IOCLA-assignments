%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor eax, eax

    ; Move through string from the end
mov_in_str:
    dec ecx

    ; Does step modulo 26
    mov eax, edx
    mov dl, 26
    div dl
    mov dl, ah

    ; Move char into eax
    xor eax, eax
    mov al, byte [esi + ecx]

    ; Check if char is shifted over the 'Z'
    mov bl, al
    add bl, dl
    sub bl, 90
    cmp bl, 0
    jle skip_upper_shif
    ; I don't know why al is 64, i just know it doesn't work with 65
    mov al, 64
    add al, bl
    jmp shif_done
skip_upper_shif:

    ; Check if char is shifted under the 'A'
    mov bl, al
    add bl, dl
    sub bl, 65
    cmp bl, 0
    jge skip_lower_shif
    mov al, 90
    sub al, bl
    jmp shif_done
skip_lower_shif:

    add al, dl
shif_done:

    ; Write the shifted char into the new string
    mov byte [edi + ecx], al

    ; Check if the string is finished
    cmp ecx, 0x0
    jge mov_in_str

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
