%include "kernel.inc"

global _start

section .rodata
	mep   db "Usage: ./arg_cmp <arg1> <arg2>", 10
	mepl  equ $-mep
	mse   db "arg1 is equal to arg2", 10
	msel  equ $-mse
	msne  db "arg1 is NOT equal to arg2", 10
	msnel equ $-msne

section .text
_start:
	mov ebp, esp              ; init EBP

	cmp dword [ebp], 3        ; if argc is equal to 3, jump
	je .begin
	kernel 4, 2, mep, mepl    ; SYS_WRITE, stdout, message, message length
	kernel 1, 1               ; SYS_EXIT, exit code

.begin:
	mov esi, [ebp+8]          ; move arg1 string pointer to ESI
	mov edi, [ebp+12]         ; move arg2 string pointer to EDI

.loop:
	mov al, byte [esi]        ; move character from ESI to AL
	or al, byte [edi]         ; perform OR to AL and [EDI]
	jz .end_eq                ; jump to end only if [ESI] and [EDI] is 0

	cmpsb                     ; compare [ESI] and [EDI] and increment
	jnz .end_diff             ; if they are different, jump to .end_diff
	jmp .loop                 ; continue loop otherwise

.end_eq:
	mov edx, msel             ; message length
	mov ecx, mse              ; message pointer
	jmp .end

.end_diff:
	mov edx, msnel            ; message length
	mov ecx, msne             ; message pointer

.end:
	kernel 4, 1 ; SYS_WRITE, stdout

	kernel 1, 0 ; SYS_EXIT, exit code
