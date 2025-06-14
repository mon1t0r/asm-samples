global str_len
global strncpy

; str_len (char_ptr)
str_len:
	push ebp          ; prologue
	mov ebp, esp

	mov eax, [ebp+8]  ; move string pointer to EAX
	mov edx, eax      ; move string pointer to EDX

.loop:
	cmp byte [eax], 0 ; compare character to 0
	jz .end           ; quit if end of string reached
	inc eax           ; increment string pointer
	jmp .loop         ; repeat loop

.end:
	sub eax, edx      ; subtract start pointer from end pointer

	mov esp, ebp      ; epilogue
	pop ebp
	ret

; strncpy (char_ptr_dst, char_ptr_src, int_cnt)
strncpy:
	push ebp          ; prologue
	mov ebp, esp
	push edi
	push esi

	mov edi, [ebp+8]  ; move destination pointer to EDI
	mov esi, [ebp+12] ; move source pointer to ESI
	mov ecx, [ebp+16] ; move char count to ECX

	rep movsb

	pop esi           ; epilogue
	pop edi
	mov esp, ebp
	pop ebp
	ret
