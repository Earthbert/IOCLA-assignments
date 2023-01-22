section .rodata
	format: db "%x", 10, 0
section .text
	extern printf
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	push edi
	push ebx
	mov edi, [ebp + 8]

;	id_string is put in ebx, edx, ecx in that order
	xor eax, eax
	cpuid
	mov [edi], ebx
	mov [edi + 4], edx
	mov [edi + 8], ecx

	pop ebx
	pop edi
	leave
	ret

;; void features(int *apic, int *rdrand, int *mpx, int *svm)
;
;  checks whether apic, rdrand and mpx / svm are supported by the CPU
;  MPX should be checked only for Intel CPUs; otherwise, the mpx variable
;  should have the value -1
;  SVM should be checked only for AMD CPUs; otherwise, the svm variable
;  should have the value -1
features:
	enter 	0, 0
	push edi
	push esi
	push ebx

	mov eax, 1
	cpuid
 
 ;	in the 9th bit of edx support apic is put
	mov edi, 00000000000000000000000100000000b
	and edi, edx
; 	by shifting it 8 to the right edi will be 0 or 1 depending on support for apic
	shr edi, 8
	mov esi, [ebp + 8]
	mov dword [esi], edi

;	in the 30th bit of edx support rdrand is put
	mov edi, 01000000000000000000000000000000b
	and edi, edx
; 	by shifting it 29 to the right edi will be 0 or 1 depending on support for rdrand
	shr edi, 29
	mov esi, [ebp + 12]
	mov dword [esi], edi

	xor eax, eax
	cpuid
;	compare only the first four char of manufacturer id string to
;	determine if it is intel or amd
	cmp ebx, 756e6547h
	jnz AMD
; We are here is proccesor is intel
	mov eax, 7
	xor ecx, ecx
	cpuid
;	in the 14th bit of ebx support mpx is put
	mov edi, 00000000000000000100000000000000b
	and edi, ebx
; 	by shifting it 13 to the right edi will be 0 or 1 depending on support for mpx
	shr edi, 13
	mov esi, [ebp + 16]
	mov dword [esi], edi
	jmp end_feature_checking

AMD:
	mov eax, 80000001h
	cpuid
;	in the 3th bit of ecx support svm is put
	mov edi, 00000000000000000000000000000100b
	and edi, ecx
; 	by shifting it 2 to the right edi will be 0 or 1 depending on support for svm
	shr edi, 2
	mov esi, [ebp + 20]
	mov dword [esi], edi

end_feature_checking:

	pop ebx
	pop esi
	pop edi
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	push edi
	push esi
	push ebx

;	get L2 line_size
	mov eax, 80000006h
	cpuid
	mov edi, 00000000000000000000000011111111b
	and edi, ecx
	mov esi, [ebp + 8]
	mov [esi], edi

;	get L2 cache_size
	mov edi, 11111111111111110000000000000000b
	and edi, ecx
	mov esi, [ebp + 12]
	shr edi, 16
	mov [esi], edi

	pop ebx
	pop esi
	pop edi
	leave
	ret
