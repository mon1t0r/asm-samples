global sscan_u

; sscan_u (char_ptr)
sscan_u:
	push ebp              ; prologue
	mov ebp, esp
	push ebx

	xor eax, eax          ; EAX - result
	mov ebx, 10           ; EBX - multiplier
	mov ecx, [ebp+8]      ; ECX - string pos address
	xor edx, edx          ; EDX - temp for chars (only DL is used)

	cmp byte [ecx], 0     ; string has length 0 - first byte is 0
	jz .ret_zero

.loop:
	mul ebx               ; multiply EAX (result) by EBX (multiplier)
	jo .ret_zero          ; overflow occured

	mov dl, [ecx]         ; move char value to DL
	add eax, edx          ; add char value to EAX
	sub eax, '0'          ; subtract ascii '0'

	inc ecx               ; increment string pos address
	cmp byte [ecx], 0     ; end of string
	jnz .loop
	jmp .ret

.ret_zero:
	xor eax, eax          ; zero result

.ret:
	pop ebx               ; epilogue
	mov esp, ebp
	pop ebp
	ret

