global str_len

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
