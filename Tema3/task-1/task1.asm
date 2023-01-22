section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

struc node
    val:	resd 1
    next:	resd 1
endstruc

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

;	save used registers
	push ebx
	push edi
	push esi

	mov edx, [ebp + 8]
	mov edi, [ebp + 12]

; 	4 * edx
	add edx, edx
	add edx, edx
;	create a local array of n ints to store address of elements in order
	sub esp, edx

;	put addres of each element to its coresponding position in local array
;	ex: element with val 4 will be put at arr[3]
	xor ecx, ecx
put_adr_in_stack:
	lea esi, [edi + node_size * ecx]

	mov ebx, [esi + val]
	mov [esp + 4 * ebx - 4], esi
	
	inc ecx
	cmp ecx, [ebp + 8]
	jl put_adr_in_stack

;	put addres of each element in the coresponding next field of node struct
	xor ecx, ecx
put_adr_in_arr:
	lea esi, [edi + node_size * ecx]

	mov ebx, [esi + val]
	cmp ebx, [ebp + 8]
	je skip_for_last_elem

;	find addres of next value
	mov eax, [esp + 4 * ebx]
;	put addres of next value in next
	mov [esi + next], eax

skip_for_last_elem:
	inc ecx
	cmp ecx, [ebp + 8]
	jl put_adr_in_arr

;	put value of first elemnt of local array (val = 1) in eax to return it
	mov eax, [esp]

;	restore stack
	add esp, edx

	pop esi
	pop edi
	pop ebx

	leave
	ret
