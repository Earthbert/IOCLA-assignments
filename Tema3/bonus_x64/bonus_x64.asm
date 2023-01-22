BITS 64

section .text
	global intertwine
	extern printf

section .data
	printf_format: db "%d", 10, 0

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0

	xor rax, rax ;  contor for v1 and v2
mov_in_v1_and_v2:
;  put element of v1 in v if there are still elements in v1
	cmp rax, rsi
	jge dont_put_v1_elem
	mov ebx, [rdi + 4 * rax]
	mov [r8], ebx
;  move v pointer to the next element	
	add r8, 4
dont_put_v1_elem:

;  put element of v2 in v if there are still elements in v2
	cmp rax, rcx
	jge dont_put_v2_elem
	mov ebx, [rdx + 4 * rax]
	mov [r8], ebx
;  move v pointer to the next element
	add r8, 4
dont_put_v2_elem:

	inc rax
;  check if we reached the end of either vector
	cmp rax, rcx
	jl mov_in_v1_and_v2
	cmp rax, rsi
	jl mov_in_v1_and_v2

	leave
	ret
