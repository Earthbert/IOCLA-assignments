section .text
	global get_rand

get_rand:
	push ebp
	mov	ebp, esp
	push ebx

rdrand_here:
	rdrand eax
	push eax

	mov ebx, 0
	mov eax, 26
	int 0x80
	cmp eax, -1
	jz process_is_traced
	pop eax
	jmp end_func

process_is_traced:
	xor eax, eax
	add esp, 4

end_func:	
	pop ebx
	leave
	ret
