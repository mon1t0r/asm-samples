%include "string.inc"

global print_u
global print_s
global print_c

; print_u (uint_val)
print_u:
	push ebp              ; prologue
	mov ebp, esp
	push ebx

	sub esp, 10           ; allocate space for string (max 10 chars for uint)

	mov eax, [ebp+8]      ; EAX - division divident LOWER
	mov ebx, 10           ; EBX - division denominator
	lea ecx, [ebp-5]      ; ECX - start string pos address

.loop:
	xor edx, edx          ; EDX - division divident HIGHER, division remainder
	div ebx               ; divide value

	add dl, '0'           ; convert digit to ASCII sym in DL (always < 255)
	mov [ecx], dl         ; write ASCII sym to string pos
	dec ecx               ; decrement string pos (writing in reverse order)

	test eax, eax         ; test if result is 0
	jnz .loop

	mov eax, 4            ; SYS_WRITE
	mov ebx, 1            ; write to stdout
	lea edx, [ebp-5]      ; load start string address
	sub edx, ecx          ; subtract end string pos address (result=length)
	inc ecx               ; increment string pos (to point at actual start)
	int 0x80

	add esp, 10           ; cleanup local variables

	pop ebx               ; epilogue
	mov esp, ebp
	pop ebp
	ret

; print_s (char_ptr)
print_s:
	push ebp              ; prologue
	mov ebp, esp
	push ebx

	push dword [ebp+8]    ; push string pointer as argument
	call str_len
	add esp, 4            ; cleanup after call

	mov edx, eax          ; string length
	mov eax, 4            ; SYS_WRITE
	mov ebx, 1            ; write to stdout
	mov ecx, [ebp+8]      ; string pointer
	int 0x80

	pop ebx               ; epilogue
	mov esp, ebp
	pop ebp
	ret

; print_c (char_val)
print_c:
	push ebp              ; prologue
	mov ebp, esp
	push ebx

	mov eax, 4            ; SYS_WRITE
	mov ebx, 1            ; write to stdout
	lea ecx, [ebp+8]      ; string pointer
	mov edx, 1            ; string length
	int 0x80
	
	pop ebx               ; epilogue
	mov esp, ebp
	pop ebp
	ret

