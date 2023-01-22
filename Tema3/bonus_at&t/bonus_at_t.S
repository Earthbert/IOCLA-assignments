/*
 * Don't forget to include "positions.h"
 */
#include "positions.h"
.section .text
.global add_vect

/* 
 * void add_vect(int *v1, int *v2, int n, int *v)
 *
 * add v1 and v2, that have both the length n, and store the result in v3.
 * also, substract from v3 the values provided in positions.S, as described
 * in the task
 */

add_vect:
	pushl %ebp
	movl %esp, %ebp

	pushl %ebx
	pushl %esi
	pushl %edi

	movl 8(%ebp), %edx
	movl 12(%ebp), %edi
	movl 16(%ebp), %ecx
	movl 20(%ebp), %esi

// calculate sum of v1 and v2 into v
sum_v1_v2:
	movl -4(%edx,%ecx,4), %eax
	addl -4(%edi,%ecx,4), %eax

	movl %eax, -4(%esi,%ecx,4)

	loop sum_v1_v2

// scale first position for size of the v array
	movl $FIRST_POSITION ,%eax
	mull 16(%ebp)
	movl $10, %ebx
	divl %ebx

	subl $FIRST_VALUE, (%esi,%eax,4)
	
// scale second position for size of the v array
	movl $SECOND_POSITION ,%eax
	mull 16(%ebp)
	movl $10, %ebx
	divl %ebx

	subl $SECOND_VALUE, (%esi,%eax,4)

// scale third position for size of the v array
	movl $THIRD_POSITION ,%eax
	mull 16(%ebp)
	movl $10, %ebx
	divl %ebx

	subl $THIRD_VALUE, (%esi,%eax,4)

	popl %edi
	popl %esi
	popl %ebx

	leave
	ret
