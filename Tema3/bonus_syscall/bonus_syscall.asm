section .data
	input_file 	dd 0
	output_file dd 0

section .rodata
	; taken from fnctl.h
	O_RDONLY	equ 00000
	O_WRONLY	equ 00001
	O_TRUNC		equ 01000
	O_CREAT		equ 00100
	S_IRUSR		equ 00400
	S_IRGRP		equ 00040
	S_IROTH		equ 00004
	Polo db "Polo"
	Marco db "Marco"

section .text
	global	replace_marco
	extern 	strlen

;; void replace_marco_in_str(char *src, char *dest)
;  it replaces all occurences of the word "Marco" with the word "Polo" in 
;  a string
replace_marco_in_str:
	push ebp
	mov ebp, esp
;	saves register just in case
	pushad

;	get size of src
	push dword [ebp + 8]
	call strlen
	add esp, 4

	mov ecx, eax

	mov esi, [ebp + 8]
	mov edi, [ebp + 12]

;	strlen(src) times
mov_in_string:
;	check if the next 5 character form Marco
;	if yes then write Polo in dest
	cmp dword [esi], "Marc"
	jnz no_marco
	cmp byte [esi + 4], "o"
	jnz no_marco
	mov dword [edi], "Polo"

	sub ecx, 5
	add edi, 4
	add esi, 5
;	write char by char from src to dest if it doesn't spell Marco
no_marco:
	mov bl, byte [esi]
	mov byte [edi], bl

	inc edi
	inc esi
	loop mov_in_string

	popad
	leave
	ret


;; void replace_marco(const char *in_file_name, const char *out_file_name)
;  it replaces all occurences of the word "Marco" with the word "Polo",
;  using system calls to open, read, write and close files.
replace_marco:
	push ebp
	mov	ebp, esp

	sub esp, 100

	lea esi, [ebp - 100]

;  Open input file
	mov eax, 5
	mov ebx, [ebp + 8]
	mov ecx, O_RDONLY
	mov edx, 0666o
	int 0x80

	mov dword [input_file], eax

;  Read from file
	mov eax, 3
	mov ebx, dword [input_file]
	mov ecx, esi
	mov edx, 100
	int 0x80

;  Create output file
	mov eax, 5
	mov ebx, dword [ebp + 12]
	mov ecx, O_CREAT
	mov edx, 0666o
	int 0x80

	mov dword [output_file], eax
; Close output file
	mov eax, 6
   	mov ebx, [output_file]
   	int  0x80

	
;  Open output file to write in it
	mov eax, 5
	mov ebx, dword [ebp + 12]
	mov ecx, O_WRONLY
	mov edx, 0666o
	int 0x80

	mov dword [output_file], eax

	sub esp, 100
	lea edi, [ebp - 200]
	push edi
	push esi
	call replace_marco_in_str
	add esp, 8

	push edi
	call strlen
	add esp, 4
	push eax

;  Write into output file
	mov eax, 4
	mov ebx, dword [output_file]
	mov ecx, edi
	mov edx, [ebp - 204]
	int 0x80
	
;  Close input file
	mov eax, 6
   	mov ebx, [input_file]
   	int  0x80

; Close output file
	mov eax, 6
   	mov ebx, [output_file]
   	int  0x80

	add esp, 204

	leave
	ret
