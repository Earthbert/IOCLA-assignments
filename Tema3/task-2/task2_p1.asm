section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	push ebp
;	mov ebp, esp
	xor ebp, ebp
	add ebp, [esp]

;	a -> eax
	xor eax, eax
	add eax, [esp + 8]

;	b -> edx
	xor edx, edx
	add edx, [esp + 12]

; 	save a1 in esi
	xor esi, esi
	add esi, eax

; 	save b1 in adi
	xor edi, edi
	add edi, edx

;	we add a/b to a1/b1 if b1/a1 is greater then a1/b1 until they are equal
while:
	cmp esi, edi
	jz end_while

	cmp esi, edi
	jge a1_greater
	add esi, eax
	jmp b1_greater
a1_greater:
	add edi, edx
b1_greater:

	jmp while

end_while:

;	save result in eax
	xor eax, eax
	add eax, edi

	pop ebp
	ret
