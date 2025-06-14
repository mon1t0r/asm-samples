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
	nl   db 10
	nll  equ $-nl

section .text
_start:
	mov ebp, esp           ; init EBP
	sub esp, 16            ; allocate space for local variables
                           ; [ebp-8] - input
                           ; [ebp-16] - result

	cmp dword [ebp], 2     ; if argc is equal to 2, jump
	je .begin
	kernel 4, 2, mep, mepl ; SYS_WRITE, stdout, message, message length
	kernel 1, 1            ; SYS_EXIT, exit code

.begin:
	mov eax, [ebp+8]       ; move radius string pointer to EAX
	push eax               ; pass string pointer as sscan subroutine argument
	call sscan_lx
	add esp, 4             ; cleanup after call
	mov [ebp-4], edx       ; move input to [ebp-8]
	mov [ebp-8], eax

	push edx               ; push input for calculation subroutine call
	push eax
	call circle_area
	add esp, 8             ; cleanup after call
	fstp qword [ebp-16]    ; save double result to [ebp-16]

	push dword [ebp-12]    ; push subroutine arguments
	push dword [ebp-16]
	push mcal
	push mca
	call print_result
	add esp, 16            ; cleanup after call

	push dword [ebp-4]     ; push input for calculation subroutine call
	push dword [ebp-8]
	call sphere_surface
	add esp, 8             ; cleanup after call
	fstp qword [ebp-16]    ; save double result to [ebp-16]

	push dword [ebp-12]    ; push subroutine arguments
	push dword [ebp-16]
	push mssl
	push mss
	call print_result
	add esp, 16            ; cleanup after call

	push dword [ebp-4]     ; push input for calculation subroutine call
	push dword [ebp-8]
	call sphere_volume
	add esp, 8             ; cleanup after call
	fstp qword [ebp-16]    ; save double result to [ebp-16]

	push dword [ebp-12]    ; push subroutine arguments
	push dword [ebp-16]
	push msvl
	push msv
	call print_result
	add esp, 16            ; cleanup after call

	kernel 1, 0            ; SYS_EXIT, exit code

; print_result (char_ptr_msg, uint_msg_len, double_result)
print_result:
	push ebp               ; prologue
	mov ebp, esp

	mov eax, [ebp+8]       ; move msg pointer to EAX
	mov ecx, [ebp+12]      ; move msg length to ECX

	kernel 4, 2, eax, ecx  ; SYS_WRITE, stdout, message, message length

	push dword [ebp+20]    ; pass result as print subroutine argument
	push dword [ebp+16]
	call print_lx
	add esp, 8             ; cleanup after call

	kernel 4, 2, nl, nll   ; print \n

	mov esp, ebp           ; epilogue
	pop ebp
	ret

; circle_area (double_radius)
circle_area:
	push ebp               ; prologue
	mov ebp, esp

	fld qword [ebp+8]      ; load double value from argument [ebp+8]
	fmul st0, st0          ; power of 2 in st0
	fldpi                  ; push pi
	fmulp st1, st0         ; multiply st1 and st0, write to st1, pop

	mov esp, ebp           ; epilogue
	pop ebp
	ret

; sphere_surface (double_radius)
sphere_surface:
	push ebp               ; prologue
	mov ebp, esp
	sub esp, 2             ; allocate space for local variable

	fld qword [ebp+8]      ; load double value from argument [ebp+8]
	fmul st0, st0          ; power of 2 in st0
	fldpi                  ; push pi
	fmulp st1, st0         ; multiply st1 and st0, pop

	mov word [ebp-2], 4    ; load 4 into local variable [ebp-2]
	fild word [ebp-2]      ; push local variable
	fmulp st1, st0         ; multiply st1 and st0, pop

	mov esp, ebp           ; epilogue
	pop ebp
	ret

; sphere_volume (double_radius)
sphere_volume:
	push ebp               ; prologue
	mov ebp, esp
	sub esp, 2             ; allocate space for local variable

	fld qword [ebp+8]      ; load double value from argument [ebp+8]
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

