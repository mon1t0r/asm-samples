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

	mov ecx, eax         ; numbers count
	mov eax, 1           ; cur val
	xor ebx, ebx         ; prev val

.loop:
	mov edx, eax         ; move cur val to temp
	add eax, ebx         ; add prev val to cur val
	mov ebx, edx         ; move temp to prev val
	
	push ecx             ; save ECX
	push ebx             ; save EBX

	push eax             ; set print number from EAX & save EAX
	call print_u

	cmp dword [esp+8], 1 ; do not print delim at last iteration ([esp+8]=ECX)
	je .after_delim

	push delim           ; set print str to delim
	call print_s
	add esp, 4           ; cleanup after call
.after_delim:

	pop eax              ; restore EAX & cleanup after call print_u
	pop ebx              ; restore EBX
	pop ecx              ; restore ECX
	loop .loop

	push 10              ; \n character
	call print_c
	add esp, 1           ; cleanup after call

.end:
	xor ebx, ebx         ; exit code 0
	mov eax, 1           ; SYS_EXIT
	int 0x80
