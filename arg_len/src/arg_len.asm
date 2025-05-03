global _start

section .text
_start: mov ebp, esp       ; init EBP
		mov eax, [ebp]     ; move argc to EAX
		cmp eax, 1         ; if argc is greater than 1, jump
		jg p_start
		mov eax, 1         ; set exit code
		jmp finish

p_start:
		mov esi, [ebp+8]   ; move arg1 to esi
		call str_len

finish: mov ebx, eax
		mov eax, 1         ; SYS_EXIT
		int 0x80           ; syscall

; str_len (esi=address)
str_len:
		push ebp              ; prolog
		mov ebp, esp
		xor eax, eax          ; zero EAX
.loop:  cmp [esi+eax], byte 0 ; compare character to 0
		jz .quit              ; quit if end of string reached
		inc eax               ; increment length counter
		jmp .loop
.quit:  mov esp, ebp          ; epilog
		pop ebp
		ret
