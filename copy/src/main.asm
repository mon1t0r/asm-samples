%include "kernel.inc"

global _start

section .bss
	buf     resb 4096
	buf_len equ  $-buf
	src_fd  resd 1
	dst_fd  resd 1

section .rodata
	msg_err_params         db "Usage: ./copy <src_filename> <dst_filename>", 10
	msg_err_params_len     equ $-msg_err_params
	msg_err_open_read      db "open() on source file error", 10
	msg_err_open_read_len  equ $-msg_err_open_read
	msg_err_open_write     db "open() on destination file error", 10
	msg_err_open_write_len equ $-msg_err_open_write

section .text
_start:
	mov ebp, esp         ; init EBP

	cmp dword [ebp], 2   ; if argc is greater than 2, jump to begin
	jg .begin
; SYS_WRITE, stdout, message, message length
	kernel 4, 2, msg_err_params, msg_err_params_len
; SYS_EXIT, exit code
	kernel 1, 1

.begin:
	mov esi, [ebp+8]     ; second parameter (first is executable name)
; SYS_OPEN, filename, O_RDONLY, mode (ignored)
	kernel 5, esi, 0
	cmp eax, -1          ; if SYS_OPEN was successfull, jump to open_src_ok
	jne .open_src_ok
; SYS_WRITE, stdout, message, message length
	kernel 4, 2, msg_err_open_read, msg_err_open_read_len
; SYS_EXIT, exit code
	kernel 1, 2

.open_src_ok:
	mov [src_fd], eax    ; move read file descriptor to [src_fd]

	mov esi, [ebp+12]     ; third parameter
; SYS_OPEN, filename, O_WRONLY, O_CREAT, O_TRUNK, mode
	kernel 5, esi, 0x241, 0666q
	cmp eax, -1          ; if SYS_OPEN was successfull, jump to open_dst_ok
	jne .open_dst_ok
; SYS_WRITE, stdout, message, message length
	kernel 4, 2, msg_err_open_write, msg_err_open_write_len
; SYS_EXIT, exit code
	kernel 1, 3

.open_dst_ok:
	mov [dst_fd], eax    ; move write file descriptor to [dst_fd]

.loop:
; SYS_READ, source file descriptor, buffer, buffer length
	kernel 3, [src_fd], buf, buf_len
	cmp eax, 0          ; if error or EOF situation occured, jump to .end
	jle .end
; SYS_WRITE, destination file descriptor, buffer, bytes count in buffer
	kernel 4, [dst_fd], buf, eax
	jmp .loop           ; repeat read-write

.end:
; SYS_CLOSE, source file descriptor
	kernel 6, [src_fd]
; SYS_CLOSE, destination file descriptor
	kernel 6, [dst_fd]
; SYS_EXIT, exit code
	kernel 1, 0
