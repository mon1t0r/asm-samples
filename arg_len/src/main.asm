%include "kernel.inc"
%include "string.inc"
%include "print.inc"

global _start

section .rodata
	mep   db "Usage: ./arg_len <arg>", 10
	mepl  equ $-mep
	mal   db "Arg len: "
	mall  equ $-mal

section .text
_start:
	mov ebp, esp           ; init EBP

	cmp dword [ebp], 2     ; if argc is equal to 2, jump
	je .begin
	kernel 4, 2, mep, mepl ; SYS_WRITE, stdout, message, message length
	kernel 1, 1            ; SYS_EXIT, exit code

.begin:
	mov eax, [ebp+8]       ; move arg1 to EAX
	push eax               ; pass arg1 as subroutine argument
	call str_len
	add esp, 4             ; cleanup after call

	push eax               ; save EAX for print_u call

	kernel 4, 2, mal, mall ; SYS_WRITE, stdout, message, message length
	
	call print_u
	add esp, 4             ; cleanup after call

	push byte 10           ; pass '\n' character as subroutine argument
	call print_c
	add esp, 1             ; cleanup after call

	kernel 1, 0            ; SYS_EXIT, exit code
