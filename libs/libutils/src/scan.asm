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

; sscan_lx (char_ptr)
sscan_lx:
	push ebp              ; prologue
	mov ebp, esp
	sub esp, 8            ; allocate space for result

	mov dword [ebp-8], 0  ; [ebp-8] - result
	mov dword [ebp-4], 0
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
	shl dword [ebp-4], 4  ; shift [ebp-4] to left so lower 4 bits are 0
	mov eax, [ebp-8]      ; move [ebp-8] to EAX
	shr eax, 28           ; shift EAX to right, so only 4 higher bits are left
	or [ebp-4], al        ; move lower 4 bits of AL to lower 4 bits of [ebp-4]
	shl dword [ebp-8], 4  ; shift [ebp-8] to left so lower 4 bits are 0

	and dl, 0xF           ; mask DL to 4 lower bits
	or [ebp-8], dl        ; move lower 4 bits of DL to lower 4 bits of [ebp-8]

	inc ecx               ; increment string pos address
	cmp byte [ecx], 0     ; end of string
	jnz .loop

.ret:
	mov edx, [ebp-4]      ; first part of the result
	mov eax, [ebp-8]      ; second part of the result
	mov esp, ebp          ; epilogue
	pop ebp
	ret
