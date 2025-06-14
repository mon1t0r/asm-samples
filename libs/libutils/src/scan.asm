global sscan_u
global sscan_x
global sscan_lx

; sscan_u (char_ptr)
sscan_u:
	push ebp              ; prologue
	mov ebp, esp
	push ebx

	xor eax, eax          ; EAX - result
	mov ebx, 10           ; EBX - multiplier (base 10)
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

; sscan_x (char_ptr)
sscan_x:
	push ebp              ; prologue
	mov ebp, esp

	xor eax, eax          ; EAX - result
	mov ecx, [ebp+8]      ; ECX - string pos address

	cmp byte [ecx], 0     ; string has length 0 - first byte is 0
	jz .ret

.loop:
	mov dl, [ecx]         ; move char value to DL

	cmp dl, 'a'           ; if char value is lowercase character
	jge .char_is_lower
	cmp dl, 'A'           ; if char value is uppercase character
	jge .char_is_upper
                          ; otherwise char value is digit character
	sub dl, '0'           ; subtract ascii '0'
	jmp .loop_end
.char_is_upper:
	sub dl, ('A'-10)      ; subtract ascii 'A' and add 10
	jmp .loop_end
.char_is_lower:
	sub dl, ('a'-10)      ; subtract ascii 'a' and add 10

.loop_end:
	shl eax, 4            ; shift EAX to left so lower 4 bits are 0
	and dl, 0xF           ; cut DL to 4 lower bits
	or al, dl             ; move lower 4 bits of DL to lower 4 bits of AL
	inc ecx               ; increment string pos address
	cmp byte [ecx], 0     ; end of string
	jnz .loop

.ret:
	mov esp, ebp          ; epilogue
	pop ebp
	ret
