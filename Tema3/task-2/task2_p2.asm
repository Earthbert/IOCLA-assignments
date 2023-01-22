section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	push ebx
	push edi
	push esi

;	str_length->edi
	xor edi, edi
	add edi, [esp + 16]

;	str->edx
	xor edx, edx
	add edx, [esp + 20]

;	save stack base in esi
	lea esi, [esp]

;	put zero in eax, default case is false
	xor eax, eax

	xor ecx, ecx
add_par_to_stack:
	xor ebx, ebx
	add bl, byte [edx + ecx]

	cmp bl, '('
	jnz close_par
;	when char is '(' we put it on the stack
	push ebx
	jmp finish_cmp
;	is here when char is ')'
close_par:
	pop ebx
;	if esp is greater then esi then it means we closed an unopen bracket
	cmp esp, esi
	jg stack_not_right
finish_cmp:

	inc ecx
	cmp ecx, edi
	jl add_par_to_stack

;	esp and esi should be equal if all open brackets were closed
	cmp esi, esp
	jnz stack_not_right
	add eax, 1
stack_not_right:
; 	restore stack
	lea esp, [esi]

	pop esi
	pop edi
	pop ebx

	ret
