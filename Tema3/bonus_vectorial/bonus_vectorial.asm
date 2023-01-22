section .text
	global vectorial_ops

section .data
	scalar dd 1, 1, 1, 1
;; void vectorial_ops(int s, int A[], int B[], int C[], int n, int D[])
;  
;  Compute the result of s * A + B .* C, and store it in D. n is the size of
;  A, B, C and D. n is a multiple of 16. The result of any multiplication will
;  fit in 32 bits. Use MMX, SSE or AVX instructions for this task.

vectorial_ops:
	push		rbp
	mov		rbp, rsp

	mov [scalar], edi
	mov [scalar + 4], edi
	mov [scalar + 8], edi
	mov [scalar + 12], edi

	xor rax, rax
mov_in_arr:
;  	mov 16 element of B array in xmm0-3
	MOVDQU xmm0, [rdx + 4 * rax]
	MOVDQU xmm1, [rdx + 4 * rax + 16]
	MOVDQU xmm2, [rdx + 4 * rax + 32]
	MOVDQU xmm3, [rdx + 4 * rax + 48]

;   mov C array in xmm4-7
	MOVDQU xmm4, [rcx + 4 * rax]
	MOVDQU xmm5, [rcx + 4 * rax + 16]
	MOVDQU xmm6, [rcx + 4 * rax + 32]
	MOVDQU xmm7, [rcx + 4 * rax + 48]

;   calculate B .* C and put result in xmm0-4
	PMULLD xmm0, xmm4
	PMULLD xmm1, xmm5
	PMULLD xmm2, xmm6
	PMULLD xmm3, xmm7

;   mov A array in xmm4-7
	MOVDQU xmm4, [rsi + 4 * rax]
	MOVDQU xmm5, [rsi + 4 * rax + 16]
	MOVDQU xmm6, [rsi + 4 * rax + 32]
	MOVDQU xmm7, [rsi + 4 * rax + 48]

; 	mov 16 scalar values in xmm4-7
	MOVDQU xmm8, [scalar]
	MOVDQU xmm9, [scalar]
	MOVDQU xmm10, [scalar]
	MOVDQU xmm11, [scalar]

; calculate s * A
	PMULLD xmm4, xmm8
	PMULLD xmm5, xmm9
	PMULLD xmm6, xmm10
	PMULLD xmm7, xmm11

;	calculate s * A + B .* C
	PADDD xmm0, xmm4
	PADDD xmm1, xmm5
	PADDD xmm2, xmm6
	PADDD xmm3, xmm7

; 	result in D array
	MOVDQU [r9 + 4 * rax], xmm0
	MOVDQU [r9 + 4 * rax + 16], xmm1
	MOVDQU [r9 + 4 * rax + 32], xmm2
	MOVDQU [r9 + 4 * rax + 48], xmm3

	add rax, 16
	cmp rax, r8
	jl mov_in_arr

	leave
	ret
