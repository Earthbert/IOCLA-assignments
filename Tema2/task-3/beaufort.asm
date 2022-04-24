%include "../include/io.mac"

section .text
    global beaufort
    extern printf

; void beaufort(int len_plain, char *plain, int len_key, char *key, char tabula_recta[26][26], char *enc) ;
beaufort:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; len_plain
    mov ebx, [ebp + 12] ; plain (address of first element in string)
    mov ecx, [ebp + 16] ; len_key
    mov edx, [ebp + 20] ; key (address of first element in matrix)
    mov edi, [ebp + 24] ; tabula_recta
    mov esi, [ebp + 28] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement spiral encryption
    ;; FREESTYLE STARTS HERE
    mov ecx, 0
    mov esi, [ebp + 12]
    mov edi, [ebp + 20]
    mov edx, [ebp + 28]
    xor eax, eax

    ;; We move in the plain string
mov_in_text:
    ;; We put the char from the plain in bl
    mov bl, byte [esi + ecx]

    ;; We put the coresponding char from the key in bh
    mov ax, cx
    ;; To not go over the key lenght we do modulo len_key
    div byte [ebp + 16]
    mov al, ah
    xor ah, ah
    mov bh, byte [edi + eax]

    ;; The difference between key char and plain char is the position of the 
    ;; encypted char in the alphabet
    sub bh, bl
    
    ;; Check if diff is below 0 and add 26 if it is
    cmp bh, 0
    jge bh_is_good
    add bh, 26
bh_is_good:

    ;; We give the char the right ascii code
    add bh, 65
    ;; We put the char in the encypted string
    mov byte [edx + ecx], bh

    inc ecx
    cmp [ebp + 8], ecx
    jg mov_in_text

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
