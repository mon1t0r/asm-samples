%include "kernel.inc"

global _start

section .bss
	bf     resb 4096
	bfl    equ  $-bf
	src_fd resd 1
	dst_fd resd 1

section .rodata
	mep   db "Usage: ./copy <src_filename> <dst_filename>", 10
	mepl  equ $-mep
	meor  db "open() on source file error", 10
	meorl equ $-meor
	meow  db "open() on destination file error", 10
	meowl equ $-meow

section .text
_start:
	mov ebp, esp                ; init EBP

	cmp dword [ebp], 3          ; if argc is equal to 3, jump
	je .begin
	kernel 4, 2, mep, mepl      ; SYS_WRITE, stdout, message, message length
	kernel 1, 1                 ; SYS_EXIT, exit code

.begin:
	mov esi, [ebp+8]            ; second parameter (first is executable name)
	kernel 5, esi, 0            ; SYS_OPEN, filename, O_RDONLY, mode (ignored)
	cmp eax, -1                 ; if SYS_OPEN was successfull, jump
	jne .open_src_ok

	kernel 4, 2, meor, meorl    ; SYS_WRITE, stdout, message, message length
	kernel 1, 2                 ; SYS_EXIT, exit code

.open_src_ok:
	mov [src_fd], eax           ; move read file descriptor to [src_fd]

	mov esi, [ebp+12]           ; third parameter

	kernel 5, esi, 0x241, 0666q ; SYS_OPEN, filename,
                                ; O_WRONLY | O_CREAT | O_TRUNK, mode
	cmp eax, -1                 ; if SYS_OPEN was successfull, jump
	jne .open_dst_ok

	kernel 4, 2, meow, meowl    ; SYS_WRITE, stdout, message, message length
	kernel 1, 3                 ; SYS_EXIT, exit code

.open_dst_ok:
	mov [dst_fd], eax           ; move write file descriptor to [dst_fd]

.loop:
	kernel 3, [src_fd], bf, bfl ; SYS_READ, source file descriptor, buffer,
                                ; buffer length
	cmp eax, 0                  ; if error or EOF situation occured, jump
	jle .end

	kernel 4, [dst_fd], bf, eax ; SYS_WRITE, destination file descriptor,
                                ; buffer, filled byte count in buffer
	jmp .loop                   ; repeat read-write

.end:
	kernel 6, [src_fd]          ; SYS_CLOSE, source file descriptor
	kernel 6, [dst_fd]          ; SYS_CLOSE, destination file descriptor
	kernel 1, 0                 ; SYS_EXIT, exit code
