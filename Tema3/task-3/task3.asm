section .text
    global get_words
    global compare_func
    global sort
    extern strcmp
    extern strtok
    extern strcpy
    extern strlen
    extern qsort 
    extern printf

section .data
    delim db " .,", 10, 0

section .rodata
    format db "--%s--", 10, 0


;; int compare_func(char *str1, char *str2)
;  function compares two string
compare_func:
    enter 0, 0

;; Save used registers
    push ebx
    push edi
    push esi

    mov edi, [ebp + 8]
    mov esi, [ebp + 12]

;   get size of str1 and put it in ebx
    push dword [esi]
    call strlen
    add esp, 4
    mov ebx, eax

;    get size of str2
    push dword [edi]
    call strlen
    add esp, 4

;   compare sizes if they are not equal then in eax we have the compare value
    sub eax, ebx
    jnz end_cmp

;   if sizes are equal compare is done by strcmp
    push dword [esi]
    push dword [edi]
    call strcmp
    add esp, 8

end_cmp:

    pop esi
    pop edi
    pop ebx

    leave
    ret


;; sort(char **words, int number_of_words, int size)
sort:
    enter 0, 0

;   call qsort
    push compare_func
    push dword [ebp + 16]
    push dword [ebp + 12]
    push dword [ebp + 8]
    call qsort
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

;   save used registers
    push edi
    push esi

    mov esi, [ebp + 8]
    mov edi, [ebp + 12]

;   call strtok
    push delim
    push esi
    call strtok
    add esp, 8

    xor ecx, ecx
while_strtok:
;   mov found str in words array
    mov dword [edi + 4 * ecx], eax
    inc ecx

;   save contor
    push ecx

;   call strtok
    push delim
    push 0x0
    call strtok
    add esp, 8

    pop ecx

    cmp eax, 0x0
    jnz while_strtok

    pop esi
    pop edi
    leave
    ret
