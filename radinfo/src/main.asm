%include "kernel.inc"
%include "print.inc"
%include "scan.inc"

global _start

section .rodata
	mep  db "Usage: ./radinfo <radius>", 10
	mepl equ $-mep
	mca  db "Circle area: "
	mcal equ $-mca
	mss  db "Sphere surface: "
	mssl equ $-mss
	msv  db "Sphere volume: "
	msvl equ $-msv

section .text
_start:
	mov ebp, esp           ; init EBP
	sub esp, 8             ; allocate space for local variables

	cmp dword [ebp], 1     ; if argc is greater than 1, jump to .begin
	jg .begin
	kernel 4, 2, mep, mepl ; SYS_WRITE, stdout, message, message length
	kernel 1, 1            ; SYS_EXIT, exit code

.begin:
	mov eax, [ebp+8]       ; move radius string pointer to EAX
	push eax               ; pass string pointer as sscan subroutine argument
	call sscan_x
	add esp, 4             ; cleanup after call

	mov [ebp-4], eax       ; move input to [ebp-4]

	push eax               ; push input for calculation subroutine call
	call circle_area
	add esp, 4             ; cleanup after call
	fstp dword [ebp-8]     ; save float result to [ebp-8]

	push dword [ebp-8]     ; push subroutine arguments
	push mcal
	push mca
	call print_result
	add esp, 12            ; cleanup after call

	mov eax, [ebp-4]       ; move input to EAX
	push eax               ; push input for calculation subroutine call
	call sphere_surface
	add esp, 4             ; cleanup after call
	fstp dword [ebp-8]     ; save float result to [ebp-8]

	push dword [ebp-8]     ; push subroutine arguments
	push mssl
	push mss
	call print_result
	add esp, 12            ; cleanup after call

	mov eax, [ebp-4]       ; move input to EAX
	push eax               ; push input for calculation subroutine call
	call sphere_volume
	add esp, 4             ; cleanup after call
	fstp dword [ebp-8]     ; save float result to [ebp-8]

	push dword [ebp-8]     ; push subroutine arguments
	push msvl
	push msv
	call print_result
	add esp, 12            ; cleanup after call

	kernel 1, 0            ; SYS_EXIT, exit code

; print_result (char_ptr_msg, uint_msg_len, float_result)
print_result:
	push ebp               ; prologue
	mov ebp, esp

	mov eax, [ebp+8]       ; move msg pointer to EAX
	mov ecx, [ebp+12]      ; move msg length to ECX

	kernel 4, 2, eax, ecx  ; SYS_WRITE, stdout, message, message length

	mov eax, [ebp+16]      ; move result to EAX
	push eax               ; pass result as print subroutine argument
	call print_x
	add esp, 4             ; cleanup after call

	push dword 10          ; pass '\n' character as subroutine argument
	call print_c
	add esp, 4             ; cleanup after call

	mov esp, ebp           ; epilogue
	pop ebp
	ret

; circle_area (float_radius)
circle_area:
	push ebp               ; prologue
	mov ebp, esp

	fld dword [ebp+8]      ; load float value from argument [ebp+8]
	fmul st0, st0          ; power of 2 in st0
	fldpi                  ; push pi
	fmulp st1, st0         ; multiply st1 and st0, write to st1, pop

	mov esp, ebp           ; epilogue
	pop ebp
	ret

; sphere_surface (float_radius)
sphere_surface:
	push ebp               ; prologue
	mov ebp, esp
	sub esp, 2             ; allocate space for local variable

	fld dword [ebp+8]      ; load float value from argument [ebp+8]
	fmul st0, st0          ; power of 2 in st0
	fldpi                  ; push pi
	fmulp st1, st0         ; multiply st1 and st0, pop

	mov word [ebp-2], 4    ; load 4 into local variable [ebp-2]
	fild word [ebp-2]      ; push local variable
	fmulp st1, st0         ; multiply st1 and st0, pop

	mov esp, ebp           ; epilogue
	pop ebp
	ret

; sphere_volume (float_radius)
sphere_volume:
	push ebp               ; prologue
	mov ebp, esp
	sub esp, 2             ; allocate space for local variable

	fld dword [ebp+8]      ; load float value from argument [ebp+8]
	fld st0                ; clone top of the stack
	fmul st1               ; multiply st0 and st1, write to st0
	fmulp st1, st0         ; multiply st0 and st1, pop
	fldpi                  ; push pi
	fmulp st1, st0         ; multiply st1 and st0, write to st1, pop

	mov word [ebp-2], 4    ; load 4 into local variable [ebp-2]
	fild word [ebp-2]      ; push local variable
	fmulp st1, st0         ; multiply st1 and st0, pop

	mov word [ebp-2], 3    ; load 3 into local variable [ebp-2]
	fild word [ebp-2]      ; push local variable
	fdivp st1, st0         ; divide st1 by st0, pop

	mov esp, ebp           ; epilogue
	pop ebp
	ret

