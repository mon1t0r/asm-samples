global _start

section .rodata
	msg_str_eq       db "arg1 is equal to arg2", 10
	msg_str_eq_len   equ $-msg_str_eq

	msg_str_diff     db "arg1 is NOT equal to arg2", 10
	msg_str_diff_len equ $-msg_str_diff

section .text
_start:
	mov ebp, esp              ; init EBP

	cmp dword [ebp], 2        ; if argc is greater than 2
	jg .start
	jmp .end

.start:
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
	mov edx, msg_str_eq_len   ; string length
	mov ecx, msg_str_eq       ; string pointer
	jmp .end_write

.end_diff:
	mov edx, msg_str_diff_len ; string length
	mov ecx, msg_str_diff     ; string pointer

.end_write:
	mov eax, 4                ; SYS_WRITE
	mov ebx, 1                ; write to stdout
	int 0x80

.end:
	xor ebx, ebx              ; exit code 0
	mov eax, 1                ; SYS_EXIT
	int 0x80
