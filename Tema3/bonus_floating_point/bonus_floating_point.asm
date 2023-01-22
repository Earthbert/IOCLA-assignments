section .text
	global do_math

section .rodata:
	const: dd  1.15572734979 ;  PI * 1 / e

section .bss:
	x_sqrt_y: dd 1

;; float do_math(float x, float y, float z)
;  returns x * sqrt(2) + y * sin(z * PI * 1/e)
do_math:
	push ebp
	mov	ebp, esp

;  Calculate sqrt(2)
	push dword 2
	fild dword [ebp - 4]
	fsqrt

;  Calculate x * sqrt(2)
	fld dword [ebp + 8]
	fmulp st1, st0

;  Load z
	fld dword [ebp + 16]
;  Calculate z * PI * 1 / e
;  PI * 1 / e is const because calculating it here would lose precision
	fmul dword [const]
;  Calculate sin(z * PI * 1/e)
	fsin
	fld dword [ebp + 12]
;  Calculate y * sin(z * PI * 1/e)
	fmulp st1, st0

;  Calculate x * sqrt(2) + y * sin(z * PI * 1/e)
	fadd st0, st1

	leave
	ret
