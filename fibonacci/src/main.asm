%include "kernel.inc"

global _start

extern print_u
extern print_s
extern print_c

extern sscan_u

section .rodata
	delim db ", ", 0

section .text
_start:
	mov ebp, esp         ; init EBP

	cmp dword [ebp], 2   ; if argc is less than 2, jump to .end
	jl .end

	push dword [ebp+8]   ; arg1
	call sscan_u
	add esp, 4           ; cleanup after call

	test eax, eax        ; if numbers count is 0, jump to .end
	jz .end

; First two numbers

	mov ebx, eax         ; move EAX to EBX so it is not erased by prints

	push dword 0         ; print 0
	call print_u
	add esp, 4           ; cleanup after call

	dec ebx              ; decrement numbers count
	test ebx, ebx        ; if is zero, jump to .end_print
	jz .end_print

	push delim           ; print delimiter
	call print_s
	add esp, 4           ; cleanup after call

	push dword 1         ; print 1
	call print_u
	add esp, 4           ; cleanup after call

	dec ebx              ; decrement numbers count
	test ebx, ebx        ; if is zero, jump to .end_print
	jz .end_print

	push delim           ; print delimiter
	call print_s
	add esp, 4           ; cleanup after call

; Main loop

	mov ecx, ebx         ; numbers count
	xor ebx, ebx         ; prev val
	mov eax, 1           ; cur val

.loop:
	mov edx, eax         ; move cur val to temp
	add eax, ebx         ; add prev val to cur val
	mov ebx, edx         ; move temp to prev val
	
	push ecx             ; save ECX
	push eax             ; save EAX

	push eax             ; print EAX
	call print_u
	add esp, 4           ; cleanup after call

	cmp dword [esp+4], 1 ; do not print delim at last iteration ([esp+4]=ECX)
	je .after_delim

	push delim           ; print delimiter
	call print_s
	add esp, 4           ; cleanup after call
.after_delim:

	pop eax              ; restore EAX
	pop ecx              ; restore ECX
	loop .loop

; End section

.end_print:
	push byte 10         ; \n character
	call print_c
	add esp, 1           ; cleanup after call

.end:
    kernel 1, 0          ; SYS_EXIT
