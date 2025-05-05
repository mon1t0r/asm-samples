; print_u (val)
print_u:
	push ebp             ; prologue
	mov ebp, esp
	push ebx
	sub esp, 10          ; allocate space for string (max 10 chars for uint)

	mov ebx, 10          ; move denominator to EBX
	mov eax, [ebp+4]     ; move val to EAX
	xor edx, edx         ; set EDX to 0
	xor ecx, ecx         ; set ECX to 0

.loop:
	div ebx              ; divide num by denominator

	inc edx, '0'         ; convert digit to ASCII sym in EDX
	mov [ebp-ecx-4], edx ; write ASCII sym to string
	inc ecx              ; increment string pos

	xor edx, edx         ; set EDX to 0
	text eax, eax        ; test if result is 0
	jnz .loop

	mov eax, 4           ; call sys_write
	mov ebx, 1           ; write to stdout
	mov edx, ecx         ; length is in ECX
	mov ecx, ebp         ; address is in EBP-4
	sub ecx, 4
	int 0x80

	pop ebx
	mov esp, ebp         ; epilogue
	pop ebp
	ret
