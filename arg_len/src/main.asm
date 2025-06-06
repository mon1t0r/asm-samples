%include "kernel.inc"
%include "string.inc"
%include "print.inc"

global _start

section .text
_start:
	mov ebp, esp          ; init EBP

	cmp dword [ebp], 1    ; if argc is greater than 1, jump to .begin
	jg .begin
	xor eax, eax          ; otherwise, set length to 0, jump to .print
	jmp .print

.begin:
	mov eax, [ebp+8]      ; move arg1 to EAX
	push eax              ; pass arg1 as subroutine argument
	call str_len
	add esp, 4            ; cleanup after call
	
.print:
	push eax              ; pass arg1 length as subroutine argument
	call print_u
	add esp, 4            ; cleanup after call

	push byte 10          ; pass '\n' character as subroutine argument
	call print_c
	add esp, 1            ; cleanup after call


; SYS_EXIT, exit code
	kernel 1, 0
