%include "kernel.inc"
%include "print.inc"
%include "scan.inc"

global _start

section .rodata
	mep   db "Usage: ./fibonacci <count>", 10
	mepl  equ $-mep
	ms    db "Fibonacci sequence: ", 10
	msl   equ $-ms
	del   db ", "
	dell  equ $-del
	nl    db 10
	nll   equ $-nl

section .text
_start:
	mov ebp, esp           ; init EBP

	cmp dword [ebp], 2     ; if argc is equal to 2, jump
	je .begin
	kernel 4, 2, mep, mepl ; SYS_WRITE, stdout, message, message length
	kernel 1, 1            ; SYS_EXIT, exit code

.begin:
	push dword [ebp+8]     ; pass arg1 to subroutine
	call sscan_u
	add esp, 4             ; cleanup after call

	test eax, eax          ; if numbers count is 0, jump to .end
	jz .end

; First two numbers

	mov ebx, eax           ; move EAX to EBX so it is not erased by prints

	kernel 4, 2, ms, msl   ; print start message

	push dword 0           ; print 0
	call print_u
	add esp, 4             ; cleanup after call

	dec ebx                ; decrement numbers count
	test ebx, ebx          ; if is zero, jump to .end_print
	jz .end_print

	kernel 4, 2, del, dell ; print delimiter

	push dword 1           ; print 1
	call print_u
	add esp, 4             ; cleanup after call

	dec ebx                ; decrement numbers count
	test ebx, ebx          ; if is zero, jump to .end_print
	jz .end_print

	kernel 4, 2, del, dell ; print delimiter

; Main loop

	mov ecx, ebx           ; numbers count (ECX) = EBX
	xor ebx, ebx           ; prev val (EBX)      = 0
	mov eax, 1             ; cur val (EAX)       = 1
                           ; temp (EDX)

.loop:
	mov edx, eax           ; move cur val to temp
	add eax, ebx           ; add prev val to cur val
	mov ebx, edx           ; move temp to prev val
	
	push ecx               ; save ECX
	push eax               ; save EAX

	push eax               ; print EAX
	call print_u
	add esp, 4             ; cleanup after call

	cmp dword [esp+4], 1   ; do not print delim at last iteration ([esp+4]=ECX)
	je .after_del

	kernel 4, 2, del, dell ; print delimiter

.after_del:
	pop eax                ; restore EAX
	pop ecx                ; restore ECX
	loop .loop

; End section

.end_print:
	kernel 4, 2, nl, nll  ; print \n

.end:
	kernel 1, 0           ; SYS_EXIT, exit code
